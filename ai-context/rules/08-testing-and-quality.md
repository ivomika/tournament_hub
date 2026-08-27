# Testing and quality

## Trigger

Всегда для любого проверяемого изменения.

## Обязательно

- До реализации назвать checks на нижнем ответственном слое.
- Выполнить доступный project quality gate и записать точные результаты.
- Записать каждый skip вместе с причиной и риском.

## Запрещено

- Скрывать failure удалением assertion, ignore или беспричинным timeout.
- Заменять низкоуровневый contract test одним E2E/UI test.
- Называть непроведённую проверку успешной.

## Канон

- [Testing strategy](../../docs/testing/README.md)

## Evidence

Команды, exit/result counts, manual environment и список skips/рисков.
