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
