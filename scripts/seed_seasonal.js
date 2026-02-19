/**
 * Seasonal produce seed script for Firestore.
 *
 * Usage:
 *   1. Set GOOGLE_APPLICATION_CREDENTIALS to your service account key path, OR
 *      run against the local emulator with FIRESTORE_EMULATOR_HOST=localhost:8080
 *   2. npm install firebase-admin
 *   3. node scripts/seed_seasonal.js
 *
 * For emulator (recommended during development):
 *   FIRESTORE_EMULATOR_HOST=localhost:8080 node scripts/seed_seasonal.js
 */

const admin = require('firebase-admin');
const data = require('./seasonal_seed_data.json');

// Initialize Firebase Admin SDK.
// Loads serviceaccount.json from the same scripts/ folder.
const path = require('path');
const serviceAccount = require('./serviceaccount.json');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: 'communityhub-d5b38',
  });
}

const db = admin.firestore();

async function seed() {
  let totalWrites = 0;

  for (const [country, months] of Object.entries(data)) {
    for (const [month, items] of Object.entries(months)) {
      const docRef = db
        .collection('seasonal_produce')
        .doc(country)
        .collection('months')
        .doc(month);

      await docRef.set({ items, source: country === 'NL' ? 'Voedingscentrum' : 'MAPA' });
      totalWrites++;
      console.log(`Seeded: seasonal_produce/${country}/months/${month} → ${items.length} items`);
    }
  }

  console.log(`\nDone. ${totalWrites} documents written.`);
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
