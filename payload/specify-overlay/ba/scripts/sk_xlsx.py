#!/usr/bin/env python3
"""sk_xlsx — a minimal spreadsheet writer, standard library only.

BA-Native Spec · the WBS export's primary render (orchestrator rules §10.5,
D-O23: xlsx is the client-presentable file and is written first).

Anchors: orchestrator §10.5 *Formats & paths* — "bold header row, wrapped text,
column widths; no cell merges — the Epic value repeats per row" · build plan
D-P2-7 (Python 3, standard library only, no third-party packages).

There is no stdlib xlsx writer, so this module is one: a `.xlsx` file is a zip
of XML parts, and the six parts below are the smallest set Excel, Numbers and
LibreOffice all open. Every string is written **inline** (`t="inlineStr"`) — a
shared-string table would buy compression this file does not need and would add
a part that can fall out of sync with the sheet.

Deliberately not implemented: formulas, numbers, dates, merges, colours,
multiple sheets. The export has one sheet of text cells; anything more would be
capability this document does not ask for.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import re
import sys
import zipfile
from pathlib import Path

sys.dont_write_bytecode = True

NS_MAIN = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
NS_REL_DOC = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
NS_REL_PKG = "http://schemas.openxmlformats.org/package/2006/relationships"

# XML 1.0 forbids most control characters outright; a cell that carried one
# would produce a file no reader opens. Tab, newline and carriage return stay.
CONTROL_RE = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f]")

# style ids, as cellXfs orders them below
S_BODY = 0
S_HEADER = 1


def col_letter(n: int) -> str:
    """1 → A, 26 → Z, 27 → AA."""
    out = ""
    while n > 0:
        n, rem = divmod(n - 1, 26)
        out = chr(ord("A") + rem) + out
    return out


def esc(text: str) -> str:
    """Escape for XML element content, and drop what XML cannot carry."""
    text = CONTROL_RE.sub("", text)
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def _cell(ref: str, text: str, style: int) -> str:
    if not text:
        return '<c r="%s" s="%d"/>' % (ref, style)
    return ('<c r="%s" s="%d" t="inlineStr"><is><t xml:space="preserve">%s'
            "</t></is></c>" % (ref, style, esc(text)))


def _sheet(header, rows, widths, title=()) -> str:
    cols = "".join(
        '<col min="%d" max="%d" width="%s" customWidth="1"/>' % (i, i, w)
        for i, w in enumerate(widths, start=1)
    )
    out = [
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<worksheet xmlns="%s">' % NS_MAIN,
        "<cols>%s</cols>" % cols if cols else "",
        "<sheetData>",
    ]
    # The title block sits above the bold header row, one single-cell row per
    # line, body-styled — the header row keeps the bold to itself (D-O67; three
    # lines since D-O75, the caller's count and never this writer's).
    all_rows = [([line], S_BODY) for line in title]
    all_rows += [(header, S_HEADER)] + [(r, S_BODY) for r in rows]
    for n, (cells, style) in enumerate(all_rows, start=1):
        body = "".join(
            _cell("%s%d" % (col_letter(i), n), c, style)
            for i, c in enumerate(cells, start=1)
        )
        out.append('<row r="%d">%s</row>' % (n, body))
    out += ["</sheetData>", "</worksheet>"]
    return "".join(out)


_CONTENT_TYPES = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
    '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
    '<Default Extension="xml" ContentType="application/xml"/>'
    '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
    '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
    '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
    "</Types>"
)

_ROOT_RELS = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<Relationships xmlns="%s">'
    '<Relationship Id="rId1" Type="%s/officeDocument" Target="xl/workbook.xml"/>'
    "</Relationships>" % (NS_REL_PKG, NS_REL_DOC)
)

_WORKBOOK_RELS = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<Relationships xmlns="%s">'
    '<Relationship Id="rId1" Type="%s/worksheet" Target="worksheets/sheet1.xml"/>'
    '<Relationship Id="rId2" Type="%s/styles" Target="styles.xml"/>'
    "</Relationships>" % (NS_REL_PKG, NS_REL_DOC, NS_REL_DOC)
)

# Two cell formats and nothing else: body (wrapped, top-aligned) and the bold
# header row. Excel requires the gray125 second fill whether or not it is used.
_STYLES = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<styleSheet xmlns="%s">'
    '<fonts count="2">'
    '<font><sz val="11"/><name val="Calibri"/></font>'
    '<font><b/><sz val="11"/><name val="Calibri"/></font>'
    "</fonts>"
    '<fills count="2">'
    '<fill><patternFill patternType="none"/></fill>'
    '<fill><patternFill patternType="gray125"/></fill>'
    "</fills>"
    '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
    '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
    '<cellXfs count="2">'
    '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1">'
    '<alignment vertical="top" wrapText="1"/></xf>'
    '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1">'
    '<alignment vertical="top" wrapText="1"/></xf>'
    "</cellXfs>"
    "</styleSheet>" % NS_MAIN
)


def _workbook(sheet_name: str) -> str:
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="%s" xmlns:r="%s">'
        '<sheets><sheet name="%s" sheetId="1" r:id="rId1"/></sheets>'
        "</workbook>" % (NS_MAIN, NS_REL_DOC, esc(sheet_name))
    )


def write(path, header, rows, widths=None, sheet_name="WBS", title=()) -> Path:
    """Write one sheet of text cells to `path`, overwriting whatever is there.

    `header` is the pinned column set; `rows` are equal-length cell lists;
    `widths` are per-column character widths. Empty cells keep the body style,
    so a blank cell wraps and aligns like the rest of the sheet. `title` is the
    optional title block — one single-cell row per line, rendered above the
    header row (D-O67 · D-O75); the csv render passes none. The line count is
    the caller's: this writer renders whatever it is handed.
    """
    path = Path(path)
    widths = widths or [24] * len(header)
    if len(widths) != len(header):
        raise ValueError("widths (%d) do not match the header (%d)"
                         % (len(widths), len(header)))
    for i, row in enumerate(rows):
        if len(row) != len(header):
            raise ValueError("row %d has %d cells, the header has %d"
                             % (i + 1, len(row), len(header)))

    path.parent.mkdir(parents=True, exist_ok=True)
    # Fixed timestamps: the export is derived and regenerated on demand, and a
    # wall-clock date inside the zip would make two identical runs differ.
    stamp = (1980, 1, 1, 0, 0, 0)
    parts = [
        ("[Content_Types].xml", _CONTENT_TYPES),
        ("_rels/.rels", _ROOT_RELS),
        ("xl/workbook.xml", _workbook(sheet_name)),
        ("xl/_rels/workbook.xml.rels", _WORKBOOK_RELS),
        ("xl/styles.xml", _STYLES),
        ("xl/worksheets/sheet1.xml", _sheet(header, rows, widths, title)),
    ]
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        for name, text in parts:
            info = zipfile.ZipInfo(name, date_time=stamp)
            info.compress_type = zipfile.ZIP_DEFLATED
            z.writestr(info, text.encode("utf-8"))
    return path
