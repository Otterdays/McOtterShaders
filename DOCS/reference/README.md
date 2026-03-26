<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Reference documentation

This folder holds **ecosystem / domain** material: how OptiFine/Iris shaderpacks are structured in general, which files exist, and typical uniform names. It is **not** the binding specification for *this* pack’s buffer packing or pass order once shaders are implemented.

## Where to look

| Need | Document |
|------|----------|
| **This pack’s G-buffer layout and pipeline intent** | [../ARCHITECTURE.md](../ARCHITECTURE.md) |
| **Broad file/uniform reference (generic “advanced” pack)** | [advanced_shaderpack_reference.md](advanced_shaderpack_reference.md) |
| **Decisions and rationale** | [../My_Thoughts.md](../My_Thoughts.md) |

## Compatibility and scope

Targets are **TBD** until the first MVP pack is pinned to a specific Minecraft major and loader build.

| Item | Target | Notes |
|------|--------|--------|
| Minecraft | TBD | Set when gameplay version is chosen |
| Loader | Iris and/or OptiFine | Document which you test with |
| GLSL profile | TBD (e.g. compatibility `#version 120`) | Match Iris/OF docs for that MC version |

### Upgrade checklist (when bumping MC or loader)

- Re-read the loader’s shader documentation for renamed or removed uniforms and program names.
- Re-verify `shaders.properties` keys and `colortex*` format limits.
- Run the pack in-game and fix compile errors before relying on this reference alone.

## Relationship to project truth

Code in `shaders/` (when added) and [ARCHITECTURE.md](../ARCHITECTURE.md) override generic descriptions here. If something disagrees, **trust ARCHITECTURE + the repo** and amend this reference with a dated note rather than deleting history.
