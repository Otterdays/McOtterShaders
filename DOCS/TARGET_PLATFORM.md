<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Target platform and sources

Canonical **pinned stack** for developing and validating this shader pack on **Minecraft Java 26.1** with **Fabric** and **Iris**. Shader source files in this repo do not bundle these components; install them in your client for testing.

## Pinned targets

| Component | Version / ID | Role |
|-----------|----------------|------|
| Minecraft Java | **26.1** | Game version under test |
| Mod loader | **Fabric** | Required for the Iris build below |
| Shader loader | **Iris** `1.10.8+26.1-fabric` | Loads OptiFine-compatible shader packs |
| Fabric API | **0.144.3+26.1** | Standard Fabric mod API (recommended for a typical Fabric instance; not required for shader files alone) |
| Rendering dependency | **Sodium** `mc26.1-0.8.7-fabric` | Listed as required by Iris on Modrinth for this version |

## Sources of truth

Use these URLs when checking compatibility or updating pins:

1. **Fabric for Minecraft 26.1** (announcement: tooling, ecosystem, rendering direction)  
   https://fabricmc.net/2026/03/14/261.html  

2. **Iris for Fabric 26.1** (release artifact and metadata, including dependencies)  
   https://modrinth.com/mod/iris/version/1.10.8+26.1-fabric  

3. **Fabric API for 26.1** (library JAR for Fabric mods)  
   https://modrinth.com/mod/fabric-api/version/0.144.3+26.1  

## Stack notes (environment risk)

Per the Fabric announcement, **26.1** is a major toolchain and API transition; mod code from older game versions may not work without recompilation. For **shader authors**, the relevant risk is the **rendering stack**: 26.1 is described as the last release expected to rely solely on **OpenGL**, with **26.2** snapshots anticipated to allow switching backends (e.g. Vulkan) and eventually dropping OpenGL once stable. Treat raw OpenGL assumptions as **version-sensitive**; re-verify behavior when upgrading past 26.1.

## Open verification (next steps)

- **GLSL `#version` and Iris shader feature set** for 26.1: confirm from **Iris shader documentation** for this release and/or **in-game shader compile logs** before locking style in `STYLE_GUIDE.md` or rejecting packs as “wrong version.”
- **Minimum hardware / support policy**: not pinned here yet; define GPU/OS/OpenGL floor when the project commits to a support matrix.

## Hardware / graphics baseline

- **26.1:** assume **OpenGL** path for vanilla/modded client testing unless you explicitly target a snapshot with an alternate backend.
- Revisit this document when bumping Minecraft or Iris.
