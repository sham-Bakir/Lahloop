import 'package:advapp/app/app_prefs.dart';
import 'package:advapp/app/dependency_injection.dart';
import 'package:advapp/data/repository/repository_impl.dart';
import 'package:advapp/domain/repository/repository.dart';
import 'package:advapp/domain/usecase/login_usecase.dart';
import 'package:advapp/presentation/common/state_renderer_impl.dart';
import 'package:advapp/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advapp/presentation/resources/assets_manager.dart';
import 'package:advapp/presentation/resources/color_manager.dart';
import 'package:advapp/presentation/resources/routes_manager.dart';
import 'package:advapp/presentation/resources/strings_manager.dart';
import 'package:advapp/presentation/resources/value_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _viewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
    _viewModel.start();
    _phoneNumberController.addListener(
        () => _viewModel.setPhoneNumber(_phoneNumberController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
        padding: const EdgeInsets.only(top: AppPadding.p40),
        color: ColorManager.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                    child: Image(
                  image: AssetImage(ImageAssets.splashLogo),
                  height: 250,
                  width: 250,
                )),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p20, right: AppPadding.p20),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outIsPhoneNumberValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                              hintText: AppStrings.phoneNumber,
                              labelText: AppStrings.phoneNumber,
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.phoneNumberError),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p16, right: AppPadding.p16),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outIsPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              hintText: AppStrings.password,
                              labelText: AppStrings.password,
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.passwordError),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p16, right: AppPadding.p16),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outAreAllDataValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _viewModel.login();
                                  }
                                : null,
                            child: Text(AppStrings.login),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p16,
                      right: AppPadding.p16,
                      top: AppPadding.p8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.forgetPasswordRoute);
                          },
                          child: Text(
                            AppStrings.forgetPassword,
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.registerRoute);
                          },
                          child: Text(
                            AppStrings.registerText,
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
