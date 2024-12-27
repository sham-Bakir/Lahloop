import 'package:advapp/app/app_prefs.dart';
import 'package:advapp/data/data_source/remote_data_source.dart';
import 'package:advapp/data/network/app_api.dart';
import 'package:advapp/data/network/dio_factory.dart';
import 'package:advapp/data/network/network_info.dart';
import 'package:advapp/data/repository/repository_impl.dart';
import 'package:advapp/domain/repository/repository.dart';
import 'package:advapp/domain/usecase/login_usecase.dart';
import 'package:advapp/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advapp/data/network/network_info.dart';

// final instance = GetIt.instance;

// Future<void> initAppModule() async {
//   // app module, it is a module where we put all the generic dependensies.
//   final sharedPrefs = await SharedPreferences.getInstance();
//   instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

//   // App prefs instance

//   instance.registerLazySingleton<AppPreferences>(
//       () => AppPreferences(instance<SharedPreferences>()));

//   // Network info
//   instance.registerLazySingleton<NetworkInfo>(
//       () => NetworkInfoImpl(InternetConnectionChecker.createInstance()));
//   // ***********

//   // Dio factory
//   instance.registerCachedFactory<DioFactory>(() => DioFactory(instance()));

//   Dio dio = await instance<DioFactory>().getDio();

//   // App service client
//   instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

//   // Remote data source
//   instance.registerLazySingleton<RemoteDataSource>(
//       () => RemoteDataSourceImpl(instance<AppServiceClient>()));

//   // Repository
//   instance.registerLazySingleton<Repository>(
//       () => RepositoryImpl(instance(), instance()));
// }

// initLoginModule() {
//   if (!GetIt.I.isRegistered<LoginUseCase>()) {
//     instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
//     instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
//   }
// }
final instance = GetIt.instance;

Future<void> initAppModule() async {
  // App module: register generic dependencies
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // App preferences
  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance<SharedPreferences>()));

  // Network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker.createInstance()));

  // Dio factory
  instance.registerLazySingleton<DioFactory>(
      () => DioFactory(instance<AppPreferences>()));

  Dio dio = await instance<DioFactory>().getDio();

  // App service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // Remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // Repository
  instance.registerLazySingleton<Repository>(() =>
      RepositoryImpl(instance<RemoteDataSource>(), instance<NetworkInfo>()));
}

void initLoginModule() {
  // Login module: register use-case and ViewModel
  if (!instance.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(
        () => LoginUseCase(instance<Repository>()));
    instance.registerFactory<LoginViewModel>(
        () => LoginViewModel(instance<LoginUseCase>()));
  }
}
