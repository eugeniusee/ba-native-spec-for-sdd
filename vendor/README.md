# vendor/

Offline fallback for the Spec Kit contact (build plan D-P2-9).

`install.sh` reaches Spec Kit in one of two ways, in this order:

1. **Pinned network install (default)** —
   `uvx --from git+https://github.com/github/spec-kit.git@v0.12.5 specify init --here --integration claude`
2. **Offline fallback** — `vendor/spec-kit-v0.12.5.zip`, used when `--offline` is
   passed or when the network install fails.

The archive is **not committed to this repo** (it is upstream's release artifact,
not ours). Populate it once per clone:

```sh
curl -fsSL -o vendor/spec-kit-v0.12.5.zip \
  https://github.com/github/spec-kit/archive/refs/tags/v0.12.5.zip
```

`install.sh --offline` runs `specify init` out of the unpacked archive via
`uvx --from <unpacked-dir> specify …`, so the pin is byte-identical to the
network path.

**Pin discipline (D-P2-8).** v0.12.5 is what Phase 2 builds and exit-tests
against. Phase 4 owns the rollout freeze and any pin bump. A bump changes
`SPECKIT_PIN` in `install.sh`, this file's URL, and the `ba/manifest.md` vector —
and re-runs the S1 and S9 exit tests.
