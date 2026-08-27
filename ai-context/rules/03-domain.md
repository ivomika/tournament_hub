# Domain и турнирные правила

- Lifecycle: Draft → Open ↔ Distribution → Running → Finished; Cancelled terminal из незавершённого state.
- Finished/Cancelled immutable; navigation не является domain transition.
- Одновременно максимум один active tournament и один Current match.
- Result: normal либо technical; Bye не победа и не played match; draw отсутствует.
- Assignment только Distribution, полный и уникальный; individual reroll запрещён.
- Withdrawal необратим и не переписывает сыгранные results.
- Correction разрешает только engine и только пока downstream match не Finished.
- Ruleset/tie-break/assignment — replaceable versioned contracts; неизвестные детали смотри open decisions.
