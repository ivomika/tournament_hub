# UI и accessibility

- Проектируй initial/loading/content/empty/error и offline/stale для network screen.
- Normal text contrast ≥4.5:1, large ≥3:1; state не кодируется только цветом.
- Touch target минимум 44×44; keyboard focus видим и логичен.
- Поддерживай 200% text scale, длинный русский текст и screen-reader semantics.
- Hover, motion и artwork не могут быть единственным носителем информации/action.
- Reduced Motion обязателен; infinite blinking/glow запрещены.
- Async error локален, понятен и имеет recovery; stack trace пользователю запрещён.
- Domain decisions не вычисляются во widget/component/provider.
