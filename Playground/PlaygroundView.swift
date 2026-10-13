import MetalKit
import SwiftUI

/// The playground window: the Metal view, plus the shader compiler's error
/// message laid over it while the last saved shader does not compile.
struct PlaygroundView: View {
    @State private var renderer = Renderer()

    var body: some View {
        MetalView(renderer: renderer)
            .overlay(alignment: .bottomLeading) {
                if let message = renderer.shaderError {
                    ScrollView {
                        Text(message)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.white)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                    }
                    .frame(maxHeight: 180)
                    .background(.red.opacity(0.85))
                }
            }
    }
}

/// Hosts an `MTKView` in SwiftUI and makes the renderer its delegate.
struct MetalView: NSViewRepresentable {
    let renderer: Renderer

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: renderer.device)
        view.colorPixelFormat = Renderer.colorPixelFormat
        view.preferredFramesPerSecond = 60
        view.delegate = renderer
        return view
    }

    func updateNSView(_ nsView: MTKView, context: Context) {}
}
