import 'package:advapp/data/data_source/remote_data_source.dart';
import 'package:advapp/data/mapper/mapper.dart';
import 'package:advapp/data/network/error_handler.dart';
import 'package:advapp/data/network/failure.dart';
import 'package:advapp/data/network/network_info.dart';
import 'package:advapp/data/network/requests.dart';
import 'package:advapp/domain/model/models.dart';
import 'package:advapp/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // It's connected to the internet, so it's safe to call the api
      try {
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          // Success
          // Return either right
          // Return data
          return Right(response.toDomain());
        } else {
          // Failure -- business error
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // Return internet connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
