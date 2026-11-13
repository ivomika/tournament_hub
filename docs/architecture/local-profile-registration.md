# Локальный профиль: регистрация и редактирование

Решение задачи112, 2026-11-11. При старте приложение читает сохранённый профиль после runApp. Регистрация нужна только при отсутствии профиля или его имени. Отдельного firstLaunch/onboardingCompleted флага нет: готовность определяется фактическими данными.

## Поведение

1. Bootstrap загружает запись профиля. Во время чтения отображается «Загружаем профиль…».
2. Если записи нет или имя отсутствует/пустое после trim, открывается RegistrationRoute. Участник вводит имя и нажимает «Продолжить».
3. RegisterProfileUseCase проверяет имя, читает актуальный профиль и сохраняет заполненный. Если ID уже существует, он сохраняется; иначе выдаётся один новый идентификатор через общий IdentifierGenerator.
4. После успешного сохранения controller отправляет ProfileRegisteredIntent. App guard проверяет текущую запись-источник и наличие успешно сохранённого профиля; effect выполняет go(HomeRoute).
5. При следующих запусках заполненный профиль ведёт на HomeRoute без повторной выдачи ID и регистрации.

Имя — непустой пользовательский текст после trim. Ограничения длины, алфавита и уникальности имён не вводились. Нет авторизации, пароля, серверного аккаунта, синхронизации или восстановления после удаления данных приложения. Это профиль текущей установки. Удаление локальных данных может привести к новой регистрации/ID.

## Контракты и границы

| Слой | Элементы | Ответственность |
| --- | --- | --- |
| domain/identifiers | UniqueIdentifier, IdentifierGenerator | Общий тип и синхронный port генерации; UUID package не раскрывается |
| domain/profile | ProfileId, ProfileName, LocalProfile | ID профиля, нормализованное имя, заполненный/неполный профиль |
| domain/profile | ProfileRepository, LoadProfileUseCase, RegisterProfileUseCase, UpdateProfileNameUseCase | Отменяемые чтение/сохранение, отдельные сценарии регистрации и редактирования |
| infrastructure/identifiers | UuidIdentifierGenerator | Пакет uuid, генерация UUID v4 |
| infrastructure/storage | KeyValueStorage, PreferencesKeyValueStorage | Минимальные read/write String по типизированному StorageKey; SharedPreferencesAsync скрыт внутри адаптера |
| infrastructure/profile | ProfileCodec, StoredProfileRepository | Версионирование записи, проверка внешнего формата, typed failures |
| app/bootstrap | InitializeProfileStep, ProfileBootstrapContext | Чтение после runApp, передача зависимостей и первоначальных данных навигации |
| app/profile | AppProfileSession | App-снимок успешно прочитанного/сохранённого профиля для guard и отображения |
| app/routing | RegistrationRoute, RegistrationBinding | URI, стабильный controller/текстовый controller, scoped intent sink, владение lifecycle |
| presentation/screens/registration | RegistrationController, State, Screen, Theme | Состояния формы и вызов use case только из controller; экран компонует DS |

AppProfileSession не является второй постоянной базой: снимок обновляется наблюдающим repository только после успешного read/save. Сохранение реально выполняет domain repository. Сам completion intent не содержит команды «пометить профиль готовым» и не может подменить результат записи.

RegisterProfileUseCase не используется для редактирования существующего заполненного профиля: возвращает его без перезаписи и генерации ID. Изменение имени — отдельный UpdateProfileNameUseCase, подключённый задачей114 ниже. Синхронизация регистрации разных процессов/устройств не реализована; двойное нажатие в текущем controller разделяет одно in-flight выполнение.

## Хранение и внешний формат

Реализован SharedPreferencesAsync2.5.6. Один StorageKey.localProfile кодируется в инфраструктурный ключ `tournament_hub.local_profile`. ID/имя сохраняются одной строковой записью, без отдельных несогласованных flags. Текущая версия JSON:

```json
{"version":1,"id":"6fa459ea-ee8a-4ca4-894e-db77e160355e","name":"Иван"}
```

Codec проверяет version1, UUID v4 и тип имени. Отсутствующее/null/пробельное имя означает неполный профиль с существующим ID. Отсутствующий/некорректный ID, неверные типы, сломанный JSON или неизвестная версия — ProfileFailureReason.corrupt. Сырая Map существует только на границе codec и не выходит в domain. Payload не перезаписывается при ошибке чтения/декодирования; повреждение не подменяется отсутствием профиля. Схема не мигрирует неизвестные будущие версии.

