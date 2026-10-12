import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'foundation_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FoundationLocalizations
/// returned by `FoundationLocalizations.of(context)`.
///
/// Applications need to include `FoundationLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/foundation_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FoundationLocalizations.localizationsDelegates,
///   supportedLocales: FoundationLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FoundationLocalizations.supportedLocales
/// property.
abstract class FoundationLocalizations {
  FoundationLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FoundationLocalizations of(BuildContext context) {
    return Localizations.of<FoundationLocalizations>(
      context,
      FoundationLocalizations,
    )!;
  }

  static const LocalizationsDelegate<FoundationLocalizations> delegate =
      _FoundationLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @colorsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цветовая схема'**
  String get colorsTitle;

  /// No description provided for @colorsDescription.
  ///
  /// In ru, this message translates to:
  /// **'Графитовая база, тёплое золото и семантические цвета состояний.'**
  String get colorsDescription;

  /// No description provided for @colorScalesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цветовые шкалы'**
  String get colorScalesTitle;

  /// No description provided for @colorScalesDescription.
  ///
  /// In ru, this message translates to:
  /// **'Константы от светлых к тёмным. Семантическая тема выбирает из них значения для UI.'**
  String get colorScalesDescription;

  /// No description provided for @borderStrong.
  ///
  /// In ru, this message translates to:
  /// **'Выраженная граница'**
  String get borderStrong;

  /// No description provided for @disabledSurface.
  ///
  /// In ru, this message translates to:
  /// **'Недоступная поверхность'**
  String get disabledSurface;

  /// No description provided for @disabledContent.
  ///
  /// In ru, this message translates to:
  /// **'Недоступный контент'**
  String get disabledContent;

  /// No description provided for @accentHovered.
  ///
  /// In ru, this message translates to:
  /// **'Акцент при наведении'**
  String get accentHovered;

  /// No description provided for @accentPressed.
  ///
  /// In ru, this message translates to:
  /// **'Нажатый акцент'**
  String get accentPressed;

  /// No description provided for @focus.
  ///
  /// In ru, this message translates to:
  /// **'Фокус'**
  String get focus;

  /// No description provided for @accentContainer.
  ///
  /// In ru, this message translates to:
  /// **'Акцентный контейнер'**
  String get accentContainer;

  /// No description provided for @onAccentContainer.
  ///
  /// In ru, this message translates to:
  /// **'Текст на акцентном контейнере'**
  String get onAccentContainer;

  /// No description provided for @successContainer.
  ///
  /// In ru, this message translates to:
  /// **'Контейнер успеха'**
  String get successContainer;

  /// No description provided for @onSuccessContainer.
  ///
  /// In ru, this message translates to:
  /// **'Текст на контейнере успеха'**
  String get onSuccessContainer;

  /// No description provided for @warningContainer.
  ///
  /// In ru, this message translates to:
  /// **'Контейнер предупреждения'**
  String get warningContainer;

  /// No description provided for @onWarningContainer.
  ///
  /// In ru, this message translates to:
  /// **'Текст на предупреждении'**
  String get onWarningContainer;

  /// No description provided for @dangerContainer.
  ///
  /// In ru, this message translates to:
  /// **'Контейнер ошибки'**
  String get dangerContainer;

  /// No description provided for @onDangerContainer.
  ///
  /// In ru, this message translates to:
  /// **'Текст на контейнере ошибки'**
  String get onDangerContainer;

  /// No description provided for @informationContainer.
  ///
  /// In ru, this message translates to:
  /// **'Информационный контейнер'**
  String get informationContainer;

  /// No description provided for @onInformationContainer.
  ///
  /// In ru, this message translates to:
  /// **'Текст на информационном контейнере'**
  String get onInformationContainer;

  /// No description provided for @typographyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Типографика'**
  String get typographyTitle;

  /// No description provided for @typographyDescription.
  ///
  /// In ru, this message translates to:
  /// **'Inter — интерфейс и счёт. Roboto Condensed — крупные заголовки.'**
  String get typographyDescription;

