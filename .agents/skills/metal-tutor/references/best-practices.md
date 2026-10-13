# Best-practice checklist (for reviews and teaching)

Use it as a source of review *questions*, not as a lecture. Teach each item in
the module where it first becomes relevant.

## Object lifetime
- [ ] `MTLDevice`, the command queue, pipeline states, depth-stencil states,
      samplers and static buffers are created **once**, not per frame.
- [ ] Per frame, only command buffers, encoders and the drawable are created
      (Metal 4: reuse command buffers; reset the per-frame allocator).
- [ ] No `makeBuffer` or `makeTexture` inside `draw(in:)` unless it is
      deliberate and pooled.
- [ ] Pipelines compile at startup or asynchronously, never on first use in a
      frame (stutter). Release builds ship a precompiled `.metallib`.

## CPU–GPU synchronisation
- [ ] CPU-written per-frame data is ring-buffered (usually 3 frames in flight)
      and guarded by a semaphore that the command buffer's completion handler
      signals.
- [ ] No `waitUntilCompleted()` in the frame loop.
- [ ] The drawable is taken as late as possible and held as briefly as
      possible (`currentRenderPassDescriptor` and `currentDrawable` just
      before encoding the pass that needs them).

## Memory and data layout
- [ ] Swift and shader structs match: one shared C header in Xcode, or a
      documented layout; `MemoryLayout<T>.stride` for array offsets.
- [ ] `float3` and `SIMD3<Float>` are 16 bytes; use `packed_float3` only on
      purpose.
- [ ] `setVertexBytes` or `setFragmentBytes` only for small data (under 4 KB);
      larger data goes in buffers.
- [ ] Storage modes chosen on purpose: `.shared` on Apple silicon for CPU-written
      data, `.private` for GPU-only data, `.memoryless` for transient attachments.
- [ ] Load and store actions are deliberate (`.dontCare` where the content is
      not needed).

## Shaders (Metal Shading Language)
- [ ] `half` where the precision is enough (colours, normals) on Apple GPUs.
- [ ] Address spaces are correct: `constant` for uniform data read by all
      threads, `device` for large or written data.
- [ ] No needless divergent branching in hot fragment code; prefer `select`,
      `step` or `mix`.
- [ ] Function constants instead of runtime flags for shader variants.

## Swift
- [ ] Swift 6 strict concurrency: the renderer is `@MainActor`, or its
      cross-thread state is explicitly `Sendable` and synchronised.
      Completion handlers run on an arbitrary thread.
- [ ] Failable Metal factory calls are handled with `guard` and throw, or fail
      loudly with a clear message; no force-unwrap chains.
- [ ] Encoders and command buffers get `label`s, and complex passes get debug
      groups (`pushDebugGroup` and `popDebugGroup`), so captures are readable.

## Debugging and verification
- [ ] Development runs have the API and shader validation on
      (`MTL_DEBUG_LAYER=1`, `MTL_SHADER_VALIDATION=1`).
- [ ] The learner can take a GPU frame capture and inspect the bound resources.
- [ ] Command buffer errors are checked in the completion handler
      (`commandBuffer.error`).

## Metal 4 (when on that track)
- [ ] One `MTL4CommandAllocator` per frame in flight, reset only after the
      GPU finishes with it.
- [ ] Resources are made resident with `MTLResidencySet`, added to the queue
      or the command buffer.
- [ ] Bindings go through `MTL4ArgumentTable`; GPU addresses or resource IDs
      are used correctly.
- [ ] Hazards are handled with explicit barriers or fences between stages,
      since Metal 4 does not track them automatically.
