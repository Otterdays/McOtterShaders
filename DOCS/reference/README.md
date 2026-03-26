<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Reference documentation

This folder holds **ecosystem / domain** material: how OptiFine/Iris shaderpacks are structured in general, which files exist, and typical uniform names. It is **not** the binding specification for *this* pack’s buffer packing or pass order once shaders are implemented.

## Where to look

| Need | Document |
|------|----------|
| **This pack’s G-buffer layout and pipeline intent** | [../ARCHITECTURE.md](../ARCHITECTURE.md) |
| **Broad file/uniform reference (generic “advanced” pack)** | [advanced_shaderpack_reference.md](advanced_shaderpack_reference.md) |
| **Decisions and rationale** | [../My_Thoughts.md](../My_Thoughts.md) |
| **Pinned game + loader versions and source URLs** | [../TARGET_PLATFORM.md](../TARGET_PLATFORM.md) |

## Compatibility and scope

[AMENDED 2026-03-26]: Primary **Minecraft 26.1** + **Iris on Fabric** for development and validation; exact versions and canonical URLs are in [../TARGET_PLATFORM.md](../TARGET_PLATFORM.md). OptiFine may be considered later; not the current pin.

| Item | Target | Notes |
|------|--------|--------|
| Minecraft | **26.1** | Pinned for this project |
| Shader loader | **Iris (Fabric)** primary | Version ID on Modrinth: see TARGET_PLATFORM |
| GLSL profile | Verify for Iris 26.1 | Confirm `#version`/features via Iris docs or in-game compile (see TARGET_PLATFORM open items) |

### Upgrade checklist (when bumping MC or loader)

- Re-read the loader’s shader documentation for renamed or removed uniforms and program names.
- Re-verify `shaders.properties` keys and `colortex*` format limits.
- Run the pack in-game and fix compile errors before relying on this reference alone.

## Relationship to project truth

Code in `shaders/` (when added) and [ARCHITECTURE.md](../ARCHITECTURE.md) override generic descriptions here. If something disagrees, **trust ARCHITECTURE + the repo** and amend this reference with a dated note rather than deleting history.
