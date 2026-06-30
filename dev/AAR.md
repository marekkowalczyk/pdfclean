# After Action Review

Continuous improvement log. Each session ends with a brief review: what went well, what didn't, what to change. This is the POOGI (Process Of Ongoing Improvement) record for this project.

## 2026-06-30 — M0 complete: Unix citizenship, bats tests, pdftools suite

**What went well:**
- M0 fully completed in one session — a lot of ground covered efficiently
- bats test suite paid off immediately: uncovered the leading-dash filename bug that was present but not yet visible
- Diagnosing the `mdtopdf` / `cpdf` in-place warning was quick and accurate — right tool, right cause
- pdftools meta-repo decision and setup was clean and fast

**What didn't go well:**
- README.md and CLAUDE.md drifted badly from the script — caught only at close
- Initial pdftools structure (bundled `tools/` dir) was inconsistent and had to be immediately redone; the uniformity issue was predictable upfront
- The leading-dash filename problem wasn't anticipated before writing the `--` feature

**What we'll do differently:**
- Update README when adding/changing flags — treat it as part of the same task, not a separate step
- Before creating a multi-component repo structure, ask "is this uniform?" before building it

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
