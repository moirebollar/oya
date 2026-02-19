// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OYA';

  @override
  String get tagline => 'Sustainable Choices, Every Day';

  @override
  String get navScan => 'Scan';

  @override
  String get navStores => 'Stores';

  @override
  String get navSeasonal => 'Seasonal';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginSignUp => 'Sign up';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get signUpSubtitle => 'Join OYA and shop sustainably';

  @override
  String get signUpName => 'Full name';

  @override
  String get signUpEmail => 'Email';

  @override
  String get signUpPassword => 'Password';

  @override
  String get signUpConfirmPassword => 'Confirm password';

  @override
  String get signUpCountry => 'Country';

  @override
  String get signUpCountryNL => 'Netherlands';

  @override
  String get signUpCountryES => 'Spain';

  @override
  String get signUpCountryOther => 'Other';

  @override
  String get signUpButton => 'Create Account';

  @override
  String get signUpHaveAccount => 'Already have an account?';

  @override
  String get signUpSignIn => 'Sign in';

  @override
  String get resetTitle => 'Reset password';

  @override
  String get resetSubtitle => 'Enter your email to receive a reset link';

  @override
  String get resetButton => 'Send Reset Link';

  @override
  String get resetSuccess => 'Reset link sent! Check your inbox.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileCountry => 'Country';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get profileLicenses => 'Open Source Licenses';

  @override
  String get profileAbout => 'About OYA';

  @override
  String get scanTitle => 'Scan Product';

  @override
  String get scanInstruction => 'Point camera at barcode';

  @override
  String get scanNotFound => 'Product not found';

  @override
  String get scanNotFoundSub =>
      'Help improve OYA by adding this product to Open Food Facts';

  @override
  String get scanAddToOFF => 'Add to Open Food Facts';

  @override
  String get scanHistory => 'Recent Scans';

  @override
  String get productGreenScore => 'Green Score';

  @override
  String get productNutriScore => 'Nutri-Score';

  @override
  String get productNova => 'NOVA Group';

  @override
  String get productCertifications => 'Certifications';

  @override
  String get productAlternatives => 'See Alternatives';

  @override
  String get productDataSource => 'Data: Open Food Facts (ODbL)';

  @override
  String get productGreenScoreSource =>
      'Green Score: Open Food Facts — CC BY-SA 4.0';

  @override
  String get productNoScore => 'No score available';

  @override
  String get productUnknown => 'Unknown product';

  @override
  String get greenScoreA => 'Excellent environmental impact';

  @override
  String get greenScoreB => 'Good environmental impact';

  @override
  String get greenScoreC => 'Moderate environmental impact';

  @override
  String get greenScoreD => 'Poor environmental impact';

  @override
  String get greenScoreE => 'High environmental impact';

  @override
  String get alternativesTitle => 'Better Alternatives';

  @override
  String get alternativesSubtitle => 'Products with a higher Green Score';

  @override
  String get alternativesEmpty => 'No alternatives found';

  @override
  String get alternativesCompare => 'Compare';

  @override
  String get storesTitle => 'Nearby Eco Stores';

  @override
  String get storesLoading => 'Finding sustainable stores...';

  @override
  String get storesEmpty => 'No sustainable stores found nearby';

  @override
  String get storesEmptySub => 'Try expanding the search radius';

  @override
  String get storesLocationDenied =>
      'Location access is required to find nearby stores';

  @override
  String get storesLocationSettings => 'Open Settings';

  @override
  String get storesMapAttribution => '© OpenStreetMap contributors';

  @override
  String get storesCertOrganic => 'Organic';

  @override
  String get storesCertZeroWaste => 'Zero Waste';

  @override
  String get storesCertHealthFood => 'Health Food';

  @override
  String get storesDetailHours => 'Opening Hours';

  @override
  String get storesDetailAddress => 'Address';

  @override
  String get storesDetailCertifications => 'Certifications';

  @override
  String get seasonalTitle => 'Seasonal Produce';

  @override
  String get seasonalSubtitle => 'What\'s in season right now';

  @override
  String get seasonalEmpty => 'No seasonal data available';

  @override
  String get seasonalPeak => 'Peak season';

  @override
  String get seasonalAvailable => 'Available';

  @override
  String get seasonalSourceNL => 'Source: Voedingscentrum';

  @override
  String get seasonalSourceES => 'Source: MAPA (Ministerio de Agricultura)';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorRetry => 'Try again';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorNoInternetSub => 'Check your connection and try again';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Enter a valid email address';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordsNoMatch => 'Passwords do not match';

  @override
  String get validationNameRequired => 'Name is required';
}
