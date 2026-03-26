<!-- PRESERVATION RULE: Never delete or replace content. Append or annotate only. -->

# Roadmap: skeleton, tooling, and verification

Planning document for implementing the shader pack repository layout, `shaders.properties` and pipeline files, developer tooling, and how we will test and validate changes. **This file is append-only:** add rows and sections; do not rewrite history.

## Difficulty legend

| Tag | Meaning |
|-----|---------|
| **E** | Easy — short time, few unknowns, little coordination |
| **M** | Medium — multiple files or one external dependency to learn |
| **H** | Hard — cross-cutting behavior, loader quirks, or performance tradeoffs |
| **X** | Expert — research-heavy, fragile across MC/loader versions, or large scope |

---

## 0. Prerequisites and targets

Complete before treating later phases as “done.”

- [x] **E** Pin **Minecraft major** and document in [reference/README.md](reference/README.md) (or dedicated compatibility table).
- [x] **E** Choose primary **loader** (Iris, OptiFine, or both) and record rationale in [My_Thoughts.md](My_Thoughts.md).
- [ ] **M** Confirm **GLSL `#version`** and compatibility profile expected by that loader for the chosen MC version.
- [ ] **M** Define **minimum viable hardware** (e.g. OpenGL version) for support expectations.

### Additions (targets)

- [2026-03-26] Pinned **MC 26.1**, **Iris on Fabric**, sources in [TARGET_PLATFORM.md](TARGET_PLATFORM.md). **Remaining §0:** verify GLSL/Iris shader features (docs or in-game); define minimum GPU/OS when policy is set — see TARGET_PLATFORM open items.

- 

---

## 1. Repository layout and pack skeleton

Minimum tree so the pack loads in-game and fails loudly when misconfigured.

- [ ] **E** Add root **`shaders/`** directory with OptiFine/Iris-expected structure (see [reference/advanced_shaderpack_reference.md](reference/advanced_shaderpack_reference.md)).
- [ ] **M** Author baseline **`shaders.properties`**: buffer formats, shadow toggles, slider placeholders aligned with [ARCHITECTURE.md](ARCHITECTURE.md).
- [ ] **M** Stub **`block.properties` / `entity.properties` / `item.properties`** as needed for ID mapping experiments.
- [ ] **E** Add **`shaders/lang/en_us.lang`** for any `sliders=` / `screen=` entries once options exist.
- [ ] **H** Implement minimal **`gbuffers_*`** programs that write **only** what the first milestone needs (avoid allocating every `colortex` before use).
- [ ] **M** Add **`final.vsh` / `final.fsh`** (or equivalent) for tonemap / pass-through consistent with MVP goals.
- [ ] **H** Layer **`composite*` / `deferred*`** only when the G-buffer contract is exercised in code; keep pass count justified in ARCHITECTURE.

### Additions (skeleton)

- 

---

## 2. Properties and configuration hygiene

Keep configuration reviewable and diff-friendly.

- [ ] **E** Document each non-default **`shaders.properties`** key with a one-line **WHY** comment (where the format allows) or in ARCHITECTURE / My_Thoughts.
- [ ] **M** Version **quality profiles** (`profile=`) only after baseline stability; avoid premature preset sprawl.
- [ ] **M** Align **`colortexNFormat`** with the packing described in [ARCHITECTURE.md](ARCHITECTURE.md); update ARCHITECTURE when implementation diverges.
- [ ] **H** Plan **dimension overrides** (`world0/`, `world-1/`, `world1/`) only when base overworld path is stable.

### Additions (properties)

- 

---

## 3. Tooling (developer workflow)

Automation and helpers that stay maintainable on Windows and in CI.

- [ ] **E** Add **`README.md`** (or `DOCS/`) section: how to symlink or copy the repo into `.minecraft/shaderpacks` for local iteration.
- [ ] **M** Script or documented workflow to **package a zip** matching the folder name Minecraft expects (no accidental nested folders).
- [ ] **M** Optional: **GLSL validator** or preprocessor step in CI — only if it matches Iris/OF constraints (many packs rely on loader-specific defines).
- [ ] **H** Optional: **lint/format** for GLSL — evaluate cost vs. benefit; do not block shipping on perfect style.
- [ ] **M** Track tooling versions in [SBOM.md](SBOM.md) when new packages or binaries are introduced.

### Additions (tooling)

- 

---

## 4. Verification and test suite

Shader packs are hard to unit-test like application code; favor **fast feedback** and **repro steps**.

- [ ] **E** **Smoke test checklist** (manual): pack selects without compile error; overworld loads; toggle one option if sliders exist.
- [ ] **M** **Golden-scene** discipline: save a world seed + coordinates + time-of-day for before/after screenshots when changing lighting.
- [ ] **M** Document **known-good** and **known-broken** GPU/driver combos when discovered.
- [ ] **H** Optional: **screenshot comparison** (pixel diff) — fragile; only if pinned resolution and stable scene.
- [ ] **X** Optional: **headless** or automated in-game testing — usually out of scope until a dedicated harness exists; record blockers in [SCRATCHPAD.md](SCRATCHPAD.md).

### Additions (verification)

- 

---

## 5. CI and quality gates

- [ ] **E** CI job: **repository sanity** (required files present, no accidental binary bloat in git).
- [ ] **M** CI job: **markdown / link** checks if introduced tooling supports it without noisy false positives.
- [ ] **H** CI job: **shader compile** only if a reliable offline compiler path exists for our target defines.

### Additions (CI)

- 

---

## 6. Release and compatibility

- [ ] **M** **Versioning** scheme for pack releases (semver of repo vs. in-game name); document in SUMMARY or README.
- [ ] **M** **Changelog** entry per user-visible change ([CHANGELOG.md](CHANGELOG.md)).
- [ ] **H** **Upgrade notes** when bumping MC or loader (breaking uniforms, renamed files).

### Additions (release)

- 

---

## 7. Backlog and future work

Large features deferred until skeleton + MVP are stable.

- [ ] **H** Full **PBR** path aligned with LabPBR resource packs.
- [ ] **H** **Shadow** quality passes (PCF/PCSS) and performance profiles.
- [ ] **H** **Volumetrics** (fog, god rays) after composite chain is understood.
- [ ] **X** **TAA**, **SSR**, and other advanced post — only with motion vectors / history strategy defined.

### Additions (backlog)

- 

---

## Open questions

Record decisions here as they land (append dated one-liners).

- 
