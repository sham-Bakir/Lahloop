import 'dart:async';
import 'package:advapp/domain/usecase/login_usecase.dart';
import 'package:advapp/presentation/base/base_viewmodel.dart';
import 'package:advapp/presentation/common/freezed_data_classes.dart';
import 'package:advapp/presentation/common/state_renderer_impl.dart';
import 'package:advapp/presentation/state_renderer/state_renderer.dart';

class LoginViewModel extends BaseViewModel
    implements LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _phoneNumberStreamController = StreamController<
      String>.broadcast(); // broadcast means -> has many listeners : to avoid bad states.
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<String>.broadcast();

  StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  var loginObject =
      LoginObject("", ""); // To remember the login infomation of this user.
  final LoginUseCase _loginUsecase;
  LoginViewModel(this._loginUsecase);

  // Inputs..
  @override
  void dispose() {
    _phoneNumberStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // ViewModel should tell view plaese show content state
    inputState.add(ContentState());
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUsecase.execute(
            LoginUseCaseInput(loginObject.phoneNumber, loginObject.password)))
        .fold(
            (failure) => {
                  inputState.add(ErrorState(
                      stateRendererType: StateRendererType.popupErrorState,
                      message: failure.message))
                }, (data) {
      // content
      inputState.add(ContentState());
      // Navigate to main screen
      isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllDataValid.add("");
  }

  @override
  setPhoneNumber(String phoneNumber) {
    inputPhoneNumber.add(phoneNumber);
    loginObject = loginObject.copyWith(phoneNumber: phoneNumber);
    inputAreAllDataValid.add("");
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputPhoneNumber => _phoneNumberStreamController.sink;
  @override
  Sink get inputAreAllDataValid => _areAllInputsValidStreamController.sink;

  // Outputs..
  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsPhoneNumberValid => _phoneNumberStreamController.stream
      .map((phoneNumber) => _isPhoneNumberValid(phoneNumber));
  @override
  Stream<bool> get outAreAllDataValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isPhoneNumberValid(loginObject.phoneNumber) &&
        _isPasswordValid(loginObject.password);
  }
}

abstract class LoginViewModelInputs {
  setPhoneNumber(String phoneNumber);
  setPassword(String password);
  login();

  Sink get inputPhoneNumber;
  Sink get inputPassword;
  Sink get inputAreAllDataValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsPhoneNumberValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllDataValid;
}
