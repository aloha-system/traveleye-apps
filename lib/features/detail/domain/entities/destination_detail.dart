class DestinationDetail {
  final String id;                 // uuid
  final String name;
  final String description;
  final String city;
  final String province;
  final double? rating;
  final int? ticketPrice;
  final List<String> imageUrls;
  final Map<String, String> openingHours; // mon..sun
  final List<String> facilities;
  final double? latitude;
  final double? longitude;

  const DestinationDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.province,
    required this.imageUrls,
    required this.openingHours,
    required this.facilities,
    this.rating,
    this.ticketPrice,
    this.latitude,
    this.longitude,
  });
}
