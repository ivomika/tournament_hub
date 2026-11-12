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

  /// No description provided for @screenRegistrationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get screenRegistrationTitle;

  /// No description provided for @screenRegistrationIntro.
  ///
  /// In ru, this message translates to:
  /// **'Как к вам обращаться?'**
  String get screenRegistrationIntro;

  /// No description provided for @screenRegistrationContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get screenRegistrationContinue;

  /// No description provided for @screenRegistrationSaving.
  ///
  /// In ru, this message translates to:
  /// **'Сохраняем…'**
  String get screenRegistrationSaving;

  /// No description provided for @screenRegistrationNameRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get screenRegistrationNameRequired;

  /// No description provided for @screenRegistrationSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить профиль. Попробуйте ещё раз.'**
  String get screenRegistrationSaveError;

  /// No description provided for @screenBootPreparingProfile.
  ///
  /// In ru, this message translates to:
  /// **'Загружаем профиль…'**
  String get screenBootPreparingProfile;

  /// No description provided for @screenBootProfileUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить профиль. Попробуйте ещё раз.'**
  String get screenBootProfileUnavailable;

  /// No description provided for @placeholderGreeting.
  ///
  /// In ru, this message translates to:
  /// **'Hello World!'**
  String get placeholderGreeting;

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
  /// **'Inter — интерфейс. Roboto Condensed — крупные заголовки и счёт.'**
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

  /// No description provided for @surfaceSample.
  ///
  /// In ru, this message translates to:
  /// **'Поверхность'**
  String get surfaceSample;

  /// No description provided for @raisedSurfaceSample.
  ///
  /// In ru, this message translates to:
  /// **'Приподнятая область'**
  String get raisedSurfaceSample;

  /// No description provided for @surfaceLongSample.
  ///
  /// In ru, this message translates to:
  /// **'Длинное содержимое поверхности занимает несколько строк и сохраняет внутренние отступы.'**
  String get surfaceLongSample;

  /// No description provided for @buttonContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get buttonContinue;

  /// No description provided for @buttonCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get buttonCancel;

  /// No description provided for @buttonRemove.
  ///
  /// In ru, this message translates to:
  /// **'Снять участника'**
  String get buttonRemove;

  /// No description provided for @buttonBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get buttonBack;

  /// No description provided for @buttonSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get buttonSave;

  /// No description provided for @buttonLong.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить создание турнира с выбранными участниками'**
  String get buttonLong;

  /// No description provided for @rosterDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get rosterDelete;

  /// No description provided for @participantDescription.
  ///
  /// In ru, this message translates to:
  /// **'Участник турнира'**
  String get participantDescription;

  /// No description provided for @rosterRemove.
  ///
  /// In ru, this message translates to:
  /// **'Удалить участника {name}'**
  String rosterRemove(String name);

  /// No description provided for @characterIce.
  ///
  /// In ru, this message translates to:
  /// **'Персонаж · лёд'**
  String get characterIce;

  /// No description provided for @characterFan.
  ///
  /// In ru, this message translates to:
  /// **'Персонаж · веер'**
  String get characterFan;

  /// No description provided for @characterStorm.
  ///
  /// In ru, this message translates to:
  /// **'Персонаж · шторм'**
  String get characterStorm;

  /// No description provided for @typeSource0.
  ///
  /// In ru, this message translates to:
  /// **'TOURNAMENT HUB.'**
  String get typeSource0;

  /// No description provided for @typeSource1.
  ///
  /// In ru, this message translates to:
  /// **'Твой следующий турнир'**
  String get typeSource1;

  /// No description provided for @typeSource2.
  ///
  /// In ru, this message translates to:
  /// **'Пятничный турнир'**
  String get typeSource2;

  /// No description provided for @typeSource3.
  ///
  /// In ru, this message translates to:
  /// **'Основной текст · Aa Бб 012345'**
  String get typeSource3;

  /// No description provided for @typeSource4.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить турнир'**
  String get typeSource4;

  /// No description provided for @typeSource5.
  ///
  /// In ru, this message translates to:
  /// **'Метаданные и пояснения · FT2'**
  String get typeSource5;

  /// No description provided for @typeSource6.
  ///
  /// In ru, this message translates to:
  /// **'Новый турнир'**
  String get typeSource6;

  /// No description provided for @typeSource7.
  ///
  /// In ru, this message translates to:
  /// **'Новый турнир'**
  String get typeSource7;

  /// No description provided for @foundationMetricValue.
  ///
  /// In ru, this message translates to:
  /// **'{value}'**
  String foundationMetricValue(num value);

  /// No description provided for @elevationSource.
  ///
  /// In ru, this message translates to:
  /// **'floating · 0 8 24 / #07080b80'**
  String get elevationSource;

  /// No description provided for @elevationFloating.
  ///
  /// In ru, this message translates to:
  /// **'Плавающая поверхность'**
  String get elevationFloating;

  /// No description provided for @elevationSheet.
  ///
  /// In ru, this message translates to:
  /// **'Нижняя панель'**
  String get elevationSheet;

  /// No description provided for @elevationDialog.
  ///
  /// In ru, this message translates to:
  /// **'Диалог'**
  String get elevationDialog;

  /// No description provided for @fieldNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get fieldNameLabel;

  /// No description provided for @fieldMessageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение'**
  String get fieldMessageLabel;

  /// No description provided for @fieldNameSample.
  ///
  /// In ru, this message translates to:
  /// **'Пятничный турнир'**
  String get fieldNameSample;

  /// No description provided for @fieldMessageSample.
  ///
  /// In ru, this message translates to:
  /// **'Хочу предложить улучшение…'**
  String get fieldMessageSample;

  /// No description provided for @fieldErrorSample.
  ///
  /// In ru, this message translates to:
  /// **'Проверь значение'**
  String get fieldErrorSample;

  /// No description provided for @selectLabel.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get selectLabel;

  /// No description provided for @selectDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмное'**
  String get selectDark;

  /// No description provided for @selectLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлое'**
  String get selectLight;

  /// No description provided for @selectSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get selectSystem;

  /// No description provided for @selectDescription.
  ///
  /// In ru, this message translates to:
  /// **'Выбери оформление интерфейса'**
  String get selectDescription;

  /// No description provided for @selectClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть выбор оформления'**
  String get selectClose;

  /// No description provided for @segmentedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Формат турнира'**
  String get segmentedLabel;

  /// No description provided for @segmentDe.
  ///
  /// In ru, this message translates to:
  /// **'DE'**
  String get segmentDe;

  /// No description provided for @segmentSe.
  ///
  /// In ru, this message translates to:
  /// **'SE'**
  String get segmentSe;

  /// No description provided for @segmentRr.
  ///
  /// In ru, this message translates to:
  /// **'RR'**
  String get segmentRr;

  /// No description provided for @stepperFormatLabel.
  ///
  /// In ru, this message translates to:
  /// **'Основная сетка'**
  String get stepperFormatLabel;

  /// No description provided for @stepperScoreLabel.
  ///
  /// In ru, this message translates to:
  /// **'Счёт Алексея'**
  String get stepperScoreLabel;

  /// No description provided for @stepperDecrease.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить {label}'**
  String stepperDecrease(String label);

  /// No description provided for @stepperIncrease.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить {label}'**
  String stepperIncrease(String label);

  /// No description provided for @stepperFt.
  ///
  /// In ru, this message translates to:
  /// **'FT{value}'**
  String stepperFt(int value);

  /// No description provided for @stepperNumber.
  ///
  /// In ru, this message translates to:
  /// **'{value}'**
  String stepperNumber(int value);

  /// No description provided for @scorePairLabel.
  ///
  /// In ru, this message translates to:
  /// **'Текущий счёт {left}:{right}'**
  String scorePairLabel(String left, String right);

  /// No description provided for @scoreFixedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Счёт победителя {value}'**
  String scoreFixedLabel(String value);

  /// No description provided for @scoreSeparator.
  ///
  /// In ru, this message translates to:
  /// **':'**
  String get scoreSeparator;

  /// No description provided for @scoreChoiceLabel.
  ///
  /// In ru, this message translates to:
  /// **'Выбор счёта'**
  String get scoreChoiceLabel;

  /// No description provided for @scoreChoiceLeft.
  ///
  /// In ru, this message translates to:
  /// **'1 : 0'**
  String get scoreChoiceLeft;

  /// No description provided for @scoreChoiceRight.
  ///
  /// In ru, this message translates to:
  /// **'0 : 1'**
  String get scoreChoiceRight;

  /// No description provided for @metricWins.
  ///
  /// In ru, this message translates to:
  /// **'Победы в турнирах'**
  String get metricWins;

  /// No description provided for @metricTournaments.
  ///
  /// In ru, this message translates to:
  /// **'Турниры'**
  String get metricTournaments;

  /// No description provided for @metricSummary.
  ///
  /// In ru, this message translates to:
  /// **'{label}: {value}'**
  String metricSummary(String label, String value);

  /// No description provided for @navigationSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navigationSettings;

  /// No description provided for @navigationLong.
  ///
  /// In ru, this message translates to:
  /// **'Настройки параметров отображения турнира'**
  String get navigationLong;

  /// No description provided for @headerNew.
  ///
  /// In ru, this message translates to:
  /// **'Новый турнир'**
  String get headerNew;

  /// No description provided for @headerLong.
  ///
  /// In ru, this message translates to:
  /// **'Параметры пятничного турнира'**
  String get headerLong;

  /// No description provided for @headerEditing.
  ///
  /// In ru, this message translates to:
  /// **'Редактирование'**
  String get headerEditing;

  /// No description provided for @headerProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get headerProfile;

  /// No description provided for @headerBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get headerBack;

  /// No description provided for @headerSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get headerSave;

  /// No description provided for @headerEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get headerEdit;

  /// No description provided for @statusLive.
  ///
  /// In ru, this message translates to:
  /// **'В процессе'**
  String get statusLive;

  /// No description provided for @statusWin.
  ///
  /// In ru, this message translates to:
  /// **'Техническая победа'**
  String get statusWin;

  /// No description provided for @statusLoss.
  ///
  /// In ru, this message translates to:
  /// **'Техническое поражение'**
  String get statusLoss;

  /// No description provided for @statusPoints.
  ///
  /// In ru, this message translates to:
  /// **'2 очка'**
  String get statusPoints;

  /// No description provided for @disclosureTitle.
  ///
  /// In ru, this message translates to:
  /// **'Управление турниром'**
  String get disclosureTitle;

  /// No description provided for @disclosureBody.
  ///
  /// In ru, this message translates to:
  /// **'Дополнительные действия доступны в контексте турнира.'**
  String get disclosureBody;

  /// No description provided for @noticeInfo.
  ///
  /// In ru, this message translates to:
  /// **'Bracket Reset включён всегда.'**
  String get noticeInfo;

  /// No description provided for @noticeInfoLong.
  ///
  /// In ru, this message translates to:
  /// **'Bracket Reset включён всегда. Второй финал проводится при победе участника из нижней сетки.'**
  String get noticeInfoLong;

  /// No description provided for @noticeError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Повтори.'**
  String get noticeError;

  /// No description provided for @progressLoading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка'**
  String get progressLoading;

  /// No description provided for @tableCaption.
  ///
  /// In ru, this message translates to:
  /// **'Основной этап · итоговые очки'**
  String get tableCaption;

  /// No description provided for @tableParticipant.
  ///
  /// In ru, this message translates to:
  /// **'Участник'**
  String get tableParticipant;

  /// No description provided for @tablePoints.
  ///
  /// In ru, this message translates to:
  /// **'Очки'**
  String get tablePoints;

  /// No description provided for @tableMatches.
  ///
  /// In ru, this message translates to:
  /// **'М'**
  String get tableMatches;

  /// No description provided for @tableMatchesFull.
  ///
  /// In ru, this message translates to:
  /// **'Сыграно матчей'**
  String get tableMatchesFull;

  /// No description provided for @bracketReady.
  ///
  /// In ru, this message translates to:
  /// **'W1 · Раунд 1'**
  String get bracketReady;

  /// No description provided for @bracketCurrent.
  ///
  /// In ru, this message translates to:
  /// **'W5 · Сейчас'**
  String get bracketCurrent;

  /// No description provided for @bracketPending.
  ///
  /// In ru, this message translates to:
  /// **'W6 · Полуфинал'**
  String get bracketPending;

  /// No description provided for @bracketUnknownFirst.
  ///
  /// In ru, this message translates to:
  /// **'Победитель W3'**
  String get bracketUnknownFirst;

  /// No description provided for @bracketUnknownSecond.
  ///
  /// In ru, this message translates to:
  /// **'Победитель W4'**
  String get bracketUnknownSecond;

  /// No description provided for @dialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Снять Алексея с турнира?'**
  String get dialogTitle;

  /// No description provided for @dialogContent.
  ///
  /// In ru, this message translates to:
  /// **'Прошлые результаты сохранятся. Вернуть игрока в турнир нельзя.'**
  String get dialogContent;

  /// No description provided for @dialogConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Снять участника'**
  String get dialogConfirm;

  /// No description provided for @dialogCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get dialogCancel;

  /// No description provided for @dialogOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть диалог'**
  String get dialogOpen;

  /// No description provided for @qrDescription.
  ///
  /// In ru, this message translates to:
  /// **'Демонстрационный QR подключения участников'**
  String get qrDescription;

  /// No description provided for @shareRole.
  ///
  /// In ru, this message translates to:
  /// **'Только просмотр'**
  String get shareRole;

  /// No description provided for @shareCopy.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать ссылку'**
  String get shareCopy;

  /// No description provided for @screenBrand.
  ///
  /// In ru, this message translates to:
  /// **'TOURNAMENT'**
  String get screenBrand;

  /// No description provided for @screenBrandAccent.
  ///
  /// In ru, this message translates to:
  /// **'HUB.'**
  String get screenBrandAccent;

  /// No description provided for @screenBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get screenBack;

  /// No description provided for @screenLoading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка'**
  String get screenLoading;

  /// No description provided for @screenLoadingHero.
  ///
  /// In ru, this message translates to:
  /// **'Загружаем'**
  String get screenLoadingHero;

  /// No description provided for @screenLoadingAccent.
  ///
  /// In ru, this message translates to:
  /// **'данные.'**
  String get screenLoadingAccent;

  /// No description provided for @screenLoadingNote.
  ///
  /// In ru, this message translates to:
  /// **'Это займёт немного времени.'**
  String get screenLoadingNote;

  /// No description provided for @screenLoadErrorHero.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось'**
  String get screenLoadErrorHero;

  /// No description provided for @screenLoadErrorAccent.
  ///
  /// In ru, this message translates to:
  /// **'загрузить.'**
  String get screenLoadErrorAccent;

  /// No description provided for @screenRetryNote.
  ///
  /// In ru, this message translates to:
  /// **'Попробуй ещё раз.'**
  String get screenRetryNote;

  /// No description provided for @screenRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get screenRetry;

  /// No description provided for @screenBootPreparing.
  ///
  /// In ru, this message translates to:
  /// **'Подготавливаем\nприложение…'**
  String get screenBootPreparing;

  /// No description provided for @screenBootPreparingNavigation.
  ///
  /// In ru, this message translates to:
  /// **'Подготавливаем экраны…'**
  String get screenBootPreparingNavigation;

  /// No description provided for @screenBootPreparingComponent.
  ///
  /// In ru, this message translates to:
  /// **'Подготавливаем компонент…'**
  String get screenBootPreparingComponent;

  /// No description provided for @screenBootError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось запустить'**
  String get screenBootError;

  /// No description provided for @screenBootDependencyUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Сервис недоступен. Попробуйте ещё раз.'**
  String get screenBootDependencyUnavailable;

  /// No description provided for @screenBootTimedOut.
  ///
  /// In ru, this message translates to:
  /// **'Сервис не ответил. Повторите попытку.'**
  String get screenBootTimedOut;

  /// No description provided for @screenBootIncompatibleVersion.
  ///
  /// In ru, this message translates to:
  /// **'Обновите приложение для подключения к сервису.'**
  String get screenBootIncompatibleVersion;

  /// No description provided for @screenBootRestartRequired.
  ///
  /// In ru, this message translates to:
  /// **'Для продолжения перезапустите приложение.'**
  String get screenBootRestartRequired;

  /// No description provided for @screenBootCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Запуск отменён.'**
  String get screenBootCancelled;

  /// No description provided for @screenBootRetrying.
  ///
  /// In ru, this message translates to:
  /// **'Пробуем снова…'**
  String get screenBootRetrying;

  /// No description provided for @screenHistory.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get screenHistory;

  /// No description provided for @screenProfile.
  ///
  /// In ru, this message translates to:
  /// **'Открыть профиль'**
  String get screenProfile;

  /// No description provided for @screenYourNext.
  ///
  /// In ru, this message translates to:
  /// **'Твой\nследующий'**
  String get screenYourNext;

  /// No description provided for @screenTournamentAccent.
  ///
  /// In ru, this message translates to:
  /// **'турнир.'**
  String get screenTournamentAccent;

  /// No description provided for @screenNoActive.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет активного турнира'**
  String get screenNoActive;

  /// No description provided for @screenCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать турнир'**
  String get screenCreate;

  /// No description provided for @screenTournaments.
  ///
  /// In ru, this message translates to:
  /// **'Турниры'**
  String get screenTournaments;

  /// No description provided for @screenNew.
  ///
  /// In ru, this message translates to:
  /// **'Новый'**
  String get screenNew;

  /// No description provided for @screenContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get screenContinue;

  /// No description provided for @screenLive.
  ///
  /// In ru, this message translates to:
  /// **'В процессе'**
  String get screenLive;

  /// No description provided for @screenProfileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get screenProfileTitle;

  /// No description provided for @screenEditName.
  ///
  /// In ru, this message translates to:
  /// **'Изменить имя'**
  String get screenEditName;

  /// No description provided for @screenWins.
  ///
  /// In ru, this message translates to:
  /// **'Победы в турнирах'**
  String get screenWins;

  /// No description provided for @screenTournamentCount.
  ///
  /// In ru, this message translates to:
  /// **'Турниры'**
  String get screenTournamentCount;

  /// No description provided for @screenMatches.
  ///
  /// In ru, this message translates to:
  /// **'Схватки'**
  String get screenMatches;

  /// No description provided for @screenLastTournament.
  ///
  /// In ru, this message translates to:
  /// **'Последний турнир'**
  String get screenLastTournament;

  /// No description provided for @screenSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get screenSettings;

  /// No description provided for @screenAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get screenAbout;

  /// No description provided for @screenContact.
  ///
  /// In ru, this message translates to:
  /// **'Связь'**
  String get screenContact;

  /// No description provided for @screenAhead.
  ///
  /// In ru, this message translates to:
  /// **'Всё ещё впереди'**
  String get screenAhead;

  /// No description provided for @screenAheadNote.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся результаты твоих турниров.'**
  String get screenAheadNote;

  /// No description provided for @screenPlace.
  ///
  /// In ru, this message translates to:
  /// **' место'**
  String get screenPlace;

  /// No description provided for @screenEditing.
  ///
  /// In ru, this message translates to:
  /// **'Редактирование'**
  String get screenEditing;

  /// No description provided for @screenSaveName.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить имя'**
  String get screenSaveName;

  /// No description provided for @screenName.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get screenName;

  /// No description provided for @screenSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить'**
  String get screenSaveError;

  /// No description provided for @screenSettingsHero.
  ///
  /// In ru, this message translates to:
  /// **'Твой'**
  String get screenSettingsHero;

  /// No description provided for @screenSettingsAccent.
  ///
  /// In ru, this message translates to:
  /// **'интерфейс.'**
  String get screenSettingsAccent;

  /// No description provided for @screenAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get screenAppearance;

  /// No description provided for @screenLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get screenLanguage;

  /// No description provided for @screenDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмное'**
  String get screenDark;

  /// No description provided for @screenLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлое'**
  String get screenLight;

  /// No description provided for @screenSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get screenSystem;

  /// No description provided for @screenRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get screenRussian;

  /// No description provided for @screenEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get screenEnglish;

  /// No description provided for @screenClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get screenClose;

  /// No description provided for @screenSettingsNote.
  ///
  /// In ru, this message translates to:
  /// **'Выбор демонстрационный: значения не сохраняются и не меняют остальные макеты.'**
  String get screenSettingsNote;

  /// No description provided for @screenSettingsTournamentNote.
  ///
  /// In ru, this message translates to:
  /// **'Формат и FT задаются при создании турнира, не здесь.'**
  String get screenSettingsTournamentNote;

  /// No description provided for @screenAboutProduct.
  ///
  /// In ru, this message translates to:
  /// **'Tournament'**
  String get screenAboutProduct;

  /// No description provided for @screenAboutAccent.
  ///
  /// In ru, this message translates to:
  /// **'HUB.'**
  String get screenAboutAccent;

  /// No description provided for @screenAboutMark.
  ///
  /// In ru, this message translates to:
  /// **'TH.'**
  String get screenAboutMark;

  /// No description provided for @screenAboutDescription.
  ///
  /// In ru, this message translates to:
  /// **'Локальные турниры по Mortal Kombat 11.'**
  String get screenAboutDescription;

  /// No description provided for @screenRules.
  ///
  /// In ru, this message translates to:
  /// **'Базовые правила MK11'**
  String get screenRules;

  /// No description provided for @screenRulesCopy.
  ///
  /// In ru, this message translates to:
  /// **'DE: два поражения, Bracket Reset обязателен. SE: одно поражение, места 3–4 общие. RR: каждый с каждым, FT2 и очки 3/2/1/0.'**
  String get screenRulesCopy;

  /// No description provided for @screenIdea.
  ///
  /// In ru, this message translates to:
  /// **'Есть идея?'**
  String get screenIdea;

  /// No description provided for @screenTell.
  ///
  /// In ru, this message translates to:
  /// **'Расскажи.'**
  String get screenTell;

  /// No description provided for @screenMessage.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение'**
  String get screenMessage;

  /// No description provided for @screenSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get screenSend;

  /// No description provided for @screenContactNote.
  ///
  /// In ru, this message translates to:
  /// **'Канал связи ещё не настроен. Отправка в макете недоступна.'**
  String get screenContactNote;

  /// No description provided for @screenYourTournaments.
  ///
  /// In ru, this message translates to:
  /// **'Твои\nтурниры.'**
  String get screenYourTournaments;

  /// No description provided for @screenHistoryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Первый турнир\nещё впереди.'**
  String get screenHistoryEmpty;

  /// No description provided for @screenHistoryEmptyNote.
  ///
  /// In ru, this message translates to:
  /// **'Завершённые турниры появятся здесь.'**
  String get screenHistoryEmptyNote;

  /// No description provided for @screenNewTournament.
  ///
  /// In ru, this message translates to:
  /// **'Новый турнир'**
  String get screenNewTournament;

  /// No description provided for @screenTournamentName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get screenTournamentName;

  /// No description provided for @screenFormat.
  ///
  /// In ru, this message translates to:
  /// **'Формат'**
  String get screenFormat;

  /// No description provided for @screenDe.
  ///
  /// In ru, this message translates to:
  /// **'DE'**
  String get screenDe;

  /// No description provided for @screenSe.
  ///
  /// In ru, this message translates to:
  /// **'SE'**
  String get screenSe;

  /// No description provided for @screenRr.
  ///
  /// In ru, this message translates to:
  /// **'RR'**
  String get screenRr;

  /// No description provided for @screenDeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Double Elimination'**
  String get screenDeTitle;

  /// No description provided for @screenSeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Single Elimination'**
  String get screenSeTitle;

  /// No description provided for @screenRrTitle.
  ///
  /// In ru, this message translates to:
  /// **'Round Robin'**
  String get screenRrTitle;

  /// No description provided for @screenDeHint.
  ///
  /// In ru, this message translates to:
  /// **'Два поражения — вылет'**
  String get screenDeHint;

  /// No description provided for @screenSeHint.
  ///
  /// In ru, this message translates to:
  /// **'Одно поражение — вылет'**
  String get screenSeHint;

  /// No description provided for @screenRrHint.
  ///
  /// In ru, this message translates to:
  /// **'Каждый с каждым · FT2'**
  String get screenRrHint;

  /// No description provided for @screenMainBracket.
  ///
  /// In ru, this message translates to:
  /// **'Основная сетка'**
  String get screenMainBracket;

  /// No description provided for @screenGrandFinal.
  ///
  /// In ru, this message translates to:
  /// **'Grand Final / Reset'**
  String get screenGrandFinal;

  /// No description provided for @screenFinal.
  ///
  /// In ru, this message translates to:
  /// **'Финал'**
  String get screenFinal;

  /// No description provided for @screenDeNote.
  ///
  /// In ru, this message translates to:
  /// **'Bracket Reset включён всегда.'**
  String get screenDeNote;

  /// No description provided for @screenRrNote.
  ///
  /// In ru, this message translates to:
  /// **'FT2 фиксирован. Очки за результат: 3 / 2 / 1 / 0.'**
  String get screenRrNote;

  /// No description provided for @screenToRoster.
  ///
  /// In ru, this message translates to:
  /// **'К участникам'**
  String get screenToRoster;

  /// No description provided for @screenDecreaseFt.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить FT'**
  String get screenDecreaseFt;

  /// No description provided for @screenIncreaseFt.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить FT'**
  String get screenIncreaseFt;

  /// No description provided for @screenParticipants.
  ///
  /// In ru, this message translates to:
  /// **'Участники'**
  String get screenParticipants;

  /// No description provided for @screenAddGuest.
  ///
  /// In ru, this message translates to:
  /// **'Добавить гостя'**
  String get screenAddGuest;

  /// No description provided for @screenWhoPlays.
  ///
  /// In ru, this message translates to:
  /// **'Кто играет?'**
  String get screenWhoPlays;

  /// No description provided for @screenNoCharacters.
  ///
  /// In ru, this message translates to:
  /// **'Персонажи появятся после раздачи.'**
  String get screenNoCharacters;

  /// No description provided for @screenConnectParticipants.
  ///
  /// In ru, this message translates to:
  /// **'Подключить участников'**
  String get screenConnectParticipants;

  /// No description provided for @screenDeal.
  ///
  /// In ru, this message translates to:
  /// **'Раздать персонажей'**
  String get screenDeal;

  /// No description provided for @screenConnection.
  ///
  /// In ru, this message translates to:
  /// **'Подключение'**
  String get screenConnection;

  /// No description provided for @screenJoin.
  ///
  /// In ru, this message translates to:
  /// **'Присоединиться'**
  String get screenJoin;

  /// No description provided for @screenJoinAccent.
  ///
  /// In ru, this message translates to:
  /// **'к турниру.'**
  String get screenJoinAccent;

  /// No description provided for @screenScan.
  ///
  /// In ru, this message translates to:
  /// **'Отсканируй камерой телефона.'**
  String get screenScan;

  /// No description provided for @screenSpectators.
  ///
  /// In ru, this message translates to:
  /// **'Зрители'**
  String get screenSpectators;

  /// No description provided for @screenWatch.
  ///
  /// In ru, this message translates to:
  /// **'Смотреть'**
  String get screenWatch;

  /// No description provided for @screenWatchAccent.
  ///
  /// In ru, this message translates to:
  /// **'турнир.'**
  String get screenWatchAccent;

  /// No description provided for @screenViewOnly.
  ///
  /// In ru, this message translates to:
  /// **'Только просмотр'**
  String get screenViewOnly;

  /// No description provided for @screenSpectatorNote.
  ///
  /// In ru, this message translates to:
  /// **'Зрители видят матчи, сетку и результаты. Без управления турниром.'**
  String get screenSpectatorNote;

  /// No description provided for @screenQrParticipantLabel.
  ///
  /// In ru, this message translates to:
  /// **'QR-код подключения участников'**
  String get screenQrParticipantLabel;

  /// No description provided for @screenQrSpectatorLabel.
  ///
  /// In ru, this message translates to:
  /// **'QR-код просмотра турнира'**
  String get screenQrSpectatorLabel;

  /// No description provided for @screenCopySpectator.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать ссылку зрителя'**
  String get screenCopySpectator;

  /// No description provided for @screenJoinTitle.
  ///
  /// In ru, this message translates to:
  /// **'Присоединиться\nк турниру.'**
  String get screenJoinTitle;

  /// No description provided for @screenWatchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Смотреть\nтурнир.'**
  String get screenWatchTitle;

  /// No description provided for @screenCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get screenCancel;

  /// No description provided for @screenDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get screenDelete;

  /// No description provided for @screenRemoveGuestTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить участника?'**
  String get screenRemoveGuestTitle;

  /// No description provided for @screenRemoveGuestNote.
  ///
  /// In ru, this message translates to:
  /// **'Он будет исключён из состава турнира.'**
  String get screenRemoveGuestNote;

  /// No description provided for @screenTournament.
  ///
  /// In ru, this message translates to:
  /// **'Турнир'**
  String get screenTournament;

  /// No description provided for @screenWithdrawTitle.
  ///
  /// In ru, this message translates to:
  /// **'Снять {name} с турнира?'**
  String screenWithdrawTitle(String name);

  /// No description provided for @screenWithdrawNote.
  ///
  /// In ru, this message translates to:
  /// **'Прошлые результаты сохранятся. Вернуть игрока в турнир нельзя.'**
  String get screenWithdrawNote;

  /// No description provided for @screenWithdrawAction.
  ///
  /// In ru, this message translates to:
  /// **'Снять участника'**
  String get screenWithdrawAction;

  /// No description provided for @screenForfeitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Засчитать {name} поражение?'**
  String screenForfeitTitle(String name);

  /// No description provided for @screenForfeitNote.
  ///
  /// In ru, this message translates to:
  /// **'Это поражение в текущем матче. Дальнейшее участие определяется правилами турнира.'**
  String get screenForfeitNote;

  /// No description provided for @screenForfeitAction.
  ///
  /// In ru, this message translates to:
  /// **'Засчитать поражение'**
  String get screenForfeitAction;

  /// No description provided for @screenNewGuest.
  ///
  /// In ru, this message translates to:
  /// **'Новый гость'**
  String get screenNewGuest;

  /// No description provided for @screenAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get screenAdd;

  /// No description provided for @screenGuestBeforeStart.
  ///
  /// In ru, this message translates to:
  /// **'Можно добавить до старта турнира.'**
  String get screenGuestBeforeStart;

  /// No description provided for @screenDistribution.
  ///
  /// In ru, this message translates to:
  /// **'Распределение'**
  String get screenDistribution;

  /// No description provided for @screenDealing.
  ///
  /// In ru, this message translates to:
  /// **'Распределение персонажей'**
  String get screenDealing;

  /// No description provided for @screenWhoCharacter.
  ///
  /// In ru, this message translates to:
  /// **'Кто твой\nперсонаж?'**
  String get screenWhoCharacter;

  /// No description provided for @screenNoRepeats.
  ///
  /// In ru, this message translates to:
  /// **'Раздаём без повторений.'**
  String get screenNoRepeats;

  /// No description provided for @screenRosterReady.
  ///
  /// In ru, this message translates to:
  /// **'Состав\nготов.'**
  String get screenRosterReady;

  /// No description provided for @screenEachCharacter.
  ///
  /// In ru, this message translates to:
  /// **'Каждому — свой персонаж.'**
  String get screenEachCharacter;

  /// No description provided for @screenStartTournament.
  ///
  /// In ru, this message translates to:
  /// **'Начать турнир'**
  String get screenStartTournament;

  /// No description provided for @screenSpectatorDistributionNote.
  ///
  /// In ru, this message translates to:
  /// **'Матчи, сетка и результаты. Без управления.'**
  String get screenSpectatorDistributionNote;

  /// No description provided for @screenNext.
  ///
  /// In ru, this message translates to:
  /// **'Кто далее'**
  String get screenNext;

  /// No description provided for @screenBracket.
  ///
  /// In ru, this message translates to:
  /// **'Сетка турнира'**
  String get screenBracket;

  /// No description provided for @screenEnterResult.
  ///
  /// In ru, this message translates to:
  /// **'Внести результат'**
  String get screenEnterResult;

  /// No description provided for @screenManagement.
  ///
  /// In ru, this message translates to:
  /// **'Управление турниром'**
  String get screenManagement;

  /// No description provided for @screenStandings.
  ///
  /// In ru, this message translates to:
  /// **'Таблица · 3 участника'**
  String get screenStandings;

  /// No description provided for @screenMatchResults.
  ///
  /// In ru, this message translates to:
  /// **'Результаты матчей'**
  String get screenMatchResults;

  /// No description provided for @screenHowPlaces.
  ///
  /// In ru, this message translates to:
  /// **'Как определяются места'**
  String get screenHowPlaces;

  /// No description provided for @screenTiebreakDetails.
  ///
  /// In ru, this message translates to:
  /// **'Итоговые места определяются результатами переигровки.'**
  String get screenTiebreakDetails;

  /// No description provided for @screenCurrentScore.
  ///
  /// In ru, this message translates to:
  /// **'Текущий счёт'**
  String get screenCurrentScore;

  /// No description provided for @screenResultCorrect.
  ///
  /// In ru, this message translates to:
  /// **'Исправить результат'**
  String get screenResultCorrect;

  /// No description provided for @screenStandingsResultsNote.
  ///
  /// In ru, this message translates to:
  /// **'Игровые и технические результаты основного этапа.'**
  String get screenStandingsResultsNote;

  /// No description provided for @screenReplay.
  ///
  /// In ru, this message translates to:
  /// **'Переигровка'**
  String get screenReplay;

  /// No description provided for @screenMainFinished.
  ///
  /// In ru, this message translates to:
  /// **'Основной этап завершён'**
  String get screenMainFinished;

  /// No description provided for @screenReplayPlaces.
  ///
  /// In ru, this message translates to:
  /// **'Разыграем\nместа.'**
  String get screenReplayPlaces;

  /// No description provided for @screenReplayNote.
  ///
  /// In ru, this message translates to:
  /// **'Трое участников набрали по 3 очка.'**
  String get screenReplayNote;

  /// No description provided for @screenReplayRules.
  ///
  /// In ru, this message translates to:
  /// **'Правила переигровки'**
  String get screenReplayRules;

  /// No description provided for @screenReplayRulesCopy.
  ///
  /// In ru, this message translates to:
  /// **'Участники с равными очками сыграют Mini Round Robin. FT2 и очки 3 / 2 / 1 / 0 сохраняются.'**
  String get screenReplayRulesCopy;

  /// No description provided for @screenStartReplay.
  ///
  /// In ru, this message translates to:
  /// **'Начать переигровку'**
  String get screenStartReplay;

  /// No description provided for @screenLockedReason.
  ///
  /// In ru, this message translates to:
  /// **'Следующий зависимый матч уже сыгран. Этот результат нельзя исправить.'**
  String get screenLockedReason;

  /// No description provided for @screenMapControls.
  ///
  /// In ru, this message translates to:
  /// **'Управление сеткой'**
  String get screenMapControls;

  /// No description provided for @screenMapFit.
  ///
  /// In ru, this message translates to:
  /// **'Вся сетка'**
  String get screenMapFit;

  /// No description provided for @screenMapCurrent.
  ///
  /// In ru, this message translates to:
  /// **'К текущему'**
  String get screenMapCurrent;

  /// No description provided for @screenZoomOut.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить'**
  String get screenZoomOut;

  /// No description provided for @screenZoomIn.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить'**
  String get screenZoomIn;

  /// No description provided for @screenResult.
  ///
  /// In ru, this message translates to:
  /// **'Результат'**
  String get screenResult;

  /// No description provided for @screenCorrection.
  ///
  /// In ru, this message translates to:
  /// **'Исправление'**
  String get screenCorrection;

  /// No description provided for @screenSaveResult.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить результат'**
  String get screenSaveResult;

  /// No description provided for @screenRetrySave.
  ///
  /// In ru, this message translates to:
  /// **'Повторить сохранение'**
  String get screenRetrySave;

  /// No description provided for @screenCancelResult.
  ///
  /// In ru, this message translates to:
  /// **'Отменить ввод результата'**
  String get screenCancelResult;

  /// No description provided for @screenCancelCorrection.
  ///
  /// In ru, this message translates to:
  /// **'Отменить исправление'**
  String get screenCancelCorrection;

  /// No description provided for @screenOtherActions.
  ///
  /// In ru, this message translates to:
  /// **'Другие действия'**
  String get screenOtherActions;

  /// No description provided for @screenAboutCorrection.
  ///
  /// In ru, this message translates to:
  /// **'Об исправлении'**
  String get screenAboutCorrection;

  /// No description provided for @screenCorrectionNote.
  ///
  /// In ru, this message translates to:
  /// **'Результат можно исправить, пока не сыгран следующий зависимый матч.'**
  String get screenCorrectionNote;

  /// No description provided for @screenResultSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Повтори.'**
  String get screenResultSaveError;

  /// No description provided for @screenTechnicalResult.
  ///
  /// In ru, this message translates to:
  /// **'Технический результат'**
  String get screenTechnicalResult;

  /// No description provided for @screenTechnicalWin.
  ///
  /// In ru, this message translates to:
  /// **'Техническая\nпобеда'**
  String get screenTechnicalWin;

  /// No description provided for @screenTechnicalLoss.
  ///
  /// In ru, this message translates to:
  /// **'Техническое\nпоражение'**
  String get screenTechnicalLoss;

  /// No description provided for @screenTechnicalAction.
  ///
  /// In ru, this message translates to:
  /// **'Техническое поражение'**
  String get screenTechnicalAction;

  /// No description provided for @screenTechnicalRrNote.
  ///
  /// In ru, this message translates to:
  /// **'Без игрового счёта. В RR: 3 очка победителю, 0 — сопернику.'**
  String get screenTechnicalRrNote;

  /// No description provided for @screenTechnicalDeNote.
  ///
  /// In ru, this message translates to:
  /// **'Без игрового счёта. Поражение учитывается по правилам DE.'**
  String get screenTechnicalDeNote;

  /// No description provided for @screenDecreaseScore.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить счёт'**
  String get screenDecreaseScore;

  /// No description provided for @screenIncreaseScore.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить счёт'**
  String get screenIncreaseScore;

  /// No description provided for @screenFinished.
  ///
  /// In ru, this message translates to:
  /// **'Турнир завершён'**
  String get screenFinished;

  /// No description provided for @screenChampion.
  ///
  /// In ru, this message translates to:
  /// **'Чемпион'**
  String get screenChampion;

  /// No description provided for @screenTournamentResults.
  ///
  /// In ru, this message translates to:
  /// **'Итоги турнира'**
  String get screenTournamentResults;

  /// No description provided for @screenResults.
  ///
  /// In ru, this message translates to:
  /// **'Итоги'**
  String get screenResults;

  /// No description provided for @screenHome.
  ///
  /// In ru, this message translates to:
  /// **'На главную'**
  String get screenHome;

  /// No description provided for @screenViewBracket.
  ///
  /// In ru, this message translates to:
  /// **'Посмотреть сетку'**
  String get screenViewBracket;

  /// No description provided for @screenThirdPlaces.
  ///
  /// In ru, this message translates to:
  /// **'Почему два третьих места?'**
  String get screenThirdPlaces;

  /// No description provided for @screenThirdPlacesCopy.
  ///
  /// In ru, this message translates to:
  /// **'Оба полуфиналиста делят 3–4 места. Отдельного матча за третье место нет.'**
  String get screenThirdPlacesCopy;
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
