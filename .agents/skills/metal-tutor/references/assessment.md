# Assessment

Goal: place the learner on six dimensions, each on a 0–4 scale, using evidence
rather than self-image, and pick the starting module. It should take 10–15
minutes. One or two questions per turn.

## Scale (same for every dimension)

| Level | Meaning |
|---|---|
| 0 | Never touched it |
| 1 | Has read about it or followed a tutorial with help |
| 2 | Can do routine tasks alone, looking things up |
| 3 | Comfortable; can explain the why and debug unfamiliar problems |
| 4 | Could teach it; knows the performance and edge cases |

## Phase A: context (self-report, as numbered options)

1. **Goal:** what do you want to build? (games or real-time 3D, scientific or
   data visualisation, image or video processing, GPU compute, curiosity or a
   portfolio, a job)
2. **Time:** how much time per session, and how many sessions per week?
3. **Hardware:** which Mac, and is it Apple silicon? Which Xcode version?
   Check this yourself if you can: `sysctl -n machdep.cpu.brand_string`,
   `xcodebuild -version`. Apple silicon with macOS 26 or newer unlocks the
   Metal 4 track.
4. **Prior graphics APIs:** OpenGL, Vulkan, Direct3D, WebGPU or WebGL, a game
   engine, shader toys, or none.
5. **Learning preferences:** theory first or code first? How much friction:
   "push me hard", "normal", or "gentle"? This sets the friction level.

## Phase B: self-ratings plus diagnostic probes

Ask for the self-rating, then **verify** every rating of 2 or higher with one
probe. When the probe and the rating disagree, record the probe's level and
note the gap kindly ("you rated maths 3; the matrix-order probe suggests 2,
so we'll revisit it briefly").

### Swift
- Probe (level 2): "What does this print, and why?"
  ```swift
  struct P { var x = 0 }
  var a = P(); var b = a; b.x = 5; print(a.x)
  ```
- Probe (level 3): "Why might `MemoryLayout<SIMD3<Float>>.size` and `.stride`
  matter when you copy an array of them into a GPU buffer?" (both are 16 →
  SIMD3 is padded; a packed C struct of 3 floats is 12)
- Probe (level 3): "What does `@MainActor` on a class guarantee, and why
  would a render delegate care?"

### Apple app frameworks (AppKit, SwiftUI, UIKit)
- Probe (level 2): "How would you put an `MTKView` into a SwiftUI view?" (an
  `NSViewRepresentable` or `UIViewRepresentable`)

### Graphics concepts
- Probe (level 1→2): "Put these in pipeline order: rasterisation, fragment
  shading, vertex shading, blending, depth test."
- Probe (level 2): "A triangle you expected to see is invisible. Name three
  possible causes." (winding order and culling, clip-space z or w, depth test,
  wrong viewport, a fragment that outputs alpha 0 with blending on)
- Probe (level 3): "Why does the GPU interpolate vertex outputs
  perspective-correctly, and when would you not want that?" (`[[flat]]`,
  `[[center_no_perspective]]`)

### Maths
- Probe (level 1→2): "What is the dot product of two unit vectors used for in
  lighting?"
- Probe (level 2): "You want to scale, then rotate, then translate a model.
  In what order do you multiply the matrices when transforming column vectors?"
  (T·R·S, i.e. `translation * rotation * scale`; simd uses column-major)
- Probe (level 3): "What does the w component carry after the projection
  matrix, and what happens to it before rasterisation?"

### Metal API
- Probe (level 1): "Name the objects you need, from device to pixels, to
  clear the screen to red."
- Probe (level 2): "Which of these do you create once, and which every
  frame: `MTLDevice`, `MTLCommandQueue`, `MTLRenderPipelineState`,
  `MTLCommandBuffer`, `MTLRenderCommandEncoder`, `MTLBuffer` for per-frame
  uniforms?"
- Probe (level 3): "You write uniforms into one shared `MTLBuffer` every frame
  and see flicker under load. Why? Fix it." (CPU and GPU race → a ring of 3
  buffers plus a semaphore)
- Probe (level 4): "What did Metal 4 change about command buffers and
  resource binding?" (`MTL4CommandAllocator`, reusable command buffers, argument
  tables, residency sets, explicit barriers)

### Debugging tools
- Probe (level 1→2): "Have you used Xcode's GPU frame capture? What would you
  look at first if a draw renders nothing?"
- Probe (level 2): "What do `MTL_DEBUG_LAYER=1` and `MTL_SHADER_VALIDATION=1`
  do?"

## Phase C: placement

- Starting module = the first curriculum module whose prerequisites the
  learner does **not** clearly meet. When in doubt, start one module lower
  and move quickly: a fast early win builds momentum.
- A gap in maths (below 2) does not block Module 0–1. Schedule the curriculum's
  maths interludes before Module 3.
- Metal API 0–1 always starts at Module 0, even for an experienced OpenGL or
  Vulkan programmer; such a learner moves through it fast, with the focus on
  "how does Metal differ?".

Present the result as a compact table (dimension, level, evidence), then the
starting module and the plan for the first session. Ask whether it matches
their view, then write the profile.
