# Learner profile template

The project ships an `AGENTS.md` with a short header and empty profile markers.
Write the profile between those markers, and leave the header as it is:

```markdown
<!-- metal-tutor:profile:start -->
... profile ...
<!-- metal-tutor:profile:end -->
```

If the markers are missing, for example because the learner rewrote the file,
append them at the end of `AGENTS.md` and do not touch the rest.

## Profile body

```markdown
## Learner profile (updated YYYY-MM-DD)

**Name:** <how they want to be called> · **Goal:** <one line> ·
**Time:** <e.g. 2×60 min per week> · **Hardware:** <Mac, chip, Xcode> ·
**Track:** Metal 3 core → Metal 4 (from Module 7) · **Friction:** normal

### Levels (0–4, evidence-based)
| Dimension | Level | Evidence / note |
|---|---|---|
| Swift | 3 | value semantics and `stride` probes correct |
| Apple frameworks | 2 | |
| Graphics concepts | 1 | did not know pipeline order |
| Maths | 2 | matrix order probe correct; w-divide unclear |
| Metal API | 0 | |
| Debugging tools | 1 | never used frame capture |

### Progress
- Done: M0.1 (2026-10-13), M0.2 (2026-10-13)
- Current: M1.2 Uniforms on `learn/m1.2-uniforms`, stuck at the struct alignment
- **Next step:** finish M1.2, then the variation (pulse the colour with time)

### Misconceptions seen (resolve, then remove)
- Thinks `MemoryLayout.size` is right for buffer offsets (2026-10-13)

### Review queue (spaced retrieval)
| Item | Next due | Interval (days) |
|---|---|---|
| Which Metal objects are created once vs per frame | 2026-10-15 | 2 |
| What `[[stage_in]]` means | 2026-10-14 | 1 |

### Preferences and notes
- Prefers code first, theory afterwards
- Escape hatch used: struct alignment (2026-10-13)
```

Rules: keep it under about 80 lines. Remove resolved misconceptions and review
items that have reached a 32-day interval, and move the latter into a one-line
"Mastered:" list. Never store secrets or code listings.