SharedPreferencesAsync не использует локальный cache и поддерживает целевые платформы пакета. Это локальное preferences-хранилище, без гарантий шифрования или crash-durability: завершение setString не является гарантией физического flush на диск. Запись не предназначена для серверных credentials/критических долговечных данных. При появлении такого требования необходимо заменить storage adapter, сохранив domain port. Ограничения API: [официальный README](https://pub.dev/packages/shared_preferences).

UUID4.6.0 выбран только для infrastructure adapter: [API пакета](https://pub.dev/packages/uuid). Domain знает общий IdentifierGenerator, а ProfileId остаётся отдельным предметным типом. Проверка выборки UUID подтверждает корректный формат и отсутствие повторов в ней, а не математическое доказательство невозможности коллизии.

## Ошибки, навигация и отмена

- ProfileFailureReason.invalidName: поле показывает локализованную ошибку; ID/запись не создаются.
- read/corrupt на старте: BootstrapFailed с причиной dependencyUnavailable, исходным ProfileException в cause и отдельным UI-сообщением о профиле. Рабочее приложение не запускается; доступен retry того же шага. Повтор не удаляет повреждённую запись автоматически.
- write: имя остаётся в форме, Home не открывается; доступен повтор. Если запись ранее не удалась, неподтверждённый ID не объявляется сохранённой идентичностью.
- Пока требуется регистрация, guard запрещает рабочие URI/Back и любые рабочие intents. После заполнения RegistrationRoute отклоняется. Маршрут регистрации — sibling под HomeRoute; адресная иерархия не разрешает обход guard.
- Старый origin и двойной completion обрабатывает общий coordinator. Controller не вызывает GoRouter/Navigator; concrete route/эффект остаются в app.
- Controller владеет OperationScope; binding закрывает его и TextEditingController. Нет ручного isDisposed в рабочих методах. Повторный submit разделяет одно ожидание, а недоступные visual actions получают null.
- OperationSequence последовательно владеет read/save через scope. Отмена на чтении не начинает генерацию/сохранение; закрытый scope не вызывает factory следующего шага. Результат/ошибка позднего источника наблюдаются без доставки закрытому владельцу.
- SharedPreferencesAsync не предоставляет физическую отмену начатого native запроса. Отмена прекращает проектное ожидание/доставку, но уже начатая запись может сохраниться. Она не объявляется откатанной. При следующем старте читаются реальные данные.

Общий pure-Dart механизм отмены теперь в domain/operations; compatibility exports прежних presentation/operations сохраняют идентичность типов, без второго механизма. Контракт: [отменяемые операции](cancellable-async.md).

## Экран, Widgetbook и визуальная проверка

RegistrationScreen принимает immutable RegistrationScreenState, внешний TextEditingController и callbacks. Не знает app/DI/repository/use cases. RegistrationController — отдельный presentation владелец use case, не часть визуального экрана. Preview не выполняет бизнес-операции.

Screen использует AppSimpleFormLayout, AppField, AppNotice и AppButton. Собственная RegistrationScreenTheme наследует текущую AppScreenLayoutTheme; новых primitive значений нет. Весь текст/semantics — intl. Формат mobile390×844 и desktop1440×900 использует существующие responsive DS-токены. Нет отдельной кастомной кнопки/поля регистрации.

Widgetbook: Screens/Registration — empty, editing, invalid, saving, error. Общие deterministic fixture/builders используются golden tests. Bootstrap дополнен preparing-profile и profile-unavailable. Native PNG в golden/windows, тесты зеркально в test/presentation/screens. Другие ОС не подменяются Windows-эталонами.

## Проверки и границы подтверждения

### Редактирование и инициалы · задача114

С2026-11-12 ProfileRoute подключён к ProfileBinding, а ProfileEditRoute — к ProfileEditBinding. Внешние builders остаются точками подмены в tests/preview; production bindings используют AppProfileSession. Экраны не импортируют app/infrastructure, не получают repository/use case и не управляют routing.

UpdateProfileNameUseCase читает актуальный профиль, нормализует ProfileName и сохраняет новый LocalProfile с прежним ProfileId. Отсутствие профиля — ProfileFailureReason.notFound, без регистрации нового. Пустой ввод — invalidName, ошибки read/write сохраняют исходную причину. Если нормализованное имя не изменилось, лишнего save нет. ID генератора, использованный для diagnostic execution, никогда не заменяет ProfileId.

AppProfileSession реализует Listenable поверх ValueNotifier<LocalProfile?>. Это app-снимок фактически подтверждённых read/save; ProfileBinding наблюдает его и передаёт новый immutable ProfileScreenState. Наблюдающий repository регистрирует запросы в принадлежащем сессии OperationScope. После закрытия поздний native ответ не уведомляет уничтоженный notifier. InitializeProfileStep возвращает ресурс с session.close; после navigation session ресурсы закрываются в обратном порядке. Закрытие идемпотентно. Данные уже начатой физически неотменяемой записи могли сохраниться; следующая сессия перечитывает реальное хранилище.

ProfilePresentationMapper отвечает только за отображение: берет первые полные graphemes первого и последнего слова и переводит их в верхний регистр. Одно слово даёт один исходный grapheme; несколько пробелов/переносы разделяют слова. Составные emoji и буква с combining mark не разрезаются по UTF-16 units. Например, «Иван Сергеевич Михайлов» → «ИМ». Полученный state используется и именем, и реальным AppAvatar. Профиль не хранит вычисленные инициалы в persistent JSON, поэтому они не устаревают после редактирования имени.

ProfileEditController получает сохранённое имя и UpdateProfileNameUseCase от app. Рабочие фазы: editing/invalidName/saving/saveError/navigationError/completed. Поле, Back и сохранение недоступны во время saving/completed; repeated save разделяет одно in-flight ожидание. При ошибке записи имя остаётся в поле, доступен retry; новая попытка получает собственный execution ID и номер. Навигационная ошибка после подтверждённой записи имеет отдельный текст «Имя сохранено…», без утверждения о провале save. Повтор в этом случае не перезаписывает уже совпадающее имя.

OpenProfileEditIntent допустим из ProfileRoute. ProfileNameSavedIntent допустим только из активной edit entry в фазе completed, после подтверждённой записи. Guard читает NavigationProfileEditStatus и typed previousRoute. Из Profile→Edit обычный save/Back возвращается PopRouteEffect в исходную запись профиля; прямой URI /profile/edit возвращается GoToRouteEffect(ProfileRoute), потому что generic canPop мог бы вернуть Home. Native Back такого прямого entry сначала отклоняет исходный pop и отправляет scoped BackRequestedIntent в тот же guard/effect. Пока saving, guard отклоняет Back и прямой новый URI; intent completion нельзя подделать до результата. При закрытии binding отменяет delivery/ожидания scope, уничтожает TextEditingController и снимает editor handle; старый callback не записывает данные и не управляет новой entry.

Статистика временно не компонуется в ProfileScreen, включая нулевые/empty CTA. ProfileStatistics и общие DS metrics сохранены для будущего подключения. Переданные statistics не показываются ни на mobile, ни на desktop. Recent tournament при наличии отдельного DTO может отображаться без статистических counters; реальные history/statistics этой задачей не загружаются. Production получает только актуальные имя/инициалы, без выдуманных результатов турниров.

Новых визуальных primitives нет: themes профиля/editor используют существующие runtime DS tokens. Profile Widgetbook показывает актуальные двухбуквенные инициалы; ProfileEdit дополнен invalid/saving/navigation-error в отдельных scoped папках. Общие fixtures используются golden tests. Обновлены10 прежних Windows PNG профиля/editor и добавлены6 PNG новых editor состояний mobile390/desktop1440; другие платформы не подменяются. Начальный набор15 scenarios расширен проверками independent profile sink, позднего read error, Back/URI при saving, stale callback, прямого Back и закрытия app-сессии.

Диагностический контракт обновления имени и privacy-границы: [логирование профиля](logging.md#логирование-изменения-имени--задача114).

- profile_registration_test: реальные use cases/codec/controller/bootstrap/router с подменами только внешних repository/storage/generator/navigation sink. Первый запуск → форма → сохранение → Home → новый bootstrap, ID сохраняется; Back/прямой URL не обходят регистрацию.
- preferences_adapter_test: реальный PreferencesKeyValueStorage/SharedPreferencesAsync с подменой только platform API официальным in-memory backend; новый адаптер читает запись, cache не скрывает внешнее обновление, native failure типизирован, поздняя отменённая запись может commit без late delivery. Проверены missing/blank name и повреждённая схема.
- Существующие bootstrap tests используют сохранённый test profile вместо отсутствующего native plugin runner; их lifecycle/cleanup assertions сохранены. Route catalog проверяет26 concrete types и URI round trips.
- Widget/golden tests проверяют рендер и comparison в текущей native среде. Нативный процесс приложения/сборки/remote CI не запускались; platform fakes не доказывают реальный flush/поведение ОС или установку plugin в ранее собранный binary.