  /// No description provided for @background.
  ///
  /// In ru, this message translates to:
  /// **'Фон приложения'**
  String get background;

  /// No description provided for @surface.
  ///
  /// In ru, this message translates to:
  /// **'Поверхность'**
  String get surface;

  /// No description provided for @surfaceRaised.
  ///
  /// In ru, this message translates to:
  /// **'Поднятая поверхность'**
  String get surfaceRaised;

  /// No description provided for @border.
  ///
  /// In ru, this message translates to:
  /// **'Граница'**
  String get border;

  /// No description provided for @textPrimary.
  ///
  /// In ru, this message translates to:
  /// **'Основной текст'**
  String get textPrimary;

  /// No description provided for @textSecondary.
  ///
  /// In ru, this message translates to:
  /// **'Вторичный текст'**
  String get textSecondary;

  /// No description provided for @textMuted.
  ///
  /// In ru, this message translates to:
  /// **'Подпись'**
  String get textMuted;

  /// No description provided for @accent.
  ///
  /// In ru, this message translates to:
  /// **'Золотой акцент'**
  String get accent;

  /// No description provided for @onAccent.
  ///
  /// In ru, this message translates to:
  /// **'Текст на акценте'**
  String get onAccent;

  /// No description provided for @success.
  ///
  /// In ru, this message translates to:
  /// **'Успех'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In ru, this message translates to:
  /// **'Предупреждение'**
  String get warning;

  /// No description provided for @danger.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get danger;

  /// No description provided for @information.
  ///
  /// In ru, this message translates to:
  /// **'Информация'**
  String get information;

  /// No description provided for @display.
  ///
  /// In ru, this message translates to:
  /// **'Крупный заголовок'**
  String get display;

  /// No description provided for @heading.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок раздела'**
  String get heading;

  /// No description provided for @title.
  ///
  /// In ru, this message translates to:
  /// **'Название блока'**
  String get title;

  /// No description provided for @bodyLarge.
  ///
  /// In ru, this message translates to:
  /// **'Крупный основной текст'**
  String get bodyLarge;

  /// No description provided for @body.
  ///
  /// In ru, this message translates to:
  /// **'Основной текст'**
  String get body;

  /// No description provided for @label.
  ///
  /// In ru, this message translates to:
  /// **'Метка'**
  String get label;

  /// No description provided for @caption.
  ///
  /// In ru, this message translates to:
  /// **'Подпись'**
  String get caption;

  /// No description provided for @score.
  ///
  /// In ru, this message translates to:
  /// **'Счёт'**
  String get score;

  /// No description provided for @headlineSample.
  ///
  /// In ru, this message translates to:
  /// **'Турнир начинается'**
  String get headlineSample;

  /// No description provided for @bodySample.
  ///
  /// In ru, this message translates to:
  /// **'Победитель проходит дальше. Результат матча сохраняется в турнире.'**
  String get bodySample;

  /// No description provided for @compactSample.
  ///
  /// In ru, this message translates to:
  /// **'Раунд 2 · Матч 4'**
  String get compactSample;

  /// No description provided for @scoreSample.
  ///
  /// In ru, this message translates to:
  /// **'02 : 01'**
  String get scoreSample;

  /// No description provided for @fontDetails.
  ///
  /// In ru, this message translates to:
  /// **'{family} · {size} px · {weight}'**
  String fontDetails(String family, int size, int weight);
}

class _FoundationLocalizationsDelegate
    extends LocalizationsDelegate<FoundationLocalizations> {
  const _FoundationLocalizationsDelegate();

  @override
  Future<FoundationLocalizations> load(Locale locale) {
    return SynchronousFuture<FoundationLocalizations>(
      lookupFoundationLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_FoundationLocalizationsDelegate old) => false;
}

FoundationLocalizations lookupFoundationLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return FoundationLocalizationsRu();
  }

  throw FlutterError(
    'FoundationLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
