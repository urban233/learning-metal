# learning-metal

An isolated Xcode project for learning graphics programming with Metal and Swift,
with a tutor skill for the Codex agent in Xcode.

## Requirements

- A Mac with Apple silicon (an Intel Mac works for Modules 0–6; Metal 4 in
  Module 7 needs Apple silicon and macOS 26 or newer)
- Xcode 26.3 or newer, with Codex signed in under *Xcode ▸ Settings ▸
  Intelligence*

Nothing else is installed: no packages, no scripts at build time.

## Start

1. Clone the repository, turn on its git hooks once, and open the project:
   ```bash
   git clone https://github.com/urban233/learning-metal.git && cd learning-metal && git config core.hooksPath .githooks && open MetalLearning.xcodeproj
   ```
2. Select the **Playground** scheme and *My Mac*, and press ⌘R. A window with a
   shifting rainbow appears.
3. Keep it running, change a number in `Playground/Shaders/Playground.metal`,
   and press ⌘S: the window updates without a rebuild.
4. Open the Codex agent in Xcode's coding assistant and write:
   `Use the metal-tutor skill: let's start.` The first session assesses your
   level; the tutor then writes your profile into `AGENTS.md`, where every later
   session reads it.

## Branches: one per learning step

`main` holds only finished exercises. Every exercise happens on its own branch
and reaches `main` through a pull request:

```bash
git switch main && git pull && git switch -c learn/m0.1-colours
```

Commit as you go. When the tutor's checkpoint passes, push the branch and open a
pull request whose description explains what you learned:

```bash
git push -u origin HEAD && gh pr create --fill
```

Then merge it on GitHub and delete the branch. Over time, the closed pull
requests become your learning journal. Branch names follow
`learn/<exercise>-<topic>`, for example `learn/m3.1-indexed-cube`; the tutor
tells you which one to use.

This is enforced in two places:

- **Locally:** the hooks in `.githooks/` refuse commits and pushes made on
  `main` (once `core.hooksPath` is set, as in *Start*).
- **On GitHub:** a ruleset on `main` accepts changes only through pull
  requests, and blocks force pushes and deleting `main`.

## What is in it

| Path | What |
|---|---|
| `MetalLearning.xcodeproj` | The project, with the **Playground** target and a shared scheme that has Metal API and shader validation on |
| `Playground/` | The SwiftUI app for Module 0, which hot-reloads `Shaders/Playground.metal` in Debug runs |
| `AGENTS.md` | Project instructions for the agent, and your learner profile once the tutor has assessed you |
| `.agents/skills/metal-tutor/` | The tutor skill: assessment, curriculum, friction rules, best-practice checklist |
| `.githooks/` | Hooks that keep commits and pushes off `main` |
| `install-codex-skill.sh` | Only needed if Xcode's Codex does not find the skill (see below) |

Your own work goes into new targets in this project (*File ▸ New ▸ Target…*);
the tutor tells you when.

## If Codex does not find the skill

Codex reads skills from the project's `.agents/skills/` folder. If Xcode's
Codex does not pick it up, ask it "Which skills do you have?". If
`metal-tutor` is missing, link the skill into Xcode's Codex configuration and
start a new conversation:

```bash
./install-codex-skill.sh
```

The script only creates a symbolic link at
`~/Library/Developer/Xcode/CodingAssistant/codex/skills/metal-tutor`, which
points back to this project, and it refuses to overwrite anything already there.
If you move the project folder, run it again.

## Hot reload, in short

Xcode compiles `Playground.metal` into the app as usual, so a broken shader also
fails the build. In addition, a Debug run watches the source file next to
`Renderer.swift` and recompiles it on every save. A compile error is shown in red
in the window, and the last good shader keeps running. Release builds use only
the compiled library.
