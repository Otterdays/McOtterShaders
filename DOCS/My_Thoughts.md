<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Project My Thoughts

## 2026-03-18 - Defining the Buffer Layout
### Current Understanding
To build a high-fidelity shader pack, we need a robust G-Buffer layout that supports PBR (Physically Based Rendering). We'll follow the labPBR standard to ensure compatibility with modern resource packs.

### Options Considered
- **Standard Deferred**: Separate textures for Albedo, Normals, and Material data.
- **Packed Deferred**: Packing data into fewer textures to save bandwidth, though this can complicate shaders.

### Decision & Rationale
We'll use a **Hybrid Packed** approach. We'll utilize the standard `colortex` buffers provided by OptiFine/Iris. 
- `colortex0`: Albedo + Alpha (SRGB)
- `colortex1`: Normals (Encoded)
- `colortex2`: Material Data (Roughness, Metalness, Emission, AO)
- `colortex3`: Light/Aux — Block Light (R), Sky Light (G), Subsurface Scattering (B), Block ID (A)

[AMENDED 2026-03-26]: Channel layout for `colortex3` was vague ("Block ID, Light Level, Sky Light"). **Authoritative packing** is defined in [ARCHITECTURE.md](ARCHITECTURE.md); use that table for implementation.

This layout gives us enough flexibility for complex lighting while staying within the limits of most hardware.

## 2026-03-18 - Git Initialization
### Current Understanding
The project is currently not version controlled. We need to initialize Git, create a `.gitignore` file, and make the first commit to ensure we can track changes and revert if needed.

### Options Considered
- **Basic .gitignore**: Just standard OS files.
- **Detailed .gitignore**: Include potential shader-specific artifacts or temporary files.

### Decision & Rationale
We'll start with a clean `.gitignore` that ignores standard OS artifacts (`.DS_Store`, `Thumbs.db`) and IDE configurations (`.vscode`, `.idea`). Since this is a Minecraft shader pack, there aren't many compile-time artifacts yet, but we'll be proactive.

## 2026-03-26 - Target Minecraft and shader loader
### Current Understanding
We need a single primary runtime for iterating on shaders so compile behavior, uniforms, and `shaders.properties` semantics stay consistent.

### Options Considered
- **Iris on Fabric** with a pinned Minecraft version (matches modern modded play and clear Modrinth artifacts).
- **OptiFine** as primary (different install path; still useful for compatibility checks later).

### Decision & Rationale
- **Minecraft Java 26.1** is the pinned game version.
- **Primary shader loader:** **Iris** (`1.10.8+26.1-fabric` on Fabric), with **Fabric API** `0.144.3+26.1` and **Sodium** as required by that Iris release for a standard client stack.
- **OptiFine** is optional for a future compatibility pass; not the primary pin.

Authoritative links and stack table: [TARGET_PLATFORM.md](TARGET_PLATFORM.md). Sources also recorded there: [Fabric 26.1 announcement](https://fabricmc.net/2026/03/14/261.html), [Iris 1.10.8+26.1-fabric](https://modrinth.com/mod/iris/version/1.10.8+26.1-fabric), [Fabric API 0.144.3+26.1](https://modrinth.com/mod/fabric-api/version/0.144.3+26.1).
