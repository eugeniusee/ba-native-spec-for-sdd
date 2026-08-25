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

Deliberately not implemented: formulas, numbers, dates, merges, colours. Every
cell is text.

**Multiple sheets** (source-audit definition §6b, D-S6): `write_book()` writes a
workbook of several sheets, each with its own title block, header row, rows and
widths. `write()` is the one-sheet call and keeps its contract and its bytes —
`/ba-wbs`'s workbook is byte-for-byte what it was before the extension, and the
suite asserts it. Nothing else about the format moves: the same two cell
formats, the same inline strings, the same fixed zip timestamps.

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

# Excel's own sheet-name rules: 31 characters, and five punctuation marks plus
# the backslash are forbidden. A name that breaks them produces a file no reader
# opens, so it is refused here rather than written.
SHEET_NAME_BAD = set(r":\/?*[]")
SHEET_NAME_MAX = 31


def _check_sheet_name(name: str) -> str:
    if not name or len(name) > SHEET_NAME_MAX:
        raise ValueError("sheet name %r must be 1–%d characters"
                         % (name, SHEET_NAME_MAX))
    bad = sorted(SHEET_NAME_BAD & set(name))
    if bad:
        raise ValueError("sheet name %r carries %s" % (name, " ".join(bad)))
    return name


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


def _content_types(n_sheets: int) -> str:
    """One Override per worksheet, then styles — the order Excel writes them.

    At n_sheets == 1 this is byte-identical to the single-sheet part this module
    emitted before the multi-sheet extension.
    """
    sheets = "".join(
        '<Override PartName="/xl/worksheets/sheet%d.xml" '
        'ContentType="application/vnd.openxmlformats-officedocument.'
        'spreadsheetml.worksheet+xml"/>' % i
        for i in range(1, n_sheets + 1)
    )
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
        + sheets +
        '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
        "</Types>"
    )


_ROOT_RELS = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<Relationships xmlns="%s">'
    '<Relationship Id="rId1" Type="%s/officeDocument" Target="xl/workbook.xml"/>'
    "</Relationships>" % (NS_REL_PKG, NS_REL_DOC)
)


def _workbook_rels(n_sheets: int) -> str:
    """rId1…rIdN the worksheets in order, rId(N+1) the stylesheet."""
    rels = "".join(
        '<Relationship Id="rId%d" Type="%s/worksheet" '
        'Target="worksheets/sheet%d.xml"/>' % (i, NS_REL_DOC, i)
        for i in range(1, n_sheets + 1)
    )
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="%s">' % NS_REL_PKG
        + rels
        + '<Relationship Id="rId%d" Type="%s/styles" Target="styles.xml"/>'
          % (n_sheets + 1, NS_REL_DOC)
        + "</Relationships>"
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


def _workbook(sheet_names) -> str:
    """The sheet list, in the order the caller handed them over.

    A single name renders exactly the part this module emitted before the
    multi-sheet extension.
    """
    sheets = "".join(
        '<sheet name="%s" sheetId="%d" r:id="rId%d"/>'
        % (esc(_check_sheet_name(name)), i, i)
        for i, name in enumerate(sheet_names, start=1)
    )
    return (
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="%s" xmlns:r="%s">'
        "<sheets>%s</sheets>"
        "</workbook>" % (NS_MAIN, NS_REL_DOC, sheets)
    )


def write(path, header, rows, widths=None, sheet_name="WBS", title=()) -> Path:
    """Write one sheet of text cells to `path`, overwriting whatever is there.

    `header` is the pinned column set; `rows` are equal-length cell lists;
    `widths` are per-column character widths. Empty cells keep the body style,
    so a blank cell wraps and aligns like the rest of the sheet. `title` is the
    optional title block — one single-cell row per line, rendered above the
    header row (D-O67 · D-O75); the csv render passes none. The line count is
    the caller's: this writer renders whatever it is handed.

    One sheet is the whole contract here, and the bytes are unchanged by the
    multi-sheet extension: this is `write_book()` with a single sheet.
    """
    return write_book(path, [(sheet_name, header, rows, widths, title)])


def write_book(path, sheets) -> Path:
    """Write a workbook of several sheets, overwriting whatever is there.

    `sheets` is an ordered sequence of `(name, header, rows, widths, title)` —
    the same five arguments `write()` takes, once per sheet. Every sheet carries
    its own title block, because a sheet a reader opens alone must still say
    which run it came from (source-audit definition §6b, D-S6).

    `widths` may be None for the 24-character default. Sheet names are checked
    against Excel's own rules before a byte is written.
    """
    path = Path(path)
    sheets = list(sheets)
    if not sheets:
        raise ValueError("a workbook needs at least one sheet")

    prepared = []
    for name, header, rows, widths, title in sheets:
        _check_sheet_name(name)
        w = list(widths) if widths else [24] * len(header)
        if len(w) != len(header):
            raise ValueError("%s: widths (%d) do not match the header (%d)"
                             % (name, len(w), len(header)))
        for i, row in enumerate(rows):
            if len(row) != len(header):
                raise ValueError("%s: row %d has %d cells, the header has %d"
                                 % (name, i + 1, len(row), len(header)))
        prepared.append((name, header, list(rows), w, tuple(title or ())))

    names = [s[0] for s in prepared]
    if len(set(names)) != len(names):
        raise ValueError("two sheets share a name: %s" % ", ".join(names))

    path.parent.mkdir(parents=True, exist_ok=True)
    # Fixed timestamps: the export is derived and regenerated on demand, and a
    # wall-clock date inside the zip would make two identical runs differ.
    stamp = (1980, 1, 1, 0, 0, 0)
    parts = [
        ("[Content_Types].xml", _content_types(len(prepared))),
        ("_rels/.rels", _ROOT_RELS),
        ("xl/workbook.xml", _workbook(names)),
        ("xl/_rels/workbook.xml.rels", _workbook_rels(len(prepared))),
        ("xl/styles.xml", _STYLES),
    ]
    for i, (_, header, rows, w, title) in enumerate(prepared, start=1):
        parts.append(("xl/worksheets/sheet%d.xml" % i,
                      _sheet(header, rows, w, title)))
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        for name, text in parts:
            info = zipfile.ZipInfo(name, date_time=stamp)
            info.compress_type = zipfile.ZIP_DEFLATED
            z.writestr(info, text.encode("utf-8"))
    return path
