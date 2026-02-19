# OYA — Technical Risk Register

Last updated: 2026-02-18

---

## HIGH RISK

### R-01 · Unofficial Supermarket APIs (Phase 2)
| | |
|---|---|
| **Affected feature** | Supermarket Offers (Feature 6) |
| **APIs** | Albert Heijn `api.ah.nl`, Jumbo `mobileapi.jumbo.com`, Mercadona `mercadona.es/api` |
| **Risk** | All three endpoints are undocumented, unofficial, and not covered by any ToS for third-party use. AH/Jumbo are reverse-engineered from their own mobile apps. Mercadona does not publish an API. |
| **Impact** | API could be blocked, rate-limited, or changed without notice. Legal demand to cease use is possible. |
| **Mitigation** | 1. Proxy all calls through Cloud Functions so the app binary never contains endpoint URLs. 2. Implement a Firestore remote feature flag `offers_enabled` — set `false` to disable instantly without app update. 3. Cache aggressively (48 h TTL) to reduce request frequency. 4. Before public launch, seek official data partnerships or use affiliate product feeds instead. |
| **Decision gate** | Do not enable in production without legal review. |

---

## MEDIUM RISK

### R-02 · Questionmark API License (Phase 2 — NL only)
| | |
|---|---|
| **Affected feature** | Deep NL Sustainability Score |
| **License** | CC BY-NC 4.0 (non-commercial only) |
| **Risk** | If OYA charges users or runs ads, using Questionmark data under CC BY-NC is a license violation. |
| **Mitigation** | Contact Questionmark Foundation before Phase 2. Negotiate a commercial license or revenue-share agreement. Do not ship this feature without explicit written approval. |
| **Contact** | developers.thequestionmark.org |

### R-03 · Open Food Facts Green-Score Data Quality
| | |
|---|---|
| **Affected feature** | Product Scanner, Alternatives |
| **Risk** | Green-Score (Eco-Score) is missing for ~40% of products in OFF. Products in NL and ES have lower OFF coverage than France. Many products will show "unknown" grade. |
| **Mitigation** | Show a clear "No sustainability data available" state instead of a misleading score. Link users to the OFF app or website to contribute missing data. Monitor coverage improvement over time. |

### R-04 · Overpass API Rate Limits and Reliability
| | |
|---|---|
| **Affected feature** | Sustainable Store Finder |
| **Risk** | `overpass-api.de` is a public instance with no SLA. Can be slow or unavailable under load. |
| **Mitigation** | 1. 24-hour geohash Firestore cache reduces hit rate significantly. 2. Fallback URL: `overpass.kumi.systems/api/interpreter`. 3. Graceful error state shown to user when both fail. 4. Phase 2: consider self-hosted Overpass instance for production. |

### R-05 · Mobile Scanner (mobile_scanner) Camera Permissions
| | |
|---|---|
| **Affected feature** | Product Scanner |
| **Risk** | iOS requires NSCameraUsageDescription. Android requires CAMERA permission. If user denies, scanner is non-functional. |
| **Mitigation** | Graceful denial handling implemented in `ScannerScreen`. Provide a barcode manual-entry fallback (Phase 2). |

---

## LOW RISK

### R-06 · OpenStreetMap Data Quality for Stores
| | |
|---|---|
| **Risk** | OSM tags for eco stores are inconsistently applied. Many organic shops may lack `organic=yes` or `zero_waste=yes` tags. |
| **Mitigation** | Query multiple tag combinations (see Overpass QL in `overpass_api_client.dart`). Surface OSM edit link so users can improve data. |

### R-07 · Firebase Pricing (Blaze Plan Required)
| | |
|---|---|
| **Risk** | Cloud Functions require Blaze (pay-as-you-go). Firestore reads/writes scale with users. |
| **Mitigation** | Product cache (7-day TTL) and store cache (24-hour TTL) limit repeat API calls. Set Firebase budget alerts at €10/month. Phase 2: add read cost guards. |

### R-08 · Seasonal Produce Data Accuracy
| | |
|---|---|
| **Risk** | Static JSON data seeded once. Seasonal windows vary year-to-year due to climate. |
| **Mitigation** | Data sourced from Voedingscentrum (NL) and MAPA (ES) — authoritative public-domain sources. Review and re-seed annually. Attribute sources on the Seasonal screen. |

### R-09 · `flutter_map_tile_caching` GPL-3.0 Exclusion
| | |
|---|---|
| **Risk** | If tile caching is added via `flutter_map_tile_caching`, it would impose GPL-3.0 on the entire app (viral license), incompatible with a commercial app. |
| **Mitigation** | This package is explicitly excluded from `pubspec.yaml`. Phase 2 map tile caching will be implemented via `dio` + `path_provider` (MIT-compatible). |

---

## COMPLIANCE CHECKLIST

| Requirement | Status |
|---|---|
| OFF attribution ("Data: Open Food Facts – ODbL") on ProductDetailScreen | ✅ Implemented |
| Green-Score logo attribution on ProductDetailScreen | ✅ Implemented |
| OSM attribution ("© OpenStreetMap contributors") on StoreMapScreen | ✅ Implemented |
| Seasonal data source attribution (Voedingscentrum / MAPA) | ✅ In SeasonalScreen |
| `openfoodfacts` SDK User-Agent header set | ✅ In OffProductClient.configure() |
| `flutter_map_tile_caching` GPL package excluded | ✅ Not in pubspec |
| Unofficial API feature flag in Firestore | ⏳ Phase 2 |
| Questionmark commercial license | ⏳ Phase 2 — required before launch |
| Firebase budget alert configured | ⏳ Manual — set in Firebase Console |
