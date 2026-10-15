// Playground.metal — edit, then save with ⌘S: a Debug run recompiles this file live.
// A compile error appears in red in the window; the last good shader keeps running.

#include <metal_stdlib>
using namespace metal;

// Must match `Uniforms` in Renderer.swift, field for field.
struct Uniforms {
    float  time;        // seconds since launch
    float2 resolution;  // drawable size in pixels
};

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

// One triangle that covers the whole screen; no vertex buffer needed.
vertex VertexOut fullscreen_vertex(uint vid [[vertex_id]]) {
    float2 p = float2((vid << 1) & 2, vid & 2);
    VertexOut out;
    out.position = float4(p * 2.0 - 1.0, 0.0, 1.0);
    out.uv = float2(p.x, 1.0 - p.y);
    return out;
}

fragment float4 playground_fragment(VertexOut in [[stage_in]],
                                    constant Uniforms &u [[buffer(0)]]) {
    // float3 color = 0.5 + 0.5 * cos(u.time + in.uv.xyx + float3(0, 2, 4));
    float3 color = float3(1.0 - in.uv.x, 0.0, 0.0);
    return float4(color, 1.0);
}
