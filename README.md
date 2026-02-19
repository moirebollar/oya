# OYA — Sustainable Grocery Companion

OYA helps users make sustainable food choices by scanning product barcodes, finding nearby eco-friendly stores, comparing product sustainability, and discovering what's in season. Currently targeting **Netherlands** and **Spain**.

---

## Features (MVP)

| # | Feature | Status |
|---|---|---|
| 1 | User Auth (email/password) | Done |
| 2 | Sustainable Store Finder (OSM/Overpass) | Done |
| 3 | Product Scanner + Green-Score (A-E) | Done |
| 4 | Alternatives and Comparison | Done |
| 5 | Seasonal Produce (NL + ES) | Done |
| 6 | Supermarket Offers (AH/Jumbo/Mercadona) | Phase 2 |

---

## Tech Stack

| Layer | Technology |
|---|---|
| App | Flutter 3.24 / Dart 3.5 |
| State | Riverpod 2.x |
| Navigation | go_router 14.x |
| Backend | Firebase (Auth, Firestore, Cloud Functions) |
| Barcode | mobile_scanner 5.x |
| Food data | Open Food Facts SDK (openfoodfacts 3.29) |
| Maps | flutter_map 7.x + OpenStreetMap |
| Store data | Overpass API |

---

## Project Structure

```
lib/
  main.dart                  # Firebase init, ProviderScope, app entry
  firebase_options.dart      # FlutterFire generated (replace placeholder!)
  app.dart                   # MaterialApp.router
  app_shell.dart             # Bottom navigation ShellRoute
  core/
    firebase/                # Firebase + Riverpod DI root
    router/                  # GoRouter + auth guard
    theme/                   # Green-Score color palette
    l10n/                    # en/nl/es .arb strings
    utils/validators.dart
  features/
    auth/
    scanner/
    alternatives/
    store_finder/
    seasonal/
functions/                   # Firebase Cloud Functions (TypeScript)
scripts/                     # Firestore seed scripts
test/                        # Unit tests
```

---

## Setup

### Prerequisites
- Flutter SDK 3.24+
- Firebase CLI: `npm install -g firebase-tools`
- Node.js 20+ (for Cloud Functions and seed script)

### 1. Install Flutter dependencies
```bash
flutter pub get
```

### 2. Firebase setup
```bash
firebase login
flutterfire configure   # generates lib/firebase_options.dart
```

Replace the placeholder `lib/firebase_options.dart` with the generated output.

Add `google-services.json` to `android/app/` and `GoogleService-Info.plist` to `ios/Runner/`.

Enable in Firebase Console:
- Authentication -> Email/Password
- Firestore Database
- Cloud Functions (requires Blaze plan)

### 3. Deploy Firestore security rules
```bash
firebase deploy --only firestore:rules
```

### 4. Seed seasonal produce data
```bash
cd scripts
npm install firebase-admin
# Against local emulator (recommended for dev):
FIRESTORE_EMULATOR_HOST=localhost:8080 node seed_seasonal.js
# Against production:
GOOGLE_APPLICATION_CREDENTIALS=path/to/serviceaccount.json node seed_seasonal.js
```

### 5. Run the app
```bash
flutter run
```

---

## Running Tests

```bash
# Unit tests (18 tests, no Firebase required)
flutter test

# Integration tests (requires Firebase emulator)
firebase emulators:start --only auth,firestore
flutter test integration_test/
```

| Test file | Coverage |
|---|---|
| test/core/validators_test.dart | Email, password, required field validation |
| test/features/scanner/product_repository_test.dart | Cache hit/miss/expiry, OFF API fallback |
| test/features/store_finder/store_repository_test.dart | Geohash cache hit/miss/expiry, store lookup |

---

## Sustainability Data Sources and Attributions

| Source | Data | License |
|---|---|---|
| Open Food Facts | Green-Score, Nutri-Score, NOVA, product info | ODbL |
| OpenStreetMap via Overpass API | Eco store locations | ODbL |
| Voedingscentrum (NL) | Seasonal produce calendar | Public domain |
| MAPA (ES) | Seasonal produce calendar | Public domain |

Required in-app attributions (already implemented):
- "Data: Open Food Facts (ODbL)" on ProductDetailScreen
- "Green-Score" credit on ProductDetailScreen
- "OpenStreetMap contributors (ODbL)" on StoreMapScreen
- Source credit on SeasonalScreen

---

## Phase 2 Roadmap

- Supermarket offers via Cloud Functions (Albert Heijn, Jumbo, Mercadona)
- Questionmark NL deep scoring — requires commercial license negotiation
- Offer badges on ProductDetailScreen
- Scan history and shopping list
- Push notifications for seasonal alerts
- Expansion to additional European countries

See [TECHNICAL_RISK.md](./TECHNICAL_RISK.md) for the full risk register.

---

## License

Proprietary — (c) 2026 OYA. All rights reserved.

Third-party open-source licenses are listed in the app's Licenses screen (Flutter built-in via `LicensePage`).
