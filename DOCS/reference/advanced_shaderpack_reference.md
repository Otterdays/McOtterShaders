<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Advanced Minecraft Shaderpack — Complete File Reference

A comprehensive guide to every file in a fully-featured shaderpack for OptiFine/Iris, organized by pipeline stage. Each entry describes the file's role and the key operations (functions/techniques) it implements.

---

**Scope note (2026-03-26):** Sections describing `shaders/lib/*.glsl` use **illustrative** function names common in shader packs, not guaranteed APIs of Iris or OptiFine. For exact uniform availability per program and version, use the loader’s official shader documentation. This pack’s binding G-buffer layout is [ARCHITECTURE.md](../ARCHITECTURE.md), not this file.

---

## Project Structure Overview

```
MyShaderpack/
├── shaders/
│   ├── shaders.properties
│   ├── block.properties
│   ├── entity.properties
│   ├── item.properties
│   │
│   ├── lang/
│   │   └── en_us.lang
│   │
│   ├── lib/                        (user-defined includes)
│   │   ├── common.glsl
│   │   ├── lighting.glsl
│   │   ├── shadows.glsl
│   │   ├── atmosphere.glsl
│   │   ├── noise.glsl
│   │   ├── tonemap.glsl
│   │   ├── water.glsl
│   │   ├── encoding.glsl
│   │   ├── temporal.glsl
│   │   └── pbr.glsl
│   │
│   ├── gbuffers_basic.vsh / .fsh
│   ├── gbuffers_textured.vsh / .fsh
│   ├── gbuffers_textured_lit.vsh / .fsh
│   ├── gbuffers_terrain.vsh / .fsh
│   ├── gbuffers_water.vsh / .fsh
│   ├── gbuffers_entities.vsh / .fsh
│   ├── gbuffers_block.vsh / .fsh
│   ├── gbuffers_hand.vsh / .fsh
│   ├── gbuffers_hand_water.vsh / .fsh
│   ├── gbuffers_weather.vsh / .fsh
│   ├── gbuffers_skybasic.vsh / .fsh
│   ├── gbuffers_skytextured.vsh / .fsh
│   ├── gbuffers_clouds.vsh / .fsh
│   ├── gbuffers_damagedblock.vsh / .fsh
│   ├── gbuffers_beaconbeam.vsh / .fsh
│   ├── gbuffers_spidereyes.vsh / .fsh
│   ├── gbuffers_armor_glint.vsh / .fsh
│   ├── gbuffers_line.vsh / .fsh
│   │
│   ├── shadow.vsh / .fsh / .gsh
│   ├── shadow_solid.vsh / .fsh
│   ├── shadow_cutout.vsh / .fsh
│   │
│   ├── deferred.vsh / .fsh
│   ├── deferred1.vsh / .fsh
│   ├── deferred2.vsh / .fsh
│   │   ... (up to deferred15)
│   │
│   ├── composite.vsh / .fsh
│   ├── composite1.vsh / .fsh
│   ├── composite2.vsh / .fsh
│   ├── composite3.vsh / .fsh
│   ├── composite4.vsh / .fsh
│   ├── composite5.vsh / .fsh
│   ├── composite6.vsh / .fsh
│   ├── composite7.vsh / .fsh
│   │   ... (up to composite15)
│   │
│   ├── final.vsh / .fsh
│   │
│   └── world0/  world-1/  world1/  (dimension overrides)
│       └── (any of the above files)
```

---

## 1. Configuration & Property Files

### shaders.properties

The master configuration file. Not a shader — a key-value config that controls pipeline behavior.

