import 'package:boole_apps/features/emergency/domain/entities/emergency_number_entity.dart';

class EmergencyNumberModel extends EmergencyNumberEntity {
  const EmergencyNumberModel({
    required super.id,
    super.label,
    required super.value,
    required super.type,
    super.isTollFree,
    super.available247,
    super.notes,
  });

  factory EmergencyNumberModel.fromJson(Map<String, dynamic> json) {
    return EmergencyNumberModel(
      id: json['id'],
      label: json['label'],
      value: json['value'],
      type: json['type'],
      isTollFree: json['is_toll_free'],
      available247: json['available_24_7'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'type': type,
      'is_toll_free': isTollFree,
      'available_24_7': available247,
      'notes': notes,
    };
  }
}
