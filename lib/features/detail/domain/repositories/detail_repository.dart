import '../../data/models/destination_detail_model.dart';

abstract class DetailRepository {
  Future<DestinationDetailModel> getDetail(String id);
}
