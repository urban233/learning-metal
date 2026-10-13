# Curriculum

Design rules:
- **Every exercise ends with something visible**, at most about 30 minutes
  after it starts. Prefer changes that show up in the running playground within
  seconds.
- **Follow Apple's official samples.** Each module names the sample that covers
  the same ground. The learner builds the thing *first*, then reads the
  sample and compares: "What did Apple do differently, and why?" That comparison
  is a standing exercise. Check that a sample's title still exists in the
  Metal Sample Code Library before naming it; many older samples are in
  Objective-C, which turns them into porting exercises.
- **A checkpoint closes each module.** The learner answers it without help
  before the module counts as done.
- Exercise IDs (`M1.2`) go into the profile.

Tracks: the **core track** (Modules 0–6) uses the classic Metal API
(`MTLCommandQueue`, `MTLCommandBuffer`), which most learning material and
samples use. Module 7 moves to **Metal 4** (`MTL4*`, Apple silicon and macOS 26
or newer). From then on, new code uses Metal 4 where the hardware allows it.
A learner who already knows the classic API may start Module 7 early.

---

## Module 0: Shader playground (instant results)
Setup: the **Playground** target that ships with the project; edit only
`Playground/Shaders/Playground.metal` while it runs, and save with ⌘S.
- **M0.1** Change the colours; make the screen red, then a horizontal gradient
  from `in.uv.x`.
- **M0.2** Draw a circle by computing the distance from the centre. Then fix
  its egg shape with `u.resolution` (the aspect ratio). *Predict first:
  why is it an ellipse?*
- **M0.3** Animate it: make it pulse with `u.time`, and add a soft edge with
  `smoothstep`.
- **M0.4** A grid of circles with `fract`, then a checkerboard.
- **Variation:** a 2D signed-distance scene (circle ∪ box), shaded by distance.
- **Checkpoint:** "Which code runs once per pixel, and which once per vertex,
  in this playground? How many times per second does the fragment function
  run at 800×600 and 60 fps?"

## Module 1: Your own renderer from scratch
The learner now rebuilds what the playground hid, from an empty template:
*File ▸ New ▸ Target… ▸ macOS ▸ App* (SwiftUI, Swift), named for example
`Triangle`. They turn on Metal API and shader validation in that scheme's
*Run ▸ Diagnostics* themselves.
Sample: **Using Metal to draw a view's contents**, then **Using a render
pipeline to render primitives** (the classic "Hello Triangle").
- **M1.1** The new target with an `MTKView`: clear to a colour that
  changes over time. They name every object from device to drawable.
- **M1.2** A triangle from a Swift array of vertices in an `MTLBuffer`, with
  vertex and fragment functions in a `.metal` file and per-vertex colours.
  *Planted lesson:* a Swift struct of `SIMD3<Float>` versus the shader's
  `float3` (stride 16), and `packed_float3`.
- **M1.3** Uniforms: one struct shared between Swift and the shader through a
  C header (`ShaderTypes.h`) set as the target's *Objective-C Bridging Header*
  (the playground's hand-matched Swift struct is the anti-pattern this
  replaces). Animate the triangle's position.
- **M1.4** Host the `MTKView` in SwiftUI with `NSViewRepresentable`; compare
  with how `Playground/PlaygroundView.swift` does it.
- **Best-practice focus:** what you create once versus per frame; the
  pipeline state built at startup; the `default.metallib` Xcode compiles at
  build time versus the playground's runtime recompilation (when each makes
  sense).
- **Checkpoint:** "Draw the object graph from `MTLDevice` to presented pixels,
  and mark what is transient."

## Module 2: CPU–GPU synchronisation
Sample: **Synchronizing CPU and GPU work**.
- **M2.1** *Break it:* write per-frame uniforms into one shared buffer and add
  heavy GPU work. Observe the tearing or flicker, and explain it.
- **M2.2** Fix it with a ring of 3 uniform buffers and a `DispatchSemaphore`
  signalled in `addCompletedHandler`.
- **M2.3** Instrument it: measure the CPU and GPU frame times
  (`commandBuffer.gpuStartTime` and `gpuEndTime`); open the Metal performance HUD
  (`MTL_HUD_ENABLED=1`).
- **Checkpoint:** "Why three buffers rather than two? What happens with one?"

## Maths interlude (before Module 3, if maths is below 3)
In a small *macOS ▸ Command Line Tool* target, with `simd`: dot and cross products,
building translation, rotation and scale matrices by hand, column-major
order, and a perspective matrix derived on paper and then coded. *Friction:*
the learner derives the perspective matrix before looking it up.

