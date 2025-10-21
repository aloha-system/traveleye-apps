import 'package:boole_apps/features/culture/domain/entities/culture_entities/culture_entity.dart';
import 'package:boole_apps/features/culture/domain/usecases/get_culture_by_id_usecase.dart';
import 'package:boole_apps/features/culture/domain/usecases/get_culture_usecase.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_state.dart';
import 'package:flutter/material.dart';

class CultureProvider extends ChangeNotifier {
  final GetCultureUsecase getCultureUsecase;
  final GetCultureByIdUsecase getCultureByIdUsecase;

  CultureProvider({
    required this.getCultureUsecase,
    required this.getCultureByIdUsecase,
  });

  CultureState _state = CultureState();
  CultureState get state => _state;

  List<Culture>? _cultureList;
  List<Culture>? get cultureList => _cultureList;

  Culture? _cultureDetail;
  Culture? get cultureDetail => _cultureDetail;

  // get culture list trigger method
  Future<void> getCulture() async {
    _state = _state.copyWith(status: CultureStatus.loading);
    notifyListeners();

    try {
      _cultureList = await getCultureUsecase.call();
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

  // get culture detail trigger method
  Future<void> getCultureDetail(String id) async {
    _state = _state.copyWith(status: CultureStatus.loading);
    notifyListeners();

    try {
      _cultureDetail = await getCultureByIdUsecase.call(id);

      if (_cultureDetail == null) {
        _state = _state.copyWith(
          status: CultureStatus.error,
          message: 'Not Found (404): Detail Not Found',
        );
        return;
      }

      _state = _state.copyWith(status: CultureStatus.success);
    } catch (e) {
      _state = _state.copyWith(
        status: CultureStatus.error,
        message: 'Unexpected Error: $e',
      );
    } finally {
      notifyListeners();
    }
  }
  
}
