import 'package:advapp/presentation/resources/assets_manager.dart';
import 'package:advapp/presentation/resources/color_manager.dart';
import 'package:advapp/presentation/resources/font_manager.dart';
import 'package:advapp/presentation/resources/strings_manager.dart';
import 'package:advapp/presentation/resources/styles_manager.dart';
import 'package:advapp/presentation/resources/value_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StateRendererType {
  // Popup State (Dialog)
  popupLoadingState,
  popupErrorState,

  // Full Screen state (Full Screen)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // General
  contentState
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;

  StateRenderer(
      {required this.stateRendererType,
      this.message = AppStrings.loading,
      this.title = "",
      required this.retryActionFunction});

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopUpDialog(
            context, [_getAnimatedImage(JsonAssets.laoding)]);

      case StateRendererType.popupErrorState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.ok, context)
        ]);

      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn(
            [_getAnimatedImage(JsonAssets.laoding), _getMessage(message)]);

      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retry, context)
        ]);

      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn(
            [_getAnimatedImage(JsonAssets.empty), _getMessage(message)]);

      case StateRendererType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSize.s14),
            boxShadow: [BoxShadow(color: Colors.black26)]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
        height: AppSize.s100,
        width: AppSize.s100,
        child: Lottie.asset(animationName));
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s18),
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (stateRendererType ==
                      StateRendererType.fullScreenErrorState) {
                    // Call retry function
                    retryActionFunction.call();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(buttonTitle))),
      ),
    );
  }
}
// State Renderer Implementer : the connection between the view an the state renderer
