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
}
