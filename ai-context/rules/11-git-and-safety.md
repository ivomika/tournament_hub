# Git and change safety

## Trigger

Всегда для файлов/git; особенно delete/move, generated files, secrets, dirty worktree, commit, push, deploy или внешнего сообщения.

## Обязательно

- Сохранить пользовательские изменения и ограничить diff scope задачи.
- Проверить точные targets перед destructive action.
- Получить явную авторизацию на commit/push/deploy/external mutation.

## Запрещено

- Destructive reset/history rewrite или broad recursive delete без прямого запроса.
- Добавлять secrets, local DB, build outputs и raw diagnostics.
- Коммитить без прямого запроса пользователя.

## Канон

- [Development Git safety](../../docs/development/README.md#git-safety)

## Evidence

`git status`, scoped diff, secret/artifact review и ссылка на авторизацию внешнего/commit действия.
