# Документация TournamentHUB

`docs/` — каноническое место для документации проекта: требований, предметной области, архитектуры, решений, контрактов и руководств по работе с системой.

## Правила ведения

- Документация пишется на русском языке.
- Технические identifiers, имена протоколов, форматов, библиотек и API сохраняются без перевода, когда перевод искажает их смысл.
- Документ описывает фактическое решение и его границы, а не предполагаемую реализацию.
- При изменении поведения, контракта, архитектуры, требований или существенного решения обновляется связанный документ либо создаётся новый.

`ai-context` хранит процесс работы над задачами; `docs` хранит устойчивые знания о самом продукте и системе.

## Предметная область и правила турнира

- [Назначение и роли пользователей](product/overview.md) — какую проблему решает TournamentHUB, для кого он предназначен и чем отличаются Host, гость-игрок и Spectator.
- [Базовые правила турниров MK11](source/mk11_tournament_rules_ru.md) — источник бизнес-правил, по которым должно работать приложение: DE/SE/RR, FT, очки и tie-break, Bye, технические результаты, снятие участников, исправление результатов и итоговые места.

При проектировании турнирной логики и её тестов использовать этот документ; содержание не дублировать в правилах разработки `ai-context/rules`. Ссылка определяет требования, но сама по себе не подтверждает их реализацию в текущем коде.

## Архитектура

- [Расположение приложений](architecture/app-layout.md) — структура репозитория и Flutter-клиент.
- [Границы слоёв](architecture/layer-boundaries.md) — ответственности app/domain/infrastructure/presentation, DI, вызовы use cases и изоляция библиотек.
- [Типизация, локализация и темы](architecture/typed-localized-themed-ui.md) — типизированные значения, intl и обязательная токенизация компонентов.
- [Композиция widgets и callbacks](architecture/widget-composition.md) — приватные widgets, const и именованные обработчики.
- [Архитектура presentation](architecture/presentation-ui.md) — foundation/components/widgets, обособленные screens и presentation-контракты.

## Дизайн

- [Базовый foundation](design/foundation.md) — тёмная палитра, шрифты, Widgetbook и происхождение assets.
- [Manifest токенов](design/tokens-manifest.md) — семантические цвета, текстовые роли и используемые layout-параметры.
- [HTML-прототип экранов](design/html-prototype.md) — обсуждаемые mobile-first макеты и состояния, без редактора и бизнес-логики.

## Разработка

- [Domain architecture checker](development/domain-check.md) — локальный viewer Domain-объектов и связей.
- [Аудит правил кода](development/code-rules-audit.md) — локальный skill с scope diff, весь код или задача.
- [Организация правил](development/rule-organization.md) — scope core/flutter, именованные подправила и сопровождение.
- [Архитектурный тест Flutter](development/flutter-architecture-check.md) — package-импорты и проверка зависимостей слоёв.
- [Тестирование кода](development/code-testing.md) — выбор тестов и фактическая проверка изменений.
- [Локальные skills](development/repository-skills.md) — единое расположение навыков проекта.
- [AI development workflow](development/ai-development-workflow.md) — экспериментальный процесс, walkthrough и точки подключения.
- [Widgetbook](development/widgetbook.md) — отдельный пустой каталог и запуск VS Code.
- [Визуальный workflow](development/visual-workflow.md) — scoped Widgetbook, общие сценарии и обязательные нативные goldens по платформам.
