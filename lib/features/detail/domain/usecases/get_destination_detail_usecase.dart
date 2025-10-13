import '../../data/models/destination_detail_model.dart';
import '../repositories/detail_repository.dart';

class GetDestinationDetailUsecase {
  final DetailRepository repository;
  GetDestinationDetailUsecase(this.repository);

  Future<DestinationDetailModel> call(String id) async {
    return await repository.getDetail(id);
  }
}
