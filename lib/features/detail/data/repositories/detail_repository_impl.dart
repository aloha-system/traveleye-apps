import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_remote_datasource.dart';
import '../models/destination_detail_model.dart';

class DetailRepositoryImpl implements DetailRepository {
  final DetailRemoteDatasource remote;

  DetailRepositoryImpl(this.remote);

  @override
  Future<DestinationDetailModel> getDetail(String id) async {
    return await remote.getById(id);
  }
}
