import 'package:advapp/data/network/app_api.dart';
import 'package:advapp/data/network/requests.dart';
import 'package:advapp/data/response/responses.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  // I have to receive an authentication response to convert it to an authentication object
}

class RemoteDataSourceImpl implements RemoteDataSource {
  AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.email, loginRequest.password);
  }
}
