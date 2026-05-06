<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Shaderpack runtime skeleton under `shaders/`: `shaders.properties`, `composite.vsh/fsh`, `final.vsh/fsh`, `lib/`, `lang/en_us.lang`.
- Borderlands-style stylization helpers: `shaders/lib/toon.glsl` (toon quantization) and `shaders/lib/edge_detect.glsl` (depth/normal outlines).
- Strong toon+outline composite pass in `shaders/composite.fsh` with tunable parameters for outline thickness/intensity/sensitivity and shade bands.
- `DOCS/TARGET_PLATFORM.md`: pinned **Minecraft 26.1** + **Iris** (`1.10.8+26.1-fabric`) + **Fabric API** (`0.144.3+26.1`) with canonical source URLs (Fabric announcement, Modrinth Iris/Fabric API); Sodium dependency and OpenGL/Vulkan notes; cross-links from `DOCS/reference/README.md`, `DOCS/SUMMARY.md`, `README.md`, `DOCS/My_Thoughts.md`, `DOCS/ROADMAP.md` §0, `DOCS/SBOM.md`.
- `DOCS/ROADMAP.md`: phased roadmap (prerequisites, skeleton, properties, tooling, verification, CI, release, backlog) with **E/M/H/X** difficulty markers and placeholder subsections for additions; linked from `DOCS/SUMMARY.md`, `README.md`, and `DOCS/STYLE_GUIDE.md`.
- Preservation-rule headers across `DOCS/` markdown files.
- `DOCS/reference/README.md` (reference index, compatibility placeholders, links to project truth).
- `DOCS/STYLE_GUIDE.md` (GLSL conventions, trace tags, pointers to ARCHITECTURE).
- Documentation map in `DOCS/SUMMARY.md` and a Documentation section in root `README.md`.
- Scope note in `DOCS/reference/advanced_shaderpack_reference.md` (illustrative lib APIs; link to ARCHITECTURE).
- Project initialization with documentation structure and architecture definition.
- Git repository initialization with standard .gitignore.

### Changed
- `shaders/lib/edge_detect.glsl`: reduced noisy full-screen outlining by weighting depth edges higher, gating normal edges behind depth discontinuity, and raising mask thresholds.
- `shaders/composite.fsh`: replaced pure-black contour mix with capped blend to a dark-tinted outline color for less crushed contrast.
- `shaders/shaders.properties`: retuned defaults to a saner baseline (`OUTLINE_THICKNESS=1.10`, `OUTLINE_INTENSITY=0.72`, `OUTLINE_DEPTH_SENS=0.95`, `OUTLINE_NORMAL_SENS=0.55`, `SHADE_STEPS=4`, `SHADE_STRENGTH=0.55`) after in-game visual feedback.
- `shaders/shaders.properties`: fixed Iris custom-uniform parse errors by changing variable expressions to single values and removing unresolved menu option bindings (`sliders`/`screen`) that referenced non-option entries.
- `DOCS/SUMMARY.md`: appended `[AMENDED 2026-05-06]` note reflecting shader skeleton + stylization v1 status and pending in-game verification.
- `DOCS/SBOM.md`: appended update-log entry confirming no dependency changes during shader/doc updates.
- `DOCS/SCRATCHPAD.md`: prepended active verification task and refreshed recent-context list after doc sync.
- `DOCS/My_Thoughts.md`: amended `colortex3` description to match `DOCS/ARCHITECTURE.md` with dated note.
- `DOCS/ARCHITECTURE.md`: clarified authoritative G-buffer spec and cross-link to My_Thoughts.