## Module 3: Into 3D
Sample: **Calculating primitive visibility using depth testing**.
- **M3.1** An indexed cube (`drawIndexedPrimitives`), with model, view and
  projection matrices built by the learner's own `simd` helpers.
- **M3.2** The depth buffer: first predict what goes wrong without it, then
  add a `depthStencilPixelFormat` and an `MTLDepthStencilState`.
- **M3.3** Culling and winding: *bug hunt* with the winding order flipped.
- **M3.4** An orbit camera driven by mouse drag.
- **Checkpoint:** "Trace one vertex from model space to a pixel: which
  spaces does it pass through, and where does the divide by w happen?"

## Module 4: Textures
Sample: **Creating and sampling textures**.
- **M4.1** Load an image with `MTKTextureLoader` and texture the cube; build
  an `MTLSamplerState`.
- **M4.2** Mipmaps: generate them with a blit encoder; compare the shimmer
  with and without them on a tilted plane.
- **M4.3** Get sRGB versus linear wrong on purpose, then fix it.
- **Checkpoint:** "Why does `.bgra8Unorm_srgb` change how your texture looks?"

## Module 5: Lighting and real meshes
- **M5.1** Normals and diffuse plus Blinn–Phong specular lighting, in world
  space; the normal matrix and why it is needed.
- **M5.2** Load an OBJ or USDZ with Model I/O → `MTKMesh`; respect the vertex
  descriptor.
- **M5.3** Several lights through a constant buffer.
- **Checkpoint:** "Non-uniform scale breaks your lighting. Why, and what is the fix?"

## Module 6: Compute
Samples: **Performing calculations on a GPU** and **Processing a texture in a
compute function**.
- **M6.1** Add two arrays on the GPU in a Command Line Tool target; check the
  results on the CPU.
- **M6.2** An image filter (greyscale, then a blur) on a texture; threadgroup
  size from `threadExecutionWidth` and `maxTotalThreadsPerThreadgroup`.
- **M6.3** Game of Life or a particle system: compute writes, render reads,
  both in the same frame.
- **Checkpoint:** "When do you need `dispatchThreads` versus
  `dispatchThreadgroups`, and what does non-uniform threadgroup support buy you?"

## Module 7: Metal 4
Sample: **Drawing a triangle with Metal 4** (check the title), plus the WWDC25
Metal 4 sessions. Check each type against the SDK's `MTL4*.h` headers before
teaching it.
- **M7.1** Port the M1.2 triangle to Metal 4: `MTL4CommandQueue`,
  `MTL4CommandAllocator` per frame in flight, `MTL4CommandBuffer`,
  `MTL4ArgumentTable`, and a `MTLResidencySet`.
- **M7.2** Compile the pipelines with `MTL4Compiler`.
- **M7.3** Explicit synchronisation: barriers between the compute and render
  stages (port M6.3).
- **Checkpoint:** "List three responsibilities that moved from the driver to
  you in Metal 4, and why that can be faster."

## Module 8: Render passes and post-processing
Sample: **Customizing render pass setup**.
- **M8.1** Render to an offscreen texture, then a full-screen pass that reads
  it (the playground's triangle trick comes back).
- **M8.2** HDR (`.rgba16Float`), tone mapping, and bloom with compute.
- **M8.3** Load and store actions: choose them deliberately and justify each
  one (tile memory on Apple GPUs; `memoryless` textures for depth).
- **Checkpoint:** "Which store action for the depth attachment, and why?"

## Module 9: Scale
Samples: **Encoding indirect command buffers on the GPU**, **Rendering a scene
with deferred lighting** (Swift version), and **Using argument buffers with
resource heaps**.
- **M9.1** Instancing: 10 000 cubes in one draw call.
- **M9.2** Argument buffers or bindless resources (or Metal 4 argument tables
  with GPU addresses).
- **M9.3** GPU-driven culling with indirect command buffers.
- **Checkpoint:** "Profile M9.1 in an Xcode frame capture and name the bottleneck."

## Electives (by goal)
Ray tracing (**Accelerating ray tracing using Metal**), mesh shaders
(**Adjusting the level of detail using Metal mesh shaders**), tile shading and
imageblocks (**Implementing order-independent transparency with image
blocks**), MetalFX upscaling, and visualising scientific data (volume ray
marching, point clouds, molecular surfaces).

## Capstones
Pick by goal: a small game scene, a molecule viewer (spheres as instanced
impostors with ray-cast quads), an image-processing app, or a GPU particle
toy. The learner writes a short design note first; you review it with
`best-practices.md` before they code.
