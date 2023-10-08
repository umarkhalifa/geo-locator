import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:land2/core/failure.dart';
import 'package:land2/core/use_case.dart';
import 'package:land2/features/map/domain/entity/location_point.dart';

import '../repository/map_repository.dart';

class GetFirestorePointUseCase
    extends UseCaseStream<List<LocationPoint>, void> {
  final MapRepository _mapRepository;

  GetFirestorePointUseCase(this._mapRepository);

  @override
  Future<Either<Failure, List<LocationPoint>>> call(void params) async {
    return _mapRepository.watchPoint();
  }
}
final getFirestorePointsUseCaseProvider = Provider((ref) {
  final repo = ref.read(mapRepositoryProvider);
  return GetFirestorePointUseCase(repo);
});