| Setting | Purpose |
|---|---|
| `shadow.resolution=2048` | Shadow map texture resolution |
| `shadowDistance=128.0` | How far shadows render in blocks |
| `shadowDistanceRenderMul=1.0` | Multiplier for shadow render distance |
| `shadowIntervalSize=2.0` | Snapping interval for shadow map (reduces shimmer) |
| `shadowMapFov=90.0` | Field of view for shadow camera |
| `shadowMapHalfPlane=160.0` | Half-plane distance for shadow camera |
| `shadowHardwareFiltering=true` | Enable hardware PCF on shadow sampler |
| `colortex0Format=RGBA16` | Format of framebuffer attachment 0 |
| `colortex1Format=RGBA16F` | Format for normals / HDR data |
| `colortex2Format=RGBA16F` | Format for specular / material data |
| `colortex3Format–colortex7Format` | Additional buffer formats as needed |
| `sunPathRotation=25.0` | Angle of the sun's arc |
| `ambientOcclusionLevel=0.0` | Disable vanilla AO (replaced by shader AO) |
| `rain.depth=true` | Enable depth writing during rain |
| `underwaterOverlay=false` | Disable vanilla underwater overlay |
| `vignette=false` | Disable vanilla vignette |
| `oldLighting=default` | Control directional shading fallback |
| `dynamicHandLight=true` | Enable held-item dynamic lighting |
| `oldHandLight=false` | Disable old hand light model |
| `clouds=off` | Disable vanilla clouds |
| `separateAo=true` | Separate AO channel in vertex color |
| `frustum.culling=true` | Enable frustum culling |
| `alphaTest.gbuffers_terrain=false` | Disable alpha test for terrain pass |
| `blend.gbuffers_water=...` | Custom blend mode for water |
| `texture.noise=textures/noise.png` | Path to a noise texture |
| `sliders=SHADOW_RES BLOOM_STRENGTH ...` | Expose settings sliders in GUI |
| `screen=<layout>` | Define settings screen layout |
| `profile=...` | Define quality presets |

### block.properties

Maps Minecraft block IDs to custom integer IDs you use in shaders.

```properties
block.10001=minecraft:water minecraft:flowing_water
block.10002=minecraft:lava minecraft:flowing_lava
block.10003=minecraft:ice minecraft:packed_ice
block.10004=minecraft:torch minecraft:wall_torch
block.10005=minecraft:grass_block
```

These IDs are passed to shaders via `mc_Entity.x` (or `blockEntityId`), letting you identify block types in GLSL.

### entity.properties

Maps entity types to custom integer IDs, used via `entityId` in gbuffers_entities.

### item.properties

Maps held items to custom integer IDs, used in gbuffers_hand.

### lang/en_us.lang

Provides human-readable names for shader settings sliders:

```properties
option.SHADOW_RES=Shadow Resolution
option.SHADOW_RES.comment=Resolution of the shadow map texture.
value.SHADOW_RES.512=Low
value.SHADOW_RES.1024=Medium
value.SHADOW_RES.2048=High
```

---

## 2. Library / Include Files (shaders/lib/)

These are reusable GLSL snippets included via `#include` directives. They aren't standalone programs.

### common.glsl
| Function | Purpose |
|---|---|
| `linearizeDepth(float d)` | Convert hyperbolic depth buffer value to linear view distance |
| `screenToView(vec3 screen)` | Transform screen-space coords to view-space using inverse projection |
| `viewToWorld(vec3 view)` | Transform view-space coords to world-space using inverse modelview |
| `viewToScreen(vec3 view)` | Transform view-space to screen-space (for reprojection) |
| `worldToShadow(vec3 world)` | Project world-space position into shadow map space |
| `encodeNormal(vec3 n)` | Pack a unit normal into 2 components for storage |
| `decodeNormal(vec2 e)` | Unpack a stored 2-component normal back to vec3 |
| `saturate(float x)` | Clamp to [0,1] shorthand |
| `luminance(vec3 color)` | Compute perceptual luminance from RGB |
| `remap(float v, ...)` | Remap a value from one range to another |

