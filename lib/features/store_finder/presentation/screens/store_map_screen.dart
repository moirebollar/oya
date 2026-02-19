import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:oya/l10n/app_localizations.dart';
import 'package:oya/core/theme/app_colors.dart';
import 'package:oya/features/store_finder/domain/sustainable_store.dart';
import 'package:oya/features/store_finder/providers/store_finder_provider.dart';

class StoreMapScreen extends ConsumerStatefulWidget {
  const StoreMapScreen({super.key});

  @override
  ConsumerState<StoreMapScreen> createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends ConsumerState<StoreMapScreen> {
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storeFinderProvider.notifier).loadStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final stateAsync = ref.watch(storeFinderProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.storesTitle)),
      body: stateAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l.storesLoading),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (storeState) {
          if (storeState.locationDenied) {
            return _LocationDeniedBody(l: l);
          }

          final position = storeState.position;
          final center = position != null
              ? LatLng(position.latitude, position.longitude)
              : const LatLng(52.3676, 4.9041); // Amsterdam fallback

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(initialCenter: center, initialZoom: 14),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.oyaapp.oya',
                  ),
                  if (position != null)
                    MarkerLayer(markers: [
                      Marker(
                        point: center,
                        width: 24,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ]),
                  MarkerLayer(
                    markers: storeState.stores
                        .map((store) => Marker(
                              point: store.latLng,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () => context
                                    .push('/stores/${store.osmId}',
                                        extra: storeState.stores),
                                child: _StoreMarker(store: store),
                              ),
                            ))
                        .toList(),
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(l.storesMapAttribution),
                    ],
                  ),
                ],
              ),
              // Store list panel at bottom
              if (storeState.stores.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _StoreListPanel(
                    stores: storeState.stores,
                    allStores: storeState.stores,
                  ),
                ),
              if (storeState.stores.isEmpty && !storeState.isLoading)
                Positioned(
                  bottom: 48,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(l.storesEmpty,
                        textAlign: TextAlign.center),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StoreMarker extends StatelessWidget {
  const _StoreMarker({required this.store});

  final SustainableStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Icon(
        store.isOrganic ? Icons.eco : Icons.store,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

class _StoreListPanel extends StatelessWidget {
  const _StoreListPanel({
    required this.stores,
    required this.allStores,
  });

  final List<SustainableStore> stores;
  final List<SustainableStore> allStores;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: stores.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final store = stores[index];
          return GestureDetector(
            onTap: () => context.push('/stores/${store.osmId}', extra: allStores),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.store, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          store.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (store.address != null) ...[
                    const SizedBox(height: 4),
                    Text(store.address!,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                  const Spacer(),
                  Row(
                    children: [
                      if (store.isOrganic)
                        const _CertChip(label: 'Organic'),
                      if (store.isZeroWaste) ...[
                        const SizedBox(width: 4),
                        const _CertChip(label: 'Zero Waste'),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CertChip extends StatelessWidget {
  const _CertChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 9,
              color: AppColors.primary,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _LocationDeniedBody extends StatelessWidget {
  const _LocationDeniedBody({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l.storesLocationDenied,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Geolocator.openAppSettings(),
              child: Text(l.storesLocationSettings),
            ),
          ],
        ),
      ),
    );
  }
}
