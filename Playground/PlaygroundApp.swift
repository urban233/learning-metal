import SwiftUI

/// Module 0's shader playground: one window that renders `Shaders/Playground.metal`.
///
/// Run it with ⌘R. In Debug builds, saving `Playground.metal` in Xcode (⌘S)
/// recompiles the shader while the app keeps running; no rebuild needed.
@main
struct PlaygroundApp: App {
    var body: some Scene {
        WindowGroup("Metal Playground") {
            PlaygroundView()
                .frame(minWidth: 480, minHeight: 360)
        }
        .defaultSize(width: 800, height: 600)
    }
}
