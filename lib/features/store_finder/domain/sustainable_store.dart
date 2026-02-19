import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class SustainableStore extends Equatable {
  const SustainableStore({
    required this.osmId,
    required this.name,
    required this.lat,
    required this.lng,
    this.address,
    this.openingHours,
    this.shopType,
    this.isOrganic = false,
    this.isZeroWaste = false,
  });

  final String osmId;
  final String name;
  final double lat;
  final double lng;
  final String? address;
  final String? openingHours;
  final String? shopType;
  final bool isOrganic;
  final bool isZeroWaste;

  LatLng get latLng => LatLng(lat, lng);

  factory SustainableStore.fromOsmNode(Map<String, dynamic> node) {
    final tags = Map<String, String>.from(node['tags'] as Map? ?? {});
    final lat = (node['lat'] as num).toDouble();
    final lng = (node['lon'] as num).toDouble();

    final street = tags['addr:street'] ?? '';
    final number = tags['addr:housenumber'] ?? '';
    final city = tags['addr:city'] ?? '';
    final address = [
      if (street.isNotEmpty) '$street $number'.trim(),
      if (city.isNotEmpty) city,
    ].join(', ');

    return SustainableStore(
      osmId: '${node['id']}',
      name: tags['name'] ?? 'Unnamed store',
      lat: lat,
      lng: lng,
      address: address.isEmpty ? null : address,
      openingHours: tags['opening_hours'],
      shopType: tags['shop'],
      isOrganic: tags['organic'] == 'only' || tags['organic'] == 'yes',
      isZeroWaste: tags['zero_waste'] == 'yes',
    );
  }

  Map<String, dynamic> toMap() => {
        'osmId': osmId,
        'name': name,
        'lat': lat,
        'lng': lng,
        if (address != null) 'address': address,
        if (openingHours != null) 'openingHours': openingHours,
        if (shopType != null) 'shopType': shopType,
        'isOrganic': isOrganic,
        'isZeroWaste': isZeroWaste,
      };

  factory SustainableStore.fromMap(Map<String, dynamic> data) {
    return SustainableStore(
      osmId: data['osmId'] as String,
      name: data['name'] as String,
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      address: data['address'] as String?,
      openingHours: data['openingHours'] as String?,
      shopType: data['shopType'] as String?,
      isOrganic: data['isOrganic'] as bool? ?? false,
      isZeroWaste: data['isZeroWaste'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [osmId, name, lat, lng];
}
