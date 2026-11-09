// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'foundation_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class FoundationLocalizationsRu extends FoundationLocalizations {
  FoundationLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get placeholderGreeting => 'Hello World!';

  @override
  String get colorsTitle => 'Цветовая схема';

  @override
  String get colorsDescription =>
      'Графитовая база, тёплое золото и семантические цвета состояний.';

  @override
  String get colorScalesTitle => 'Цветовые шкалы';

  @override
  String get colorScalesDescription =>
      'Константы от светлых к тёмным. Семантическая тема выбирает из них значения для UI.';

  @override
  String get borderStrong => 'Выраженная граница';

  @override
  String get disabledSurface => 'Недоступная поверхность';

  @override
  String get disabledContent => 'Недоступный контент';

  @override
  String get accentHovered => 'Акцент при наведении';

  @override
  String get accentPressed => 'Нажатый акцент';

  @override
  String get focus => 'Фокус';

  @override
  String get accentContainer => 'Акцентный контейнер';

  @override
  String get onAccentContainer => 'Текст на акцентном контейнере';

  @override
  String get successContainer => 'Контейнер успеха';

  @override
  String get onSuccessContainer => 'Текст на контейнере успеха';

  @override
  String get warningContainer => 'Контейнер предупреждения';

  @override
  String get onWarningContainer => 'Текст на предупреждении';

  @override
  String get dangerContainer => 'Контейнер ошибки';

  @override
  String get onDangerContainer => 'Текст на контейнере ошибки';

  @override
  String get informationContainer => 'Информационный контейнер';

  @override
  String get onInformationContainer => 'Текст на информационном контейнере';

  @override
  String get typographyTitle => 'Типографика';

  @override
  String get typographyDescription =>
      'Inter — интерфейс. Roboto Condensed — крупные заголовки и счёт.';

  @override
  String get background => 'Фон приложения';

  @override
  String get surface => 'Поверхность';

  @override
  String get surfaceRaised => 'Поднятая поверхность';

  @override
  String get border => 'Граница';

  @override
  String get textPrimary => 'Основной текст';

  @override
  String get textSecondary => 'Вторичный текст';

  @override
  String get textMuted => 'Подпись';

  @override
  String get accent => 'Золотой акцент';

  @override
  String get onAccent => 'Текст на акценте';

  @override
  String get success => 'Успех';

  @override
  String get warning => 'Предупреждение';

  @override
  String get danger => 'Ошибка';

  @override
  String get information => 'Информация';

  @override
  String get display => 'Крупный заголовок';

  @override
  String get heading => 'Заголовок раздела';

  @override
  String get title => 'Название блока';

  @override
  String get bodyLarge => 'Крупный основной текст';

  @override
  String get body => 'Основной текст';

  @override
  String get label => 'Метка';

  @override
  String get caption => 'Подпись';

  @override
  String get score => 'Счёт';

  @override
  String get headlineSample => 'Турнир начинается';

  @override
  String get bodySample =>
      'Победитель проходит дальше. Результат матча сохраняется в турнире.';

  @override
  String get compactSample => 'Раунд 2 · Матч 4';

  @override
  String get scoreSample => '02 : 01';

  @override
  String fontDetails(String family, int size, int weight) {
    return '$family · $size px · $weight';
  }

  @override
  String get surfaceSample => 'Поверхность';

  @override
  String get raisedSurfaceSample => 'Приподнятая область';

  @override
  String get surfaceLongSample =>
      'Длинное содержимое поверхности занимает несколько строк и сохраняет внутренние отступы.';

  @override
  String get buttonContinue => 'Продолжить';

  @override
  String get buttonCancel => 'Отмена';

  @override
  String get buttonRemove => 'Снять участника';

  @override
  String get buttonBack => 'Назад';

  @override
  String get buttonSave => 'Сохранить';

  @override
  String get buttonLong =>
      'Продолжить создание турнира с выбранными участниками';

  @override
  String get rosterDelete => 'Удалить';

  @override
  String get participantDescription => 'Участник турнира';

  @override
  String rosterRemove(String name) {
    return 'Удалить участника $name';
  }

  @override
  String get characterIce => 'Персонаж · лёд';

  @override
  String get characterFan => 'Персонаж · веер';

  @override
  String get characterStorm => 'Персонаж · шторм';

  @override
  String get typeSource0 => 'TOURNAMENT HUB.';

  @override
  String get typeSource1 => 'Твой следующий турнир';

  @override
  String get typeSource2 => 'Пятничный турнир';

  @override
  String get typeSource3 => 'Основной текст · Aa Бб 012345';

  @override
  String get typeSource4 => 'Продолжить турнир';

  @override
  String get typeSource5 => 'Метаданные и пояснения · FT2';

  @override
  String get typeSource6 => 'Новый турнир';

  @override
  String get typeSource7 => 'Новый турнир';

  @override
  String foundationMetricValue(num value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String get elevationSource => 'floating · 0 8 24 / #07080b80';

  @override
  String get elevationFloating => 'Плавающая поверхность';

  @override
  String get elevationSheet => 'Нижняя панель';

  @override
  String get elevationDialog => 'Диалог';

  @override
  String get fieldNameLabel => 'Название';

  @override
  String get fieldMessageLabel => 'Сообщение';

  @override
  String get fieldNameSample => 'Пятничный турнир';

  @override
  String get fieldMessageSample => 'Хочу предложить улучшение…';

  @override
  String get fieldErrorSample => 'Проверь значение';

  @override
  String get selectLabel => 'Оформление';

  @override
  String get selectDark => 'Тёмное';

  @override
  String get selectLight => 'Светлое';

  @override
  String get selectSystem => 'Как в системе';

  @override
  String get selectDescription => 'Выбери оформление интерфейса';

  @override
  String get selectClose => 'Закрыть выбор оформления';

  @override
  String get segmentedLabel => 'Формат турнира';

  @override
  String get segmentDe => 'DE';

  @override
  String get segmentSe => 'SE';

  @override
  String get segmentRr => 'RR';

  @override
  String get stepperFormatLabel => 'Основная сетка';

  @override
  String get stepperScoreLabel => 'Счёт Алексея';

  @override
  String stepperDecrease(String label) {
    return 'Уменьшить $label';
  }

  @override
  String stepperIncrease(String label) {
    return 'Увеличить $label';
  }

  @override
  String stepperFt(int value) {
    return 'FT$value';
  }

  @override
  String stepperNumber(int value) {
    return '$value';
  }

  @override
  String scorePairLabel(String left, String right) {
    return 'Текущий счёт $left:$right';
  }

  @override
  String scoreFixedLabel(String value) {
    return 'Счёт победителя $value';
  }

  @override
  String get scoreSeparator => ':';

  @override
  String get scoreChoiceLabel => 'Выбор счёта';

  @override
  String get scoreChoiceLeft => '1 : 0';

  @override
  String get scoreChoiceRight => '0 : 1';

  @override
  String get metricWins => 'Победы в турнирах';

  @override
  String get metricTournaments => 'Турниры';

  @override
  String metricSummary(String label, String value) {
    return '$label: $value';
  }

  @override
  String get navigationSettings => 'Настройки';

  @override
  String get navigationLong => 'Настройки параметров отображения турнира';

  @override
  String get headerNew => 'Новый турнир';

  @override
  String get headerLong => 'Параметры пятничного турнира';

  @override
  String get headerEditing => 'Редактирование';

  @override
  String get headerProfile => 'Профиль';

  @override
  String get headerBack => 'Назад';

  @override
  String get headerSave => 'Сохранить';

  @override
  String get headerEdit => 'Редактировать';

  @override
  String get statusLive => 'В процессе';

  @override
  String get statusWin => 'Техническая победа';

  @override
  String get statusLoss => 'Техническое поражение';

  @override
  String get statusPoints => '2 очка';

  @override
  String get disclosureTitle => 'Управление турниром';

  @override
  String get disclosureBody =>
      'Дополнительные действия доступны в контексте турнира.';

  @override
  String get noticeInfo => 'Bracket Reset включён всегда.';

  @override
  String get noticeInfoLong =>
      'Bracket Reset включён всегда. Второй финал проводится при победе участника из нижней сетки.';

  @override
  String get noticeError => 'Не удалось сохранить. Повтори.';

  @override
  String get progressLoading => 'Загрузка';

  @override
  String get tableCaption => 'Основной этап · итоговые очки';

  @override
  String get tableParticipant => 'Участник';

  @override
  String get tablePoints => 'Очки';

  @override
  String get tableMatches => 'М';

  @override
  String get tableMatchesFull => 'Сыграно матчей';

  @override
  String get bracketReady => 'W1 · Раунд 1';

  @override
  String get bracketCurrent => 'W5 · Сейчас';

  @override
  String get bracketPending => 'W6 · Полуфинал';

  @override
  String get bracketUnknownFirst => 'Победитель W3';

  @override
  String get bracketUnknownSecond => 'Победитель W4';

  @override
  String get dialogTitle => 'Снять Алексея с турнира?';

  @override
  String get dialogContent =>
      'Прошлые результаты сохранятся. Вернуть игрока в турнир нельзя.';

  @override
  String get dialogConfirm => 'Снять участника';

  @override
  String get dialogCancel => 'Отмена';

  @override
  String get dialogOpen => 'Открыть диалог';

  @override
  String get qrDescription => 'Демонстрационный QR подключения участников';

  @override
  String get shareRole => 'Только просмотр';

  @override
  String get shareCopy => 'Скопировать ссылку';

  @override
  String get screenBrand => 'TOURNAMENT';

  @override
  String get screenBrandAccent => 'HUB.';

  @override
  String get screenBack => 'Назад';

  @override
  String get screenLoading => 'Загрузка';

  @override
  String get screenLoadingHero => 'Загружаем';

  @override
  String get screenLoadingAccent => 'данные.';

  @override
  String get screenLoadingNote => 'Это займёт немного времени.';

  @override
  String get screenLoadErrorHero => 'Не удалось';

  @override
  String get screenLoadErrorAccent => 'загрузить.';

  @override
  String get screenRetryNote => 'Попробуй ещё раз.';

  @override
  String get screenRetry => 'Повторить';

  @override
  String get screenBootPreparing => 'Подготавливаем\nприложение…';

  @override
  String get screenBootError => 'Не удалось запустить';

  @override
  String get screenBootRetrying => 'Пробуем снова…';

  @override
  String get screenHistory => 'История';

  @override
  String get screenProfile => 'Открыть профиль';

  @override
  String get screenYourNext => 'Твой\nследующий';

  @override
  String get screenTournamentAccent => 'турнир.';

  @override
  String get screenNoActive => 'Пока нет активного турнира';

  @override
  String get screenCreate => 'Создать турнир';

  @override
  String get screenTournaments => 'Турниры';

  @override
  String get screenNew => 'Новый';

  @override
  String get screenContinue => 'Продолжить';

  @override
  String get screenLive => 'В процессе';

  @override
  String get screenProfileTitle => 'Профиль';

  @override
  String get screenEditName => 'Изменить имя';

  @override
  String get screenWins => 'Победы в турнирах';

  @override
  String get screenTournamentCount => 'Турниры';

  @override
  String get screenMatches => 'Схватки';

  @override
  String get screenLastTournament => 'Последний турнир';

  @override
  String get screenSettings => 'Настройки';

  @override
  String get screenAbout => 'О приложении';

  @override
  String get screenContact => 'Связь';

  @override
  String get screenAhead => 'Всё ещё впереди';

  @override
  String get screenAheadNote => 'Здесь появятся результаты твоих турниров.';

  @override
  String get screenPlace => ' место';

  @override
  String get screenEditing => 'Редактирование';

  @override
  String get screenSaveName => 'Сохранить имя';

  @override
  String get screenName => 'Имя';

  @override
  String get screenSaveError => 'Не удалось сохранить';

  @override
  String get screenSettingsHero => 'Твой';

  @override
  String get screenSettingsAccent => 'интерфейс.';

  @override
  String get screenAppearance => 'Оформление';

  @override
  String get screenLanguage => 'Язык';

  @override
  String get screenDark => 'Тёмное';

  @override
  String get screenLight => 'Светлое';

  @override
  String get screenSystem => 'Как в системе';

  @override
  String get screenRussian => 'Русский';

  @override
  String get screenEnglish => 'English';

  @override
  String get screenClose => 'Закрыть';

  @override
  String get screenSettingsNote =>
      'Выбор демонстрационный: значения не сохраняются и не меняют остальные макеты.';

  @override
  String get screenSettingsTournamentNote =>
      'Формат и FT задаются при создании турнира, не здесь.';

  @override
  String get screenAboutProduct => 'Tournament';

  @override
  String get screenAboutAccent => 'HUB.';

  @override
  String get screenAboutMark => 'TH.';

  @override
  String get screenAboutDescription => 'Локальные турниры по Mortal Kombat 11.';

  @override
  String get screenRules => 'Базовые правила MK11';

  @override
  String get screenRulesCopy =>
      'DE: два поражения, Bracket Reset обязателен. SE: одно поражение, места 3–4 общие. RR: каждый с каждым, FT2 и очки 3/2/1/0.';

  @override
  String get screenIdea => 'Есть идея?';

  @override
  String get screenTell => 'Расскажи.';

  @override
  String get screenMessage => 'Сообщение';

  @override
  String get screenSend => 'Отправить';

  @override
  String get screenContactNote =>
      'Канал связи ещё не настроен. Отправка в макете недоступна.';

  @override
  String get screenYourTournaments => 'Твои\nтурниры.';

  @override
  String get screenHistoryEmpty => 'Первый турнир\nещё впереди.';

  @override
  String get screenHistoryEmptyNote => 'Завершённые турниры появятся здесь.';

  @override
  String get screenNewTournament => 'Новый турнир';

  @override
  String get screenTournamentName => 'Название';

  @override
  String get screenFormat => 'Формат';

  @override
  String get screenDe => 'DE';

  @override
  String get screenSe => 'SE';

  @override
  String get screenRr => 'RR';

  @override
  String get screenDeTitle => 'Double Elimination';

  @override
  String get screenSeTitle => 'Single Elimination';

  @override
  String get screenRrTitle => 'Round Robin';

  @override
  String get screenDeHint => 'Два поражения — вылет';

  @override
  String get screenSeHint => 'Одно поражение — вылет';

  @override
  String get screenRrHint => 'Каждый с каждым · FT2';

  @override
  String get screenMainBracket => 'Основная сетка';

  @override
  String get screenGrandFinal => 'Grand Final / Reset';

  @override
  String get screenFinal => 'Финал';

  @override
  String get screenDeNote => 'Bracket Reset включён всегда.';

  @override
  String get screenRrNote =>
      'FT2 фиксирован. Очки за результат: 3 / 2 / 1 / 0.';

  @override
  String get screenToRoster => 'К участникам';

  @override
  String get screenDecreaseFt => 'Уменьшить FT';

  @override
  String get screenIncreaseFt => 'Увеличить FT';

  @override
  String get screenParticipants => 'Участники';

  @override
  String get screenAddGuest => 'Добавить гостя';

  @override
  String get screenWhoPlays => 'Кто играет?';

  @override
  String get screenNoCharacters => 'Персонажи появятся после раздачи.';

  @override
  String get screenConnectParticipants => 'Подключить участников';

  @override
  String get screenDeal => 'Раздать персонажей';

  @override
  String get screenConnection => 'Подключение';

  @override
  String get screenJoin => 'Присоединиться';

  @override
  String get screenJoinAccent => 'к турниру.';

  @override
  String get screenScan => 'Отсканируй камерой телефона.';

  @override
  String get screenSpectators => 'Зрители';

  @override
  String get screenWatch => 'Смотреть';

  @override
  String get screenWatchAccent => 'турнир.';

  @override
  String get screenViewOnly => 'Только просмотр';

  @override
  String get screenSpectatorNote =>
      'Зрители видят матчи, сетку и результаты. Без управления турниром.';

  @override
  String get screenQrParticipantLabel => 'QR-код подключения участников';

  @override
  String get screenQrSpectatorLabel => 'QR-код просмотра турнира';

  @override
  String get screenCopySpectator => 'Скопировать ссылку зрителя';

  @override
  String get screenJoinTitle => 'Присоединиться\nк турниру.';

  @override
  String get screenWatchTitle => 'Смотреть\nтурнир.';

  @override
  String get screenCancel => 'Отмена';

  @override
  String get screenDelete => 'Удалить';

  @override
  String get screenRemoveGuestTitle => 'Удалить участника?';

  @override
  String get screenRemoveGuestNote => 'Он будет исключён из состава турнира.';

  @override
  String get screenTournament => 'Турнир';

  @override
  String screenWithdrawTitle(String name) {
    return 'Снять $name с турнира?';
  }

  @override
  String get screenWithdrawNote =>
      'Прошлые результаты сохранятся. Вернуть игрока в турнир нельзя.';

  @override
  String get screenWithdrawAction => 'Снять участника';

  @override
  String screenForfeitTitle(String name) {
    return 'Засчитать $name поражение?';
  }

  @override
  String get screenForfeitNote =>
      'Это поражение в текущем матче. Дальнейшее участие определяется правилами турнира.';

  @override
  String get screenForfeitAction => 'Засчитать поражение';

  @override
  String get screenNewGuest => 'Новый гость';

  @override
  String get screenAdd => 'Добавить';

  @override
  String get screenGuestBeforeStart => 'Можно добавить до старта турнира.';

  @override
  String get screenDistribution => 'Распределение';

  @override
  String get screenDealing => 'Распределение персонажей';

  @override
  String get screenWhoCharacter => 'Кто твой\nперсонаж?';

  @override
  String get screenNoRepeats => 'Раздаём без повторений.';

  @override
  String get screenRosterReady => 'Состав\nготов.';

  @override
  String get screenEachCharacter => 'Каждому — свой персонаж.';

  @override
  String get screenStartTournament => 'Начать турнир';

  @override
  String get screenSpectatorDistributionNote =>
      'Матчи, сетка и результаты. Без управления.';

  @override
  String get screenNext => 'Кто далее';

  @override
  String get screenBracket => 'Сетка турнира';

  @override
  String get screenEnterResult => 'Внести результат';

  @override
  String get screenManagement => 'Управление турниром';

  @override
  String get screenStandings => 'Таблица · 3 участника';

  @override
  String get screenMatchResults => 'Результаты матчей';

  @override
  String get screenHowPlaces => 'Как определяются места';

  @override
  String get screenTiebreakDetails =>
      'Итоговые места определяются результатами переигровки.';

  @override
  String get screenCurrentScore => 'Текущий счёт';

  @override
  String get screenResultCorrect => 'Исправить результат';

  @override
  String get screenStandingsResultsNote =>
      'Игровые и технические результаты основного этапа.';

  @override
  String get screenReplay => 'Переигровка';

  @override
  String get screenMainFinished => 'Основной этап завершён';

  @override
  String get screenReplayPlaces => 'Разыграем\nместа.';

  @override
  String get screenReplayNote => 'Трое участников набрали по 3 очка.';

  @override
  String get screenReplayRules => 'Правила переигровки';

  @override
  String get screenReplayRulesCopy =>
      'Участники с равными очками сыграют Mini Round Robin. FT2 и очки 3 / 2 / 1 / 0 сохраняются.';

  @override
  String get screenStartReplay => 'Начать переигровку';

  @override
  String get screenLockedReason =>
      'Следующий зависимый матч уже сыгран. Этот результат нельзя исправить.';
}
