import 'package:advapp/app/app_prefs.dart';
import 'package:advapp/app/constants.dart';
import 'package:advapp/presentation/resources/constants_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  final AppPreferences _appPreferences;
  DioFactory(this._appPreferences);
  Future<Dio> getDio() async {
    Dio dio = Dio();
    String languag = await _appPreferences.getAppLanguage();
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constants.token,
      DEFAULT_LANGUAGE: languag,
    };
    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      receiveTimeout: Duration(milliseconds: Constants.apiTimeOut),
      sendTimeout: Duration(milliseconds: Constants.apiTimeOut),
    );

    if (!kReleaseMode) {
      // It's debug mode so print app logs
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true));
    }
    return dio;
  }
}