### lighting.glsl
| Function | Purpose |
|---|---|
| `diffuseLambert(vec3 N, vec3 L)` | Lambertian diffuse: `max(dot(N, L), 0)` |
| `specularGGX(vec3 N, vec3 V, vec3 L, float roughness, vec3 F0)` | Cook-Torrance GGX specular BRDF |
| `distributionGGX(vec3 N, vec3 H, float roughness)` | GGX/Trowbridge-Reitz normal distribution |
| `geometrySmith(vec3 N, vec3 V, vec3 L, float roughness)` | Smith geometry attenuation |
| `fresnelSchlick(float cosTheta, vec3 F0)` | Schlick Fresnel approximation |
| `subsurfaceScattering(float depth, float thickness)` | Approximate SSS for foliage/skin |
| `blockLightAttenuation(float lightmapX)` | Attenuation curve for torch/block light |
| `skyLightAttenuation(float lightmapY)` | Ambient from sky lightmap coordinate |
| `dynamicLightContribution(...)` | Dynamic light falloff from held items |

### shadows.glsl
| Function | Purpose |
|---|---|
| `sampleShadowMap(vec3 shadowCoord)` | Basic single-tap shadow map lookup |
| `sampleShadowPCF(vec3 coord, int samples)` | Percentage Closer Filtering (soft edges) |
| `sampleShadowPCSS(vec3 coord)` | Percentage Closer Soft Shadows (variable penumbra) |
| `sampleShadowVSM(vec3 coord)` | Variance shadow mapping |
| `distortShadowSpace(vec2 coord)` | Shadow map distortion for higher near-camera resolution |
| `getShadowBias(float NdotL)` | Compute depth bias to reduce shadow acne |
| `contactShadow(vec3 viewPos, vec3 lightDir)` | Screen-space ray march for contact shadows |
| `waterCaustics(vec3 worldPos)` | Simulate light caustics underwater |

### atmosphere.glsl
| Function | Purpose |
|---|---|
| `rayleighScattering(float cosTheta)` | Rayleigh phase function for sky color |
| `mieScattering(float cosTheta, float g)` | Henyey-Greenstein / Mie phase for haze/sun glow |
| `computeAtmosphere(vec3 dir, vec3 sunDir)` | Full single/multi-scattering sky model |
| `getSunColor(float sunAltitude)` | Sun disk color based on altitude angle |
| `getMoonColor(float moonPhase)` | Moon color/brightness by phase |
| `starsField(vec3 dir)` | Procedural star rendering |
| `computeFog(float dist, float altitude)` | Distance + height fog with density falloff |
| `volumetricMarch(vec3 origin, vec3 dir, int steps)` | Ray march through atmosphere for god rays / volumetric light |
| `cloudLayer(vec3 pos, float time)` | 2D/3D cloud density sampling |
| `cloudLighting(float density, float sunDot)` | Beer-Lambert + powder approximation for cloud shading |

### noise.glsl
| Function | Purpose |
|---|---|
| `hash(float/vec2/vec3)` | Fast pseudo-random hash |
| `noise2D(vec2 p)` | 2D value noise |
| `noise3D(vec3 p)` | 3D value noise |
| `perlin2D(vec2 p)` | 2D Perlin gradient noise |
| `perlin3D(vec3 p)` | 3D Perlin gradient noise |
| `simplex2D(vec2 p)` | 2D simplex noise |
| `simplex3D(vec3 p)` | 3D simplex noise |
| `fbm(vec2/vec3 p, int octaves)` | Fractal Brownian Motion layered noise |
| `voronoi(vec2 p)` | Worley / cellular noise |
| `blueNoiseSample(vec2 texcoord)` | Sample from precomputed blue noise texture |
| `interleavedGradientNoise(vec2 coord)` | Animated per-pixel noise for dithering |
| `BayerMatrix8(vec2 coord)` | 8×8 ordered dither pattern |

### tonemap.glsl
| Function | Purpose |
|---|---|
| `tonemapReinhard(vec3 color)` | Reinhard global operator |
| `tonemapReinhardExtended(vec3 color, float whitePoint)` | Reinhard with white point |
| `tonemapACES(vec3 color)` | Academy Color Encoding System filmic curve |
| `tonemapACESFitted(vec3 color)` | Fitted ACES approximation (Stephen Hill) |
| `tonemapUncharted2(vec3 color)` | John Hable's Uncharted 2 filmic curve |
| `tonemapLottes(vec3 color)` | Timothy Lottes' AMD curve |
| `linearToSRGB(vec3 color)` | Linear → sRGB gamma transfer |
| `sRGBToLinear(vec3 color)` | sRGB → linear |
| `adjustExposure(vec3 color, float ev)` | Apply exposure value |
| `autoExposure(sampler2D lumTex)` | Read average luminance for auto-exposure |
| `colorGrading(vec3 color)` | White balance, saturation, contrast, lift/gamma/gain |
| `applyDithering(vec3 color, vec2 coord)` | Dither output to reduce banding |

