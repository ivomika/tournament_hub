# Тестирование и качество

- Тест размещай на самом нижнем слое, владеющем поведением.
- Domain rules покрывай unit/property/invariant tests с воспроизводимым seed.
- Data changes требуют migration, round-trip, failure/rollback fixtures.
- Protocol changes требуют duplicate/reorder/gap/reconnect/version/redaction tests.
- UI changes требуют adaptive, state и accessibility/widget/component coverage.
- Перед сдачей выполняй `make check`, когда command существует и не запрещён.
- Не скрывай failure через удаление assertion, ignore или беспричинный timeout.
- Непроведённую проверку и риск запиши явно; build запускай только когда нужен и разрешён.
