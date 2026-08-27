# Git и безопасность изменений

- Сохраняй dirty worktree пользователя и не форматируй unrelated files.
- Не используй destructive reset/checkout/history rewrite без прямого запроса.
- Перед delete/move проверь точные абсолютные targets; broad recursive path запрещён.
- Не добавляй secrets, local DB, env files, build outputs и raw diagnostics.
- Generated files меняются генератором, не вручную.
- Коммит только по прямому запросу; один commit — одна логическая задача, сообщение по-русски.
- Push, deployment и внешние сообщения требуют отдельной явной авторизации.
