<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

## Active Tasks
- [ ] In-game smoke verification for Borderlands-style pass v1 on MC 26.1 + Iris (compile, sliders, visuals)
- [x] Borderlands-style stylization pass v1 (strong outlines + toon bands) added to `shaders/composite.fsh`
- [x] Shader skeleton created (`shaders.properties`, `composite/final`, `lib/`, `lang/`)
- [x] Initial documentation and architecture setup
- [x] Git initialization and first commit
- [x] Document buffer layout in ARCHITECTURE.md (aligned with My_Thoughts)
- [x] Documentation depth: preservation headers, reference index, STYLE_GUIDE, navigation
- [ ] Define shader pipeline in code (G-buffers, composite, final)
- [ ] MVP shader pack (basic color adjustment/lighting)

## Blocked Items
- [None]

## Out-of-Scope Observations
- Iris/OptiFine option key syntax in `shaders.properties` may need in-game verification on MC 26.1 (`variable.float.*` and `variable.int.*` usage); fail-fast check during first pack load.
- Confirm GLSL `#version` / Iris shader feature set for **26.1** (Iris docs or in-game compile); see [TARGET_PLATFORM.md](TARGET_PLATFORM.md).
- Define minimum GPU/OS support policy when ready (still open in §0).

## Recent Context (last 5 actions)
1. Tuned stylization defaults down (`OUTLINE_*`, `SHADE_*`) after visual overdraw/noise report.
2. Updated `edge_detect.glsl` to gate normal edges behind depth changes and tightened edge thresholds.
3. Updated `composite.fsh` to use dark-brown outline tint and capped blend weight (less black crush).
4. Fixed Iris parsing failures in `shaders/shaders.properties` by converting custom variables to valid single-value expressions.
5. Removed unresolved `sliders=` / `screen=` option bindings from `shaders.properties` to eliminate option-menu warnings.

