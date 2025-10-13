import 'package:boole_apps/features/detail/domain/entities/destination_detail.dart';

class DestinationDetailModel {
  final String id;
  final String name;
  final String description;
  final String city;
  final String province;
  final double rating;
  final int ticketPrice;
  final List<String> imageUrls;
  final List<String> facilities;

  DestinationDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.province,
    required this.rating,
    required this.ticketPrice,
    required this.imageUrls,
    required this.facilities,
  });

  factory DestinationDetailModel.fromJson(Map<String, dynamic> json) {
    return DestinationDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      ticketPrice: json['ticket_price'] ?? 0,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
    );
  }

  Future<DestinationDetail>? get entity => null;
}
