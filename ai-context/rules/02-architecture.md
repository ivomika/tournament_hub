# Архитектура

- Host Flutter — единственный authority активного турнира; clients не вычисляют business truth.
- Зависимости: presentation/app → application/services → pure Dart domain; infrastructure реализует ports.
- Domain не импортирует Flutter, Riverpod, Drift, JSON, sockets или platform API.
- Один application service координирует один use case и не содержит format rules.
- DE/SE/RR — отдельные versioned engines за registry; switches вне boundary запрещены.
- MK11 roster/assignment отделены Game Definition от Tournament core.
- Dependencies, clock, RNG и IDs передаются явно; global service locator запрещён.
- React — только read-only projection без tournament engine.
