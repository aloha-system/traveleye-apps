class Destination {
  final String id;
  final String name;
  final String description;
  final String city;
  final String province;
  final double rating;
  final int ticketPrice;
  final double? latitude;
  final double? longitude;
  final String category;
  final List<String> facilities;
  final Map<String, String> openingHours;
  final List<String> imageUrls;

  const Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.province,
    required this.rating,
    required this.ticketPrice,
    this.latitude,
    this.longitude,
    required this.category,
    this.facilities = const [],
    this.openingHours = const {},
    this.imageUrls = const [],
  });
}
