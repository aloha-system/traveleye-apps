import 'package:boole_apps/features/destination/domain/entities/cultural_insight.dart';
import 'package:boole_apps/features/destination/domain/usecases/gen_culture_usecase.dart';
import 'package:flutter/material.dart';

enum GenCultureStatus { initial, loading, success, error }

class GenCultureState {
  final GenCultureStatus status;
  final String? message;

  const GenCultureState({this.status = GenCultureStatus.initial, this.message});

  bool get isLoading => status == GenCultureStatus.loading;
  bool get isSuccess => status == GenCultureStatus.success;
  bool get isError => status == GenCultureStatus.error;

  GenCultureState copyWith({GenCultureStatus? status, String? message}) {
    return GenCultureState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class GenCultureProvider extends ChangeNotifier {
  final GenCultureUsecase genCultureUsecase;

  GenCultureProvider({required this.genCultureUsecase});

  GenCultureState _state = GenCultureState();
  GenCultureState get state => _state;

  CulturalInsight? _culturalInsight;
  CulturalInsight? get culturalInsight => _culturalInsight;

  Future<void> generateCulture(String destinationCity) async {
    _state = _state.copyWith(status: GenCultureStatus.loading);
    notifyListeners();

    try {
      _culturalInsight = await genCultureUsecase.call(destinationCity);

      _state = _state.copyWith(status: GenCultureStatus.success);
    } catch (e) {
      _state = _state.copyWith(
        status: GenCultureStatus.error,
        message: e.toString(),
      );
    } finally {
      notifyListeners();
    }
  }
}
