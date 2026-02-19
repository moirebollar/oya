import 'package:dio/dio.dart';
import 'package:oya/features/store_finder/domain/sustainable_store.dart';

class OverpassApiClient {
  OverpassApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ));

  final Dio _dio;

  static const _primaryUrl = 'https://overpass-api.de/api/interpreter';
  static const _backupUrl = 'https://overpass.kumi.systems/api/interpreter';

  Future<List<SustainableStore>> findStores({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
  }) async {
    final query = '''
[out:json][timeout:25];
(
  node["shop"="health_food"](around:$radiusMeters,$lat,$lng);
  node["shop"="organic"](around:$radiusMeters,$lat,$lng);
  node["organic"="only"](around:$radiusMeters,$lat,$lng);
  node["zero_waste"="yes"]["shop"](around:$radiusMeters,$lat,$lng);
);
out body;
''';

    try {
      return await _query(_primaryUrl, query);
    } catch (_) {
      return await _query(_backupUrl, query);
    }
  }

  Future<List<SustainableStore>> _query(String url, String query) async {
    final response = await _dio.post<Map<String, dynamic>>(
      url,
      data: 'data=${Uri.encodeComponent(query)}',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {'User-Agent': 'OYA/1.0 (contact@oyaapp.com)'},
      ),
    );

    final elements = response.data!['elements'] as List<dynamic>? ?? [];
    final seen = <String>{};
    final stores = <SustainableStore>[];

    for (final element in elements) {
      final node = element as Map<String, dynamic>;
      final id = '${node['id']}';
      if (seen.contains(id)) continue;
      seen.add(id);
      try {
        stores.add(SustainableStore.fromOsmNode(node));
      } catch (_) {
        // Skip malformed nodes
      }
    }

    return stores;
  }
}
