import 'package:advapp/app/constants.dart';
import 'package:advapp/data/response/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl) // we have to pass url to it
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) =
      _AppServiceClient; // {} it's optional

  @POST("path")
  Future<AuthenticationResponse> login(
      @Field("email") String email, @Field("password") String password);
}
