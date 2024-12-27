import 'dart:async';

import 'package:advapp/presentation/common/state_renderer_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    implements BaseViewModelOutputs {
  // shared variables and functions that will be used through any view model.
  // any view model should have input and output (requist and response).
  final StreamController _inputStreamController =
      StreamController<FlowState>.broadcast();

  @override
  // TODO: implement inputState
  Sink get inputState => _inputStreamController.sink;

  @override
  // TODO: implement outputState
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  void start(); // Start ViewModel job
  void dispose(); // Will be called when ViewModel dies.
  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
