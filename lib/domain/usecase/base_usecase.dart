import 'package:advapp/data/network/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BaseUsecase<In, Out> {
  // In -> it's for data layer (when you enter the login info) && Out -> it's for presentation layer to show the result
  Future<Either<Failure, Out>> execute(In input);
}
