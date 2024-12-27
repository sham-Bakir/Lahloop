import 'package:advapp/data/network/failure.dart';
import 'package:advapp/data/network/requests.dart';
import 'package:advapp/domain/model/models.dart';
import 'package:advapp/domain/repository/repository.dart';
import 'package:advapp/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUsecase<LoginUseCaseInput, Authentication> {
  Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository
        .login(LoginRequest(input.phoneNumber, input.password));
  }
}

class LoginUseCaseInput {
  String phoneNumber;
  String password;
  LoginUseCaseInput(this.phoneNumber, this.password);
}