### water.glsl
| Function | Purpose |
|---|---|
| `waterNormal(vec2 worldXZ, float time)` | Animated multi-octave water normal map |
| `gerstnerWave(vec2 pos, vec2 dir, float steepness, float wavelength, float time)` | Gerstner wave vertex displacement |
| `waterAbsorption(float depth, vec3 baseColor)` | Exponential absorption tint by depth |
| `fresnelWater(float NdotV)` | Fresnel reflectance for water surface |
| `refractionOffset(vec3 normal, float ior)` | Screen-space UV offset for refraction |
| `foamMask(float depth, vec2 worldXZ)` | Shoreline foam based on depth proximity |
| `underwaterFog(float dist)` | Tinted fog while camera is submerged |

### encoding.glsl
| Function | Purpose |
|---|---|
| `pack2x8(vec2 v)` | Pack two [0,1] values into one float |
| `unpack2x8(float p)` | Unpack one float into two [0,1] values |
| `encodeNormalOctahedral(vec3 n)` | Octahedral normal encoding |
| `decodeNormalOctahedral(vec2 e)` | Octahedral normal decoding |
| `encodeLightmap(vec2 lm)` | Store lightmap coords compactly |
| `decodeLightmap(float p)` | Retrieve lightmap coords |
| `encodeMaterialID(int id)` | Store material ID in a float channel |
| `decodeMaterialID(float f)` | Retrieve material ID |

### temporal.glsl
| Function | Purpose |
|---|---|
| `reproject(vec3 viewPos, mat4 prevMVP)` | Find previous frame's screen coord for a current pixel |
| `neighborhoodClamp(vec3 color, sampler2D current, vec2 coord)` | AABB clamp history color to reduce ghosting |
| `taaBlend(vec3 current, vec3 history, float blendFactor)` | Weighted blend of current and history frames |
| `velocityFromDepth(vec2 coord, float depth, mat4 prevMVP)` | Compute motion vector |
| `catmullRomSample(sampler2D tex, vec2 uv)` | Bicubic history sampling to reduce blur |
| `jitterOffset(int frameCounter)` | Sub-pixel jitter for TAA (Halton sequence) |

### pbr.glsl
| Function | Purpose |
|---|---|
| `sampleAlbedo(vec2 uv)` | Read base color from diffuse atlas |
| `sampleNormalMap(vec2 uv)` | Read and decode tangent-space normal map |
| `sampleSpecularMap(vec2 uv)` | Read roughness, metalness, emissive from specular texture |
| `getRoughness(vec4 specData)` | Extract roughness from LabPBR/SEUS format |
| `getMetalness(vec4 specData)` | Extract metalness |
| `getEmissive(vec4 specData)` | Extract emissive intensity |
| `getF0(float metalness, vec3 albedo)` | Compute base reflectance (dielectric vs metallic) |
| `parallaxMapping(vec2 uv, vec3 viewDir, sampler2D heightmap)` | Parallax occlusion mapping for depth on surfaces |
| `selfShadowPOM(...)` | Self-shadowing for POM surfaces |

---

## 3. GBuffers Programs (Geometry Pass)

All gbuffers programs share a similar structure: the vertex shader transforms positions and passes varyings, the fragment shader writes color and material data into multiple framebuffer attachments (`gl_FragData[0]` through `gl_FragData[N]`).

### What each gbuffers program renders

