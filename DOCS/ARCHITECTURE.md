<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

## G-Buffer Layout Definition
To achieve physically based rendering, we must define exactly what information is stored in our color textures during the initial geometry pass.

**Authoritative spec:** The table below is the binding layout for this pack. Decision history lives in [My_Thoughts.md](My_Thoughts.md).

### Buffer Allocations

| Buffer | Format | Channels | Purpose | Content |
| :--- | :--- | :--- | :--- | :--- |
| `colortex0` | RGBA8 | 4 (RGBA) | Color | Albedo (RGB) + Transparency/Alpha (A) |
| `colortex1` | RGB16F | 3 (RGB) | Surface | Compressed Normals (XY) + Depth (Z) |
| `colortex2` | RGBA8 | 4 (RGBA) | PBR Data | Roughness (R), Metalness (G), Emissive (B), AO (A) |
| `colortex3` | RGBA8 | 4 (RGBA) | Light/Aux | Block Light (R), Sky Light (G), Subsurface Scattering (B), Block ID (A) |

### Memory & Format Strategy
- **RG16F/RGB16F**: Used for normals to prevent precision-loss banding in lighting calculations.
- **RGBA8**: Standard 8-bit per channel for most static data to minimize VRAM footprint.
- **Linear vs. SRGB**: Albedo (`colortex0`) is stored in SRGB, while material data is linear.

## Rendering Stages Detailed

### 1. Geometry Pass (`gbuffers_*.vsh/fsh`)
- Vertices are transformed to clip space.
- Fragment shaders write to the buffers defined above.
- No lighting is calculated here yet.

### 2. Shadow Pass (`shadow.vsh/fsh`)
- The entire scene is rendered from the perspective of the sun/moon.
- Only depth is written to a shadow map texture.
- Cascaded Shadow Maps (CSM) should be considered for long-range fidelity.

### 3. Lighting & Composite (`composite*.vsh/fsh`)
- **Composite 0**: Sun/Moon lighting using the PBR data and shadow map.
- **Composite 1**: Indirect lighting (Ambient, AO, SSAO).
- **Composite 2**: Volumetric effects (Fog, God-rays).
- **Composite 3**: Reflections and Refractions (SSR).

### 4. Post-Pass (`final.vsh/fsh`)
- ACES Tone Mapping.
- FXAA or TAA Anti-Aliasing.
- Bloom overlay.
- Gamma correction.
