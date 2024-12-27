import 'package:advapp/data/network/failure.dart';
import 'package:dio/dio.dart';

class ErrorHandler implements Exception {
  late Failure failure;
  ErrorHandler.handle(dynamic error) {
    if (error is DioException) // DioError in the old version
    {
      // Dio error so its an error from response of the API or from dio itself.
      failure = _handleError(error);
    } else {
      // Default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.unknown:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(Responsecode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(Responsecode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(Responsecode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(Responsecode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return Failure(Responsecode.UNAUTORISED, ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return Failure(Responsecode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(Responsecode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            Responsecode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(Responsecode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            Responsecode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(Responsecode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(Responsecode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(Responsecode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(Responsecode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class Responsecode {
  static const int SUCCESS = 200; // Success with data
  static const int NO_CONTENT = 201; // Success with no data (no content)
  static const int BAD_REQUEST = 400; // Failure, API rejected request
  static const int FORBIDDEN = 403; // Failure, API rejected request
  static const int UNAUTORISED = 401; // Failure, user is not authorised
  static const int INTERNAL_SERVER_ERROR = 200; // Failure, crash in server side
  static const int NOT_FOUND = 404; // Failure, not found

  // Local status code

  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

// Just in case the back-end sent the code without a message.
class ResponseMessage {
  static const String SUCCESS = "Success"; // Success with data
  static const String NO_CONTENT =
      "Success"; // Success with no data (no content)
  static const String BAD_REQUEST =
      "Bad request, try again later"; // Failure, API rejected request
  static const String FORBIDDEN =
      "Forbidden request, try again later"; // Failure, API rejected request
  static const String UNAUTORISED =
      "User is unauthorised, try again later"; // Failure, user is not authorised
  static const String INTERNAL_SERVER_ERROR =
      "Something went wrong, try again later"; // Failure, crash in server side
  static const String NOT_FOUND = "Something went wrong, try again later";

  // Local status code
  static const String CONNECT_TIMEOUT = "Time out error, try again later";
  static const String CANCEL = "Request was cancelled, try again later";
  static const String RECIEVE_TIMEOUT = "Time out error, try again later";
  static const String SEND_TIMEOUT = "Time out error, try again later";
  static const String CACHE_ERROR = "Crashe error, try again later";
  static const String NO_INTERNET_CONNECTION =
      "Please check your internet connection";
  static const String DEFAULT = "Something went wrong, try again later";
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