| File | Geometry Rendered |
|---|---|
| `gbuffers_basic` | Lines, debug graphics, selection outline |
| `gbuffers_textured` | Generic textured quads (particles in older versions) |
| `gbuffers_textured_lit` | Lit textured quads (particles with lighting) |
| `gbuffers_terrain` | All solid and cutout blocks (the main world geometry) |
| `gbuffers_water` | Translucent blocks: water, stained glass, ice, slime, honey |
| `gbuffers_entities` | All entities (mobs, players, dropped items, minecarts) |
| `gbuffers_block` | Block entities (chests, signs, banners, heads, shulker boxes) |
| `gbuffers_hand` | First-person held item / arm (opaque) |
| `gbuffers_hand_water` | First-person held translucent item |
| `gbuffers_weather` | Rain and snow particles |
| `gbuffers_skybasic` | Sky dome color (gradient, void) |
| `gbuffers_skytextured` | Sun and moon textures |
| `gbuffers_clouds` | Vanilla cloud geometry |
| `gbuffers_damagedblock` | Block breaking overlay animation |
| `gbuffers_beaconbeam` | Beacon beam |
| `gbuffers_spidereyes` | Emissive eyes on spiders, endermen, etc. |
| `gbuffers_armor_glint` | Enchantment glint overlay |
| `gbuffers_line` | Block outline, fishing line |

### Common vertex shader operations (.vsh)

| Operation | Purpose |
|---|---|
| `ftransform()` or manual MVP | Transform vertex to clip space |
| Compute `texcoord` | `gl_TextureMatrix[0] * gl_MultiTexCoord0` for atlas UV |
| Compute `lmcoord` | `gl_TextureMatrix[1] * gl_MultiTexCoord1` for lightmap UV |
| Pass `glcolor` | `gl_Color` — vertex color includes AO tint |
| Compute view-space position | `gl_ModelViewMatrix * gl_Vertex` for lighting/fog |
| Compute view-space normal | `gl_NormalMatrix * gl_Normal` |
| Compute TBN matrix | Tangent/Bitangent/Normal for normal mapping |
| Read `mc_Entity.x` | Block ID from block.properties |
| Waving animation | Offset vertices for foliage/water wave using `worldTime` and noise |
| Shadow bias prep | Compute `NdotL` for shadow bias in fragment |

### Common fragment shader operations (.fsh)

| Operation | Purpose |
|---|---|
| Sample `texture` (atlas) | `texture2D(texture, texcoord)` — base color |
| Sample `normals` texture | Tangent-space normal from resource pack |
| Sample `specular` texture | LabPBR roughness/metalness/emissive data |
| Alpha test | Discard fragments below threshold (cutout blocks, foliage) |
| Encode normals to buffer | Store view-space or world-space normals in `gl_FragData[1]` |
| Encode material data | Store roughness, metalness, material ID in `gl_FragData[2]` |
| Encode lightmap | Store lightmap coords in a buffer for deferred use |
| POM / parallax mapping | Offset UVs based on height map for depth illusion |
| Write `gl_FragData[0]` | Albedo color (base color × vertex color) |
| Write `gl_FragData[1]` | Encoded normals |
| Write `gl_FragData[2]` | Specular / material properties |
| Write `gl_FragData[3]` | Additional data (lightmap, material ID, etc.) |

### Special behavior per program

**gbuffers_terrain**: Handles waving foliage/crops via vertex displacement. Reads `mc_Entity.x` to identify block types for per-material behavior (emissive ores, subsurface foliage, etc.).

**gbuffers_water**: Computes animated water normals, vertex wave displacement (Gerstner), marks water pixels with a material ID so composite passes apply reflections/refraction.

**gbuffers_entities**: Reads `entityId` for special handling (glowing entities, mob-specific effects). Handles entity hurt flash via `entityColor`.

**gbuffers_skybasic**: Outputs custom sky gradient or clears to atmosphere color. Often discards vanilla sky entirely and writes a procedural atmosphere.

**gbuffers_hand**: May apply depth scaling to prevent hand clipping through walls. Separate from terrain so it can have unique DOF/motion blur behavior.

**gbuffers_weather**: Controls rain/snow particle appearance, opacity, and wind displacement.

---

