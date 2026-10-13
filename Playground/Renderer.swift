import Foundation
import MetalKit
import Observation

/// Mirrors `Uniforms` in `Playground.metal`. `SIMD2<Float>` is 8-byte aligned,
/// so Swift inserts 4 bytes of padding after `time`, exactly as the Metal
/// compiler does.
struct Uniforms {
    var time: Float
    var resolution: SIMD2<Float>
}

/// Draws one full-screen triangle with the playground's fragment shader.
///
/// The shader Xcode compiled into the app bundle runs first. In Debug builds
/// the renderer also watches the source file `Shaders/Playground.metal` and
/// recompiles it whenever it is saved. A save that fails to compile sets
/// `shaderError`, and the last pipeline that compiled keeps rendering.
@MainActor
@Observable
final class Renderer: NSObject, MTKViewDelegate {
    static let colorPixelFormat = MTLPixelFormat.bgra8Unorm_srgb

    /// The compiler message for the last save that failed, or `nil`.
    private(set) var shaderError: String?

    @ObservationIgnored let device: MTLDevice
    @ObservationIgnored private let commandQueue: MTLCommandQueue
    @ObservationIgnored private var pipeline: MTLRenderPipelineState?
    @ObservationIgnored private let startTime = Date()
    @ObservationIgnored private var shaderModificationDate: Date?
    @ObservationIgnored private var lastReloadCheck = Date.distantPast

    /// The shader source next to this file. Only Debug builds read it, on the
    /// Mac that built the app.
    @ObservationIgnored private let shaderSourceURL = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .appending(path: "Shaders/Playground.metal")

    override init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("This Mac has no Metal device.")
        }
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Could not create a Metal command queue.")
        }
        self.device = device
        self.commandQueue = commandQueue
        super.init()
        do {
            guard let library = device.makeDefaultLibrary() else {
                fatalError("The app bundle contains no compiled Metal library.")
            }
            pipeline = try makePipeline(library: library)
        } catch {
            fatalError("Could not build the render pipeline: \(error.localizedDescription)")
        }
        #if DEBUG
            shaderModificationDate = modificationDate(of: shaderSourceURL)
        #endif
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        #if DEBUG
            reloadShaderIfChanged()
        #endif
        guard
            let pipeline,
            let passDescriptor = view.currentRenderPassDescriptor,
            let drawable = view.currentDrawable,
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor)
        else {
            return
        }
        var uniforms = Uniforms(
            time: Float(Date().timeIntervalSince(startTime)),
            resolution: SIMD2(Float(view.drawableSize.width), Float(view.drawableSize.height))
        )
        encoder.label = "Playground"
        encoder.setRenderPipelineState(pipeline)
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    private func makePipeline(library: MTLLibrary) throws -> MTLRenderPipelineState {
        guard let vertexFunction = library.makeFunction(name: "fullscreen_vertex") else {
            throw PlaygroundError.missingFunction("fullscreen_vertex")
        }
        guard let fragmentFunction = library.makeFunction(name: "playground_fragment") else {
            throw PlaygroundError.missingFunction("playground_fragment")
        }
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Playground"
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = Self.colorPixelFormat
        return try device.makeRenderPipelineState(descriptor: descriptor)
    }

    private func modificationDate(of url: URL) -> Date? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        return attributes?[.modificationDate] as? Date
    }

    /// Recompiles the shader source when its modification date changed,
    /// checking at most four times a second.
    private func reloadShaderIfChanged() {
        guard Date().timeIntervalSince(lastReloadCheck) > 0.25 else {
            return
        }
        lastReloadCheck = Date()
        guard let modified = modificationDate(of: shaderSourceURL), modified != shaderModificationDate else {
            return
        }
        shaderModificationDate = modified
        do {
            let source = try String(contentsOf: shaderSourceURL, encoding: .utf8)
            let library = try device.makeLibrary(source: source, options: nil)
            pipeline = try makePipeline(library: library)
            shaderError = nil
            print("Reloaded \(shaderSourceURL.lastPathComponent)")
        } catch {
            shaderError = error.localizedDescription
            print("Shader error:\n\(error.localizedDescription)")
        }
    }
}

enum PlaygroundError: LocalizedError {
    case missingFunction(String)

    var errorDescription: String? {
        switch self {
        case .missingFunction(let name):
            "The shader has no function named `\(name)`."
        }
    }
}
