// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'foundation_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class FoundationLocalizationsRu extends FoundationLocalizations {
  FoundationLocalizationsRu([String locale = 'ru']) : super(locale);

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
      'Inter — интерфейс и счёт. Roboto Condensed — крупные заголовки.';

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
}