## 4. Shadow Programs

### shadow.vsh
| Operation | Purpose |
|---|---|
| Transform vertex to shadow clip space | `gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex` |
| Apply shadow distortion | Warp shadow map UVs to concentrate resolution near the player |
| Pass texcoord and color | Needed for alpha-tested shadow geometry (leaves, fences) |
| Bias vertex depth | Offset along normal to prevent shadow acne |
| Identify block type | Use `mc_Entity.x` for special handling (exclude water, handle translucency) |

### shadow.fsh
| Operation | Purpose |
|---|---|
| Alpha test | Discard transparent fragments so leaves/fences cast correct shaped shadows |
| Colored shadow output | Write color to `gl_FragData[1]` for colored light transmission (stained glass) |
| Write depth | `gl_FragData[0]` writes depth for opaque shadow |

### shadow.gsh (Geometry Shader — optional)
| Operation | Purpose |
|---|---|
| Multi-face shadow cubemap | Render to multiple shadow map faces in one pass |
| Cull back faces | Improve shadow map quality by culling away-facing geometry |

---

## 5. Deferred Programs (deferred, deferred1–15)

Run after all gbuffers but before composite. Used for deferred lighting calculations.

### Typical deferred pass allocation

| Pass | Common Usage |
|---|---|
| `deferred` | Reconstruct positions from depth, apply deferred PBR lighting (sun + sky + block light) using all gbuffer data |
| `deferred1` | Screen-space ambient occlusion (SSAO / GTAO / HBAO) |
| `deferred2` | Screen-space reflections (SSR) — ray march in screen space |
| `deferred3` | Indirect lighting / global illumination approximation |

### Key operations across deferred passes

| Operation | Purpose |
|---|---|
| Read `depthtex0` / `depthtex1` | Get per-pixel depth (with and without translucents) |
| Reconstruct view position | `screenToView()` from depth |
| Read normals from `colortex1` | Decode stored normals |
| Read material data from `colortex2` | Roughness, metalness, material ID |
| Read lightmap from `colortex3` | Block light + sky light values |
| Compute sun/moon lighting | Directional light using `sunPosition`/`moonPosition`, shadow lookup |
| Sample shadow map | `shadow2D(shadowtex0, ...)` with PCF/PCSS for soft shadows |
| Compute GGX specular | Full PBR specular from sun using roughness/F0 |
| Compute SSAO | Screen-space hemisphere sampling for ambient occlusion |
| Compute SSR | Screen-space ray marching for reflections |
| Blend translucent layer | Combine opaque lighting with translucent (water/glass) data |
| Write lit HDR color | Output lit scene to `gl_FragData[0]` for composite passes |

---

## 6. Composite Programs (composite, composite1–15)

Fullscreen post-processing passes. Each reads from screen-sized textures and writes results back.

### Typical composite pass allocation (advanced pack)

| Pass | Common Usage |
|---|---|
| `composite` | Volumetric lighting — ray march from camera toward sun through shadow map to accumulate in-scattered light |
| `composite1` | Volumetric clouds — ray march through 3D cloud layer with Beer-Lambert lighting |
| `composite2` | Combine volumetrics with scene, apply fog (distance + height), underwater effects |
| `composite3` | Bloom downsample — threshold bright pixels, downsample to half/quarter/eighth resolution |
| `composite4` | Bloom upsample — progressively upsample and blur bloom chain |
| `composite5` | Depth of field — circle of confusion calculation, disc/hex blur based on focus distance |
| `composite6` | Motion blur — sample along velocity vector using motion vectors or camera delta |
| `composite7` | Temporal anti-aliasing — blend current frame with reprojected history, neighborhood clamp |

### Key operations across composite passes

