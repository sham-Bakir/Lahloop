// Flow of states
// loading -> content -> error ..etc
import 'package:advapp/app/constants.dart';
import 'package:advapp/presentation/resources/strings_manager.dart';
import 'package:advapp/presentation/state_renderer/state_renderer.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// Loading (Popup or Full screen)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;
  LoadingState(
      {required this.stateRendererType, String message = AppStrings.loading});
  @override
  String getMessage() => message ?? AppStrings.loading;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Error (Popup or Full screen)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  ErrorState({required this.stateRendererType, required this.message});
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Content State (Full screen)
class ContentState extends FlowState {
  ContentState();
  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

// Empty (Popup or Full screen)
class EmptyState extends FlowState {
  String message;
  EmptyState({required this.message});
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

extension FlowStateExtinsion on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // Show popup loading
            showPopUp(context, getStateRendererType(), getMessage());
            // Show content ui of the screen
            return contentScreenWidget;
          } else {
            return StateRenderer(
              message: getMessage(),
              stateRendererType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            // Show popup error
            showPopUp(context, getStateRendererType(), getMessage());
            // Show content ui of the screen
            return contentScreenWidget;
          } else {
            return StateRenderer(
              message: getMessage(),
              stateRendererType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: () {});
        }
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }

  _isCurrentDialogShowingUp(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowingUp(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            retryActionFunction: () {})));
  }
}
