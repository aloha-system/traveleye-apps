import 'package:boole_apps/features/culture/domain/entities/culture_entity.dart';

enum CultureStatus { initial, loading, success, error }

class CultureState {
  final CultureStatus status;
  final String? message;
  final Culture? culture;

  const CultureState({
    this.status = CultureStatus.initial,
    this.message,
    this.culture,
  });

  bool get isLoading => status == CultureStatus.loading;
  bool get isSuccess => status == CultureStatus.success;
  bool get isError => status == CultureStatus.error;

  CultureState copyWith({CultureStatus? status, String? message, Culture? culture}) {
    return CultureState(
      status: status ?? this.status,
      message: message ?? this.message,
      culture: culture ?? this.culture,
    );
  }
}
