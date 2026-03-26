<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Style guide (shader pack)

Conventions for GLSL and project structure. **Binding buffer layout** for this pack is defined only in [ARCHITECTURE.md](ARCHITECTURE.md); keep shaders consistent with that table.

## GLSL

- Prefer **forward slashes** in `#include` and asset paths for cross-platform worktrees.
- **Limits:** aim for ≤100 characters per line, ≤50 lines per function, ≤400 lines per file (split helpers into `shaders/lib/` when needed).
- **Naming:** use clear `camelCase` for functions and locals unless matching upstream shaderpack conventions in copied snippets.

## Trace tags

Link non-obvious shader logic to docs:

```glsl
// [TRACE: ARCHITECTURE.md] colortex2 packs roughness in R
```

Use `// [TRACE: <file.md>]` for WHY or contract references; avoid restating obvious code.

## Comments

- **WHY** and invariants only; skip comments that duplicate the code.
- Prefixes: `TODO:`, `FIXME:`, `NOTE:` (e.g. `NOTE: verify uniform on Iris 1.x`).

## Types and errors

- Prefer explicit encodings (e.g. normal packing) documented in ARCHITECTURE.
- At buffer boundaries, keep packing/decoding symmetric and documented in one place.

## Resources

- [ARCHITECTURE.md](ARCHITECTURE.md) — G-buffer and stage intent for this pack.
- [ROADMAP.md](ROADMAP.md) — skeleton, tooling, and verification phases (append-only planning).
- [reference/README.md](reference/README.md) — generic OptiFine/Iris reference material.