| Operation | Purpose |
|---|---|
| Volumetric light march | Step through shadow map along view ray, accumulate `transmittance × inScatter` |
| Cloud density sampling | 3D noise lookup at world position, shape with weather map, erode with detail noise |
| Cloud lighting | Beer-Lambert extinction, powder effect, multi-scatter approximation |
| Bloom threshold | `max(color - threshold, 0.0)` to isolate bright areas |
| Gaussian / Kawase blur | Separable blur passes for bloom spread |
| Bloom upscale chain | Progressively add blurred layers at increasing resolution |
| Compute CoC | Circle of confusion: `abs(depth - focusDepth) × aperture` |
| Bokeh blur | Weighted disc or hexagonal sampling kernel scaled by CoC |
| Motion vector computation | `currentScreenPos - previousScreenPos` using previous frame MVP |
| Motion blur sampling | Sample along motion vector with N taps |
| TAA jitter | Apply Halton sub-pixel jitter offset in projection matrix |
| TAA accumulation | Blend reprojected history with current, clamp to neighborhood AABB |
| Velocity rejection | Disocclusion detection to avoid ghosting |

---

## 7. Final Pass

### final.vsh
Standard fullscreen triangle/quad vertex shader — passes `texcoord`.

### final.fsh
The last shader before display. Receives the fully composited HDR image and outputs LDR for the screen.

| Operation | Purpose |
|---|---|
| Read composited HDR color | `texture2D(colortex0, texcoord)` |
| Auto-exposure | Read average luminance (from a 1×1 mipmap or dedicated buffer), compute EV adjustment |
| Tonemapping | Apply ACES / Reinhard / Hable / Lottes curve to compress HDR → [0,1] |
| Color grading | White balance, saturation, contrast, channel mixer, lift/gamma/gain |
| Film grain | Procedural noise overlay scaled by luminance |
| Vignette | Darken screen edges based on distance from center |
| Chromatic aberration | Offset R/G/B channels radially from center |
| Lens flare / dirty lens | Additive overlay based on bright spots from bloom |
| Gamma / sRGB transfer | `linearToSRGB()` final gamma correction |
| Dithering | Add 1-bit ordered dither to break color banding in gradients |
| CAS / sharpening | Contrast adaptive sharpening to recover detail lost by TAA/blur |
| Write `gl_FragColor` | Final LDR color to screen |

---

## 8. Dimension Overrides (world0, world-1, world1)

Folders inside `shaders/` named by dimension ID:

| Folder | Dimension |
|---|---|
| `world0/` | Overworld (optional — base shaders are overworld by default) |
| `world-1/` | Nether |
| `world1/` | The End |

Place any shader file inside these folders to override behavior for that dimension. For example, `world-1/composite.fsh` can skip volumetric sun rays (no sun in the Nether) and use a different fog model.

---

## 9. Common Uniform Reference

These are automatically provided by OptiFine/Iris and available in any shader program:

### Matrices
| Uniform | Type | Description |
|---|---|---|
| `gl_ModelViewMatrix` | mat4 | Model-view matrix |
| `gl_ProjectionMatrix` | mat4 | Projection matrix |
| `gbufferModelView` | mat4 | Camera model-view |
| `gbufferModelViewInverse` | mat4 | Inverse of above |
| `gbufferProjection` | mat4 | Camera projection |
| `gbufferProjectionInverse` | mat4 | Inverse of above |
| `gbufferPreviousModelView` | mat4 | Previous frame model-view (for TAA/motion blur) |
| `gbufferPreviousProjection` | mat4 | Previous frame projection |
| `shadowModelView` | mat4 | Shadow camera model-view |
| `shadowModelViewInverse` | mat4 | Inverse of above |
| `shadowProjection` | mat4 | Shadow camera projection |
| `shadowProjectionInverse` | mat4 | Inverse of above |

### Vectors & Positions
| Uniform | Type | Description |
|---|---|---|
| `sunPosition` | vec3 | Sun direction in view space |
| `moonPosition` | vec3 | Moon direction in view space |
| `shadowLightPosition` | vec3 | Whichever (sun/moon) is casting shadows |
| `upPosition` | vec3 | Up direction in view space |
| `cameraPosition` | vec3 | Camera world-space position |
| `previousCameraPosition` | vec3 | Camera position last frame |
| `eyePosition` | vec3 | Eye world-space position |

