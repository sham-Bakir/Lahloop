import 'package:advapp/data/network/failure.dart';
import 'package:advapp/data/network/requests.dart';
import 'package:advapp/domain/model/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(
      LoginRequest
          loginRequest); // Authentication means right && Failure means left
}
