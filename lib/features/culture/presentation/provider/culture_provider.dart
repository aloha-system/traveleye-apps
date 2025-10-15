import 'package:boole_apps/features/culture/domain/entities/culture_entity.dart';
import 'package:boole_apps/features/culture/domain/usecases/get_culture_usecase.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_state.dart';
import 'package:flutter/material.dart';

class CultureProvider extends ChangeNotifier {
  final GetCultureUsecase getCultureUsecase;

  CultureProvider({required this.getCultureUsecase});

  CultureState _state = CultureState();
  CultureState get state => _state;

  List<Culture>? _culture;
  List<Culture>? get culture => _culture;

  // get culture trigger method
  Future<void> getCulture() async {
    _state = _state.copyWith(status: CultureStatus.loading);
    notifyListeners();

    try {
      _culture = await getCultureUsecase.call();
      _state = _state.copyWith(status: CultureStatus.success);
    } catch (e) {
      _state = _state.copyWith(
        status: CultureStatus.error,
        message: e.toString(),
      );
    } finally {
      notifyListeners();
    }
  }
}
