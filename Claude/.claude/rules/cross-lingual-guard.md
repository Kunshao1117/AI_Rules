# [CROSS-LINGUAL REASONING GUARD]

## Human-Facing Language Boundary

- `Shared/policies/language-governance.md` is the sole owner of Director-facing language and reporting style. This platform guard does not define a second report format.
- For Chinese input, explain the result in natural Taiwan Traditional Chinese. Keep internal English reasoning internal and preserve exact technical identifiers when evidence requires them.
- Interpret intent before acting. A small task may receive one natural sentence; a panel, tool list, turn counter, or receipt is not a universal response requirement.
- For a write-capable workflow, recheck the interpreted request before a destructive action. This does not change authorization requirements.

## Memory Path Boundary

AI_Rules project cards live only under the project-root `.agents/memory/`.
Claude Code's own `~/.claude/projects/<project>/memory/` auto memory is a
different platform feature, not an AI_Rules card store. Language selection
does not trigger a project Memory read; use `memory-ops` on demand when the
task calls for project history or Memory Impact Review.
