# Глоссарий

| Термин | Значение |
|---|---|
| Active Tournament | Единственный незавершённый турнир Host в Draft/Open/Distribution/Running. |
| Assignment | Связь participant с fighter внутри конкретного турнира. |
| Authoritative event | Зафиксированный Host факт после успешного persistence commit. |
| Bout | Одна игровая схватка внутри match/серии, если формат хранит детализацию. |
| Cancelled | Terminal tournament state без выдуманного ranking. Не равен локальному disconnect Participant. |
| Character/Fighter | Игровой персонаж MK11. В коде канонический термин — `Fighter`. |
| Current match | Единственный match, который разрешено проводить сейчас. |
| Draft | Настройка турнира до набора участников. |
| Engine | Versioned domain-реализация математики одного tournament format. |
| Event log | Ограниченный reconnect buffer активного турнира; не source of truth. |
| Finished | Terminal immutable tournament state с полным допустимым ranking. |
| FTn | First-to-n: серия до n побед. |
| Guest | Созданный Host participant без local profile и network client. |
| Historical snapshot | Immutable фактический снимок Finished/Cancelled турнира. |
| Host | Organizer и единственный authoritative узел турнира. |
| Match | Форматная встреча двух participants с winner/loser либо Bye. |
| Normal result | Результат сыгранной встречи, не technical. |
| Open | Набор participants; базовые настройки уже immutable. |
| Participant | Участник состава; может быть local profile Host, remote profile или Guest. |
| Projection | Role-specific read-only представление authoritative state. |
| Revision | Монотонная версия authoritative snapshot после mutation. |
| Ruleset version | Версия неизменяемой семантики format engine. |
| Sequence | Монотонный порядок authoritative events внутри tournament. |
| Snapshot | Versioned serializable representation, отделённая mapper от Domain. |
| Spectator | Read-only React client в LAN. |
| Technical result | Победа/поражение без normal gameplay score по разрешённой причине. |
| Withdrawal | Необратимое снятие participant Host из продолжающегося турнира. |
