# After Action Review

Continuous improvement log. Each session ends with a brief review: what went well, what didn't, what to change. This is the POOGI (Process Of Ongoing Improvement) record for this project.

## 2026-06-03 — Project setup: repo, vision, and language decision

**What went well:**
- Clean repo setup workflow: existing script preserved, symlinked, version-controlled in one pass
- Vision doc evolved through conversation — hybrid Go+Python decision emerged organically rather than being forced upfront
- Good separation established early: VISION.md for direction, TODO.md for execution

**What didn't go well:**
- Git push broke because I switched the remote from HTTPS to SSH without checking how existing repos are configured. Wasted time on a self-inflicted problem.

**What we'll do differently:**
- Never change git remote protocol — diagnose within the existing HTTPS + gh auth setup (already saved to memory)
- Check a working repo's remote config before making assumptions about auth method
