import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In cs, this message translates to:
  /// **'EX-Boat DC'**
  String get appTitle;

  /// No description provided for @boats.
  ///
  /// In cs, this message translates to:
  /// **'Lodě'**
  String get boats;

  /// No description provided for @races.
  ///
  /// In cs, this message translates to:
  /// **'Závody'**
  String get races;

  /// No description provided for @settings.
  ///
  /// In cs, this message translates to:
  /// **'Nastavení'**
  String get settings;

  /// No description provided for @deleteData.
  ///
  /// In cs, this message translates to:
  /// **'Smazat data'**
  String get deleteData;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In cs, this message translates to:
  /// **'Smazat data'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmContent.
  ///
  /// In cs, this message translates to:
  /// **'Opravdu chcete smazat všechna data?'**
  String get deleteConfirmContent;

  /// No description provided for @cancel.
  ///
  /// In cs, this message translates to:
  /// **'Zrušit'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In cs, this message translates to:
  /// **'Smazat'**
  String get delete;

  /// No description provided for @addBoat.
  ///
  /// In cs, this message translates to:
  /// **'Přidat loď'**
  String get addBoat;

  /// No description provided for @addRace.
  ///
  /// In cs, this message translates to:
  /// **'Přidat závod'**
  String get addRace;

  /// No description provided for @addScore.
  ///
  /// In cs, this message translates to:
  /// **'Přidat záznam'**
  String get addScore;

  /// No description provided for @synchronize.
  ///
  /// In cs, this message translates to:
  /// **'Synchronizovat'**
  String get synchronize;

  /// No description provided for @category.
  ///
  /// In cs, this message translates to:
  /// **'Kategorie:'**
  String get category;

  /// No description provided for @name.
  ///
  /// In cs, this message translates to:
  /// **'Jméno:'**
  String get name;

  /// No description provided for @enterBoatName.
  ///
  /// In cs, this message translates to:
  /// **'Zadejte jméno lodi'**
  String get enterBoatName;

  /// No description provided for @secondsInTimer.
  ///
  /// In cs, this message translates to:
  /// **'Sekundy v časovači:'**
  String get secondsInTimer;

  /// No description provided for @enterSeconds.
  ///
  /// In cs, this message translates to:
  /// **'Zadejte sekundy'**
  String get enterSeconds;

  /// No description provided for @explainTimer.
  ///
  /// In cs, this message translates to:
  /// **'Vysvětlení nastavení časovače:'**
  String get explainTimer;

  /// No description provided for @explainTimerHint.
  ///
  /// In cs, this message translates to:
  /// **'Vysvětlete časovač'**
  String get explainTimerHint;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In cs, this message translates to:
  /// **'Prosím vyplňte všechna pole.'**
  String get pleaseFillAllFields;

  /// No description provided for @pleaseEnterValidSeconds.
  ///
  /// In cs, this message translates to:
  /// **'Prosím zadejte platný počet sekund.'**
  String get pleaseEnterValidSeconds;

  /// No description provided for @pleaseExplainTimer.
  ///
  /// In cs, this message translates to:
  /// **'Prosím vysvětlete nastavení časovače.'**
  String get pleaseExplainTimer;

  /// No description provided for @addRaceTitle.
  ///
  /// In cs, this message translates to:
  /// **'Přidat nový závod'**
  String get addRaceTitle;

  /// No description provided for @dateLabel.
  ///
  /// In cs, this message translates to:
  /// **'Datum (DD/MM/YYYY)'**
  String get dateLabel;

  /// No description provided for @pleaseEnterName.
  ///
  /// In cs, this message translates to:
  /// **'Prosím zadejte jméno'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterDate.
  ///
  /// In cs, this message translates to:
  /// **'Prosím zadejte datum'**
  String get pleaseEnterDate;

  /// No description provided for @pleaseEnterValidDate.
  ///
  /// In cs, this message translates to:
  /// **'Prosím zadejte platné datum'**
  String get pleaseEnterValidDate;

  /// No description provided for @submit.
  ///
  /// In cs, this message translates to:
  /// **'Odeslat'**
  String get submit;

  /// No description provided for @addRecordTitle.
  ///
  /// In cs, this message translates to:
  /// **'Přidat nový záznam'**
  String get addRecordTitle;

  /// No description provided for @noRaceTitle.
  ///
  /// In cs, this message translates to:
  /// **'Žádný závod'**
  String get noRaceTitle;

  /// No description provided for @noRaceContent.
  ///
  /// In cs, this message translates to:
  /// **'Bohužel nejsou k dispozici žádné závody'**
  String get noRaceContent;

  /// No description provided for @warning.
  ///
  /// In cs, this message translates to:
  /// **'Varování'**
  String get warning;

  /// No description provided for @noBoatsWarning.
  ///
  /// In cs, this message translates to:
  /// **'Zatím nejsou vyplněny žádné lodě.'**
  String get noBoatsWarning;

  /// No description provided for @ok.
  ///
  /// In cs, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @intendedScore.
  ///
  /// In cs, this message translates to:
  /// **'Zamýšlené skóre:'**
  String get intendedScore;

  /// No description provided for @scoreHint.
  ///
  /// In cs, this message translates to:
  /// **'Skóre'**
  String get scoreHint;

  /// No description provided for @intendedDirection.
  ///
  /// In cs, this message translates to:
  /// **'Zamýšlený směr:'**
  String get intendedDirection;

  /// No description provided for @gatePart.
  ///
  /// In cs, this message translates to:
  /// **'V části branky:'**
  String get gatePart;

  /// No description provided for @gainedScore.
  ///
  /// In cs, this message translates to:
  /// **'Získané skóre:'**
  String get gainedScore;

  /// No description provided for @hitDirection.
  ///
  /// In cs, this message translates to:
  /// **'Směr zásahu:'**
  String get hitDirection;

  /// No description provided for @boat.
  ///
  /// In cs, this message translates to:
  /// **'Loď:'**
  String get boat;

  /// No description provided for @race.
  ///
  /// In cs, this message translates to:
  /// **'Závod:'**
  String get race;

  /// No description provided for @save.
  ///
  /// In cs, this message translates to:
  /// **'Uložit'**
  String get save;

  /// No description provided for @runListTitle.
  ///
  /// In cs, this message translates to:
  /// **'Seznam jízd'**
  String get runListTitle;

  /// No description provided for @raceRunsTitle.
  ///
  /// In cs, this message translates to:
  /// **'Jízdy závodu'**
  String get raceRunsTitle;

  /// No description provided for @noRunsForRace.
  ///
  /// In cs, this message translates to:
  /// **'Žádné jízdy pro tento závod'**
  String get noRunsForRace;

  /// No description provided for @backendUrl.
  ///
  /// In cs, this message translates to:
  /// **'URL backendu:'**
  String get backendUrl;

  /// No description provided for @backendUrlSaved.
  ///
  /// In cs, this message translates to:
  /// **'URL backendu úspěšně uložena'**
  String get backendUrlSaved;

  /// No description provided for @enterValidUrl.
  ///
  /// In cs, this message translates to:
  /// **'Prosím zadejte platnou URL'**
  String get enterValidUrl;

  /// No description provided for @language.
  ///
  /// In cs, this message translates to:
  /// **'Jazyk'**
  String get language;

  /// No description provided for @czech.
  ///
  /// In cs, this message translates to:
  /// **'Čeština'**
  String get czech;

  /// No description provided for @english.
  ///
  /// In cs, this message translates to:
  /// **'Angličtina'**
  String get english;

  /// No description provided for @runId.
  ///
  /// In cs, this message translates to:
  /// **'ID jízdy'**
  String get runId;

  /// No description provided for @scopeTo.
  ///
  /// In cs, this message translates to:
  /// **'Záměr na'**
  String get scopeTo;

  /// No description provided for @directionTo.
  ///
  /// In cs, this message translates to:
  /// **'Směr na'**
  String get directionTo;

  /// No description provided for @hit.
  ///
  /// In cs, this message translates to:
  /// **'Zásah'**
  String get hit;

  /// No description provided for @directionHit.
  ///
  /// In cs, this message translates to:
  /// **'Směr zásahu'**
  String get directionHit;

  /// No description provided for @intendedGatePart.
  ///
  /// In cs, this message translates to:
  /// **'Zamýšlená část branky'**
  String get intendedGatePart;

  /// No description provided for @date.
  ///
  /// In cs, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @errorLoadingBoat.
  ///
  /// In cs, this message translates to:
  /// **'Chyba při načítání lodi'**
  String get errorLoadingBoat;

  /// No description provided for @boatNotFound.
  ///
  /// In cs, this message translates to:
  /// **'Loď nenalezena'**
  String get boatNotFound;

  /// No description provided for @about.
  ///
  /// In cs, this message translates to:
  /// **'O aplikaci'**
  String get about;

  /// No description provided for @aboutTitle.
  ///
  /// In cs, this message translates to:
  /// **'O Aplikaci'**
  String get aboutTitle;

  /// No description provided for @appName.
  ///
  /// In cs, this message translates to:
  /// **'EX-Boat DC'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In cs, this message translates to:
  /// **'Aplikace pro ukládání výsledků modelů lodí kategorií EX-500 a EX-A'**
  String get appDescription;

  /// No description provided for @author.
  ///
  /// In cs, this message translates to:
  /// **'Autor'**
  String get author;

  /// No description provided for @authorName.
  ///
  /// In cs, this message translates to:
  /// **'Sebastian Walenta'**
  String get authorName;

  /// No description provided for @year.
  ///
  /// In cs, this message translates to:
  /// **'2026'**
  String get year;

  /// No description provided for @project.
  ///
  /// In cs, this message translates to:
  /// **'Projekt'**
  String get project;

  /// No description provided for @projectUrl.
  ///
  /// In cs, this message translates to:
  /// **'github.com/Thechopsee/exdata_collector'**
  String get projectUrl;

  /// No description provided for @version.
  ///
  /// In cs, this message translates to:
  /// **'Verze'**
  String get version;

  /// No description provided for @themeMode.
  ///
  /// In cs, this message translates to:
  /// **'Režim vzhledu'**
  String get themeMode;

  /// No description provided for @light.
  ///
  /// In cs, this message translates to:
  /// **'Světlý'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In cs, this message translates to:
  /// **'Tmavý'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In cs, this message translates to:
  /// **'Systém'**
  String get system;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
