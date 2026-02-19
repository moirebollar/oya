import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oya/features/store_finder/data/store_repository.dart';
import 'package:oya/features/store_finder/domain/sustainable_store.dart';

class StoreFinderState {
  const StoreFinderState({
    this.stores = const [],
    this.isLoading = false,
    this.error,
    this.position,
    this.locationDenied = false,
  });

  final List<SustainableStore> stores;
  final bool isLoading;
  final String? error;
  final Position? position;
  final bool locationDenied;

  StoreFinderState copyWith({
    List<SustainableStore>? stores,
    bool? isLoading,
    String? error,
    Position? position,
    bool? locationDenied,
  }) {
    return StoreFinderState(
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      position: position ?? this.position,
      locationDenied: locationDenied ?? this.locationDenied,
    );
  }
}

class StoreFinderNotifier extends AsyncNotifier<StoreFinderState> {
  @override
  Future<StoreFinderState> build() async {
    return const StoreFinderState();
  }

  Future<void> loadStores() async {
    state = const AsyncLoading();

    try {
      // Check / request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        state = const AsyncData(StoreFinderState(locationDenied: true));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final stores = await ref.read(storeRepositoryProvider).getNearbyStores(
            lat: position.latitude,
            lng: position.longitude,
          );

      state = AsyncData(StoreFinderState(stores: stores, position: position));
    } catch (e) {
      state = AsyncData(StoreFinderState(error: e.toString()));
    }
  }
}

final storeFinderProvider =
    AsyncNotifierProvider<StoreFinderNotifier, StoreFinderState>(
        StoreFinderNotifier.new);
