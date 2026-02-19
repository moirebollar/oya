import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_nl.dart';

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
    Locale('en'),
    Locale('es'),
    Locale('nl'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'OYA'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Sustainable Choices, Every Day'**
  String get tagline;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get navStores;

  /// No description provided for @navSeasonal.
  ///
  /// In en, this message translates to:
  /// **'Seasonal'**
  String get navSeasonal;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get loginSignUp;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join OYA and shop sustainably'**
  String get signUpSubtitle;

  /// No description provided for @signUpName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get signUpName;

  /// No description provided for @signUpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signUpEmail;

  /// No description provided for @signUpPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPassword;

  /// No description provided for @signUpConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get signUpConfirmPassword;

  /// No description provided for @signUpCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get signUpCountry;

  /// No description provided for @signUpCountryNL.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get signUpCountryNL;

  /// No description provided for @signUpCountryES.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get signUpCountryES;

  /// No description provided for @signUpCountryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get signUpCountryOther;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpButton;

  /// No description provided for @signUpHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signUpHaveAccount;

  /// No description provided for @signUpSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signUpSignIn;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get resetSubtitle;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get resetButton;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent! Check your inbox.'**
  String get resetSuccess;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountry;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get profileLicenses;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About OYA'**
  String get profileAbout;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Product'**
  String get scanTitle;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point camera at barcode'**
  String get scanInstruction;

  /// No description provided for @scanNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get scanNotFound;

  /// No description provided for @scanNotFoundSub.
  ///
  /// In en, this message translates to:
  /// **'Help improve OYA by adding this product to Open Food Facts'**
  String get scanNotFoundSub;

  /// No description provided for @scanAddToOFF.
  ///
  /// In en, this message translates to:
  /// **'Add to Open Food Facts'**
  String get scanAddToOFF;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get scanHistory;

  /// No description provided for @productGreenScore.
  ///
  /// In en, this message translates to:
  /// **'Green Score'**
  String get productGreenScore;

  /// No description provided for @productNutriScore.
  ///
  /// In en, this message translates to:
  /// **'Nutri-Score'**
  String get productNutriScore;

  /// No description provided for @productNova.
  ///
  /// In en, this message translates to:
  /// **'NOVA Group'**
  String get productNova;

  /// No description provided for @productCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get productCertifications;

  /// No description provided for @productAlternatives.
  ///
  /// In en, this message translates to:
  /// **'See Alternatives'**
  String get productAlternatives;

  /// No description provided for @productDataSource.
  ///
  /// In en, this message translates to:
  /// **'Data: Open Food Facts (ODbL)'**
  String get productDataSource;

  /// No description provided for @productGreenScoreSource.
  ///
  /// In en, this message translates to:
  /// **'Green Score: Open Food Facts — CC BY-SA 4.0'**
  String get productGreenScoreSource;

  /// No description provided for @productNoScore.
  ///
  /// In en, this message translates to:
  /// **'No score available'**
  String get productNoScore;

  /// No description provided for @productUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown product'**
  String get productUnknown;

  /// No description provided for @greenScoreA.
  ///
  /// In en, this message translates to:
  /// **'Excellent environmental impact'**
  String get greenScoreA;

  /// No description provided for @greenScoreB.
  ///
  /// In en, this message translates to:
  /// **'Good environmental impact'**
  String get greenScoreB;

  /// No description provided for @greenScoreC.
  ///
  /// In en, this message translates to:
  /// **'Moderate environmental impact'**
  String get greenScoreC;

  /// No description provided for @greenScoreD.
  ///
  /// In en, this message translates to:
  /// **'Poor environmental impact'**
  String get greenScoreD;

  /// No description provided for @greenScoreE.
  ///
  /// In en, this message translates to:
  /// **'High environmental impact'**
  String get greenScoreE;

  /// No description provided for @alternativesTitle.
  ///
  /// In en, this message translates to:
  /// **'Better Alternatives'**
  String get alternativesTitle;

  /// No description provided for @alternativesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products with a higher Green Score'**
  String get alternativesSubtitle;

  /// No description provided for @alternativesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No alternatives found'**
  String get alternativesEmpty;

  /// No description provided for @alternativesCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get alternativesCompare;

  /// No description provided for @storesTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Eco Stores'**
  String get storesTitle;

  /// No description provided for @storesLoading.
  ///
  /// In en, this message translates to:
  /// **'Finding sustainable stores...'**
  String get storesLoading;

  /// No description provided for @storesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sustainable stores found nearby'**
  String get storesEmpty;

  /// No description provided for @storesEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Try expanding the search radius'**
  String get storesEmptySub;

  /// No description provided for @storesLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access is required to find nearby stores'**
  String get storesLocationDenied;

  /// No description provided for @storesLocationSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get storesLocationSettings;

  /// No description provided for @storesMapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get storesMapAttribution;

  /// No description provided for @storesCertOrganic.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get storesCertOrganic;

  /// No description provided for @storesCertZeroWaste.
  ///
  /// In en, this message translates to:
  /// **'Zero Waste'**
  String get storesCertZeroWaste;

  /// No description provided for @storesCertHealthFood.
  ///
  /// In en, this message translates to:
  /// **'Health Food'**
  String get storesCertHealthFood;

  /// No description provided for @storesDetailHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get storesDetailHours;

  /// No description provided for @storesDetailAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get storesDetailAddress;

  /// No description provided for @storesDetailCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get storesDetailCertifications;

  /// No description provided for @seasonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Produce'**
  String get seasonalTitle;

  /// No description provided for @seasonalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s in season right now'**
  String get seasonalSubtitle;

  /// No description provided for @seasonalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No seasonal data available'**
  String get seasonalEmpty;

  /// No description provided for @seasonalPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak season'**
  String get seasonalPeak;

  /// No description provided for @seasonalAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get seasonalAvailable;

  /// No description provided for @seasonalSourceNL.
  ///
  /// In en, this message translates to:
  /// **'Source: Voedingscentrum'**
  String get seasonalSourceNL;

  /// No description provided for @seasonalSourceES.
  ///
  /// In en, this message translates to:
  /// **'Source: MAPA (Ministerio de Agricultura)'**
  String get seasonalSourceES;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorRetry;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNoInternet;

  /// No description provided for @errorNoInternetSub.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get errorNoInternetSub;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsNoMatch;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;
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
      <String>['en', 'es', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