### Time & Weather
| Uniform | Type | Description |
|---|---|---|
| `worldTime` | int | Minecraft time of day (0–23999) |
| `worldDay` | int | Day count |
| `frameTimeCounter` | float | Real-time seconds counter |
| `frameTime` | float | Delta time since last frame |
| `frameCounter` | int | Frame counter |
| `sunAngle` | float | Sun angle 0.0–1.0 (noon=0, midnight=0.5) |
| `shadowAngle` | float | Shadow light angle |
| `rainStrength` | float | 0.0–1.0 rain intensity |
| `wetness` | float | 0.0–1.0 wetness (lags behind rain) |

### Screen
| Uniform | Type | Description |
|---|---|---|
| `viewWidth` | float | Screen width in pixels |
| `viewHeight` | float | Screen height in pixels |
| `aspectRatio` | float | Width / height |
| `near` | float | Near plane distance |
| `far` | float | Far plane distance |

### Samplers (Textures)
| Uniform | Type | Description |
|---|---|---|
| `texture` | sampler2D | Block/entity atlas texture |
| `lightmap` | sampler2D | Vanilla lightmap texture |
| `normals` | sampler2D | Normal map atlas (PBR resource pack) |
| `specular` | sampler2D | Specular map atlas (PBR resource pack) |
| `depthtex0` | sampler2D | Depth buffer (all geometry) |
| `depthtex1` | sampler2D | Depth buffer (no translucents) |
| `depthtex2` | sampler2D | Depth buffer (no translucents, no hand) |
| `shadowtex0` | sampler2DShadow | Shadow map depth (all) |
| `shadowtex1` | sampler2DShadow | Shadow map depth (no translucents) |
| `shadowcolor0` | sampler2D | Shadow map color (for colored shadows) |
| `shadowcolor1` | sampler2D | Additional shadow color buffer |
| `colortex0`–`colortex15` | sampler2D | Framebuffer color attachments |
| `noisetex` | sampler2D | Noise texture from shaders.properties |

### Entity / Block
| Uniform | Type | Description |
|---|---|---|
| `entityId` | int | Entity ID (in gbuffers_entities) |
| `blockEntityId` | int | Block entity ID (in gbuffers_block) |
| `entityColor` | vec4 | Entity damage flash color |
| `mc_Entity` | vec4 | Block ID from block.properties (terrain) |
| `mc_midTexCoord` | vec2 | Mid-texcoord of current quad |
| `at_tangent` | vec4 | Tangent vector for TBN |

---

## 10. Data Flow Summary

```
┌─────────────────────────────────────────────────────────┐
│                   SHADOW PASS                           │
│  shadow.vsh/fsh → shadowtex0, shadowtex1, shadowcolor0 │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                   GBUFFERS PASSES                       │
│  gbuffers_*.vsh/fsh → colortex0 (albedo)                │
│                      → colortex1 (normals)              │
│                      → colortex2 (specular/material)    │
│                      → colortex3 (lightmap/extra)       │
│                      → depthtex0/1/2                    │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                   DEFERRED PASSES                       │
│  deferred*.fsh → Deferred lighting (PBR sun/sky/block)  │
│               → SSAO                                    │
│               → SSR                                     │
│  Output: Lit HDR scene in colortex0                     │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                   COMPOSITE PASSES                      │
│  composite*.fsh → Volumetric light                      │
│                 → Volumetric clouds                     │
│                 → Fog                                   │
│                 → Bloom (down + up)                     │
│                 → DOF                                   │
│                 → Motion blur                           │
│                 → TAA                                   │
│  Output: Post-processed HDR in colortex0                │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                   FINAL PASS                            │
│  final.fsh → Auto-exposure                              │
│            → Tonemapping                                │
│            → Color grading                              │
│            → Film grain / vignette / CA                 │
│            → Gamma correction                           │
│            → Dithering                                  │
│  Output: LDR image → screen                             │
└─────────────────────────────────────────────────────────┘
```

---

*This reference covers a fully-featured advanced shaderpack. Not every pack uses every file or technique — start with the basics and add complexity as needed.*
