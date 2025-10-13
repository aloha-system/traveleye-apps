import 'package:boole_apps/features/detail/data/models/destination_detail_model.dart';
import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_destination_detail_usecase.dart';

class DetailNotifier extends ChangeNotifier {
  final GetDestinationDetailUsecase getDetail;

  bool loading = false;
  String? error;
  DestinationDetailModel? data;

  DetailNotifier({required this.getDetail});

  Future<void> fetch(String id) async {
    loading = true;
    error = null;
    data = null;
    notifyListeners();

    try {
      data = await getDetail(id);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
