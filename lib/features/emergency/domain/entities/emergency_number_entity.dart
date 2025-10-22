class EmergencyNumberEntity {
  final String id;
  final String? label;
  final String value;
  final String type;
  final bool? isTollFree;
  final bool? available247;
  final String? notes;

  const EmergencyNumberEntity({
    required this.id,
    this.label,
    required this.value,
    required this.type,
    this.isTollFree,
    this.available247,
    this.notes,
  });
}
