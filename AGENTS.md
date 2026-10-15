# MetalLearning

This Xcode project is a learning workspace for graphics programming with Metal
and Swift. It is not a product: every agent session here is a **tutoring**
session.

- Use the `metal-tutor` skill (`.agents/skills/metal-tutor/SKILL.md`) for
  every request in this project, and follow its friction rules.
- Never write the learner's exercise code for them; teach them to write it.
- Read the learner profile below before the first reply. If it is empty, the
  skill's assessment comes first.
- Keep the profile current as the skill describes, and change nothing else in
  this file.

<!-- metal-tutor:profile:start -->
## Learner profile (updated 2026-10-15)

**Name:** not provided · **Goal:** real-time 3D graphics ·
**Time:** 2–3×60 min per week · **Hardware:** Apple silicon M-series target, macOS 27, Xcode 27 ·
**Track:** Metal core → Metal 4 (from Module 7) · **Friction:** normal

### Levels (0–4, evidence-based)
| Dimension | Level | Evidence / note |
|---|---:|---|
| Swift | 0 | No prior Swift experience |
| Apple frameworks | 0 | No SwiftUI, AppKit, or UIKit experience |
| Graphics concepts | 1 | Recognizes pipeline stages; ordering not yet secure |
| Maths | 2 | Correct scale, rotate, translate sequence; combined matrix notation needs reinforcement |
| Metal API | 0 | No prior Metal experience |
| Debugging tools | 1 | VS Code and JetBrains experience; new to Xcode and GPU frame capture |

### Progress
- Done: initial assessment (2026-10-13), M0.1 Colours (2026-10-15)
- Current: finish and merge `learn/m0.1-colours`
- **Next step:** M0.2 circle and aspect-ratio correction

### Misconceptions seen (resolve, then remove)
- Pipeline ordering placed depth testing and blending before fragment shading and rasterization (2026-10-13)

### Review queue (spaced retrieval)
| Item | Next due | Interval (days) |
|---|---|---:|
| Simplified graphics-pipeline stage order | 2026-10-14 | 1 |
| Column-vector transform matrix order (`T · R · S`) | 2026-10-14 | 1 |
| Vertex outputs are interpolated during rasterization for fragment inputs | 2026-10-16 | 1 |
| Fragment function runs per covered pixel and returns its color | 2026-10-16 | 1 |

### Preferences and notes
- Prefers theory first, then code, with normal challenge
- Has read parts of the OpenGL SuperBible and some PyMOL OpenGL code
- Targets Apple silicon only
<!-- metal-tutor:profile:end -->
