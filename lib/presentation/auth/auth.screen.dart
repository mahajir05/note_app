import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../domain/core/interfaces/form_utils.dart';
import '../../domain/core/interfaces/snackbar_utils.dart';
import '../../domain/core/validators/validator.dart';
import '../../infrastructure/navigation/routes.dart';
import 'controllers/auth.controller.dart';

class AuthScreen extends GetView<AuthController> {
  AuthScreen({Key? key}) : super(key: key);

  final TextEditingController _emailcontroller = TextEditingController(text: 'admin@email.com');
  final TextEditingController _passwordcontroller = TextEditingController(text: 'admin123');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Form(
            key: _formKey,
            child: BounceInDown(
              duration: const Duration(milliseconds: 1500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome !',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 20.sp,
                          letterSpacing: 2,
                        ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Text(
                    'Sign In To Continue !',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 12.sp, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  FormUtils.textField(
                    hint: 'Email Address',
                    icon: Icons.email,
                    keyboardtype: TextInputType.emailAddress,
                    validator: (value) {
                      return !Validators.isValidEmail(value!) ? 'Enter a valid email' : null;
                    },
                    textEditingController: _emailcontroller,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  FormUtils.textField(
                    hint: 'Password',
                    icon: Icons.lock,
                    keyboardtype: TextInputType.text,
                    obscure: true,
                    validator: (value) {
                      return value!.length < 6 ? "Enter min. 6 characters" : null;
                    },
                    textEditingController: _passwordcontroller,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  FormUtils.button(
                    color: Colors.deepPurple,
                    width: 80.w,
                    title: 'Login',
                    func: () {
                      bool isValidate = _formKey.currentState?.validate() ?? false;
                      if (isValidate) {
                        controller.login(
                          _emailcontroller.text,
                          _passwordcontroller.text,
                          onSuccess: (userId) {
                            Get.offNamed(Routes.HOME, arguments: userId);
                          },
                          onFailed: () {
                            SnackbarUtils.generalSnackbar(
                              title: 'Login Failed',
                              message: 'user not exist',
                              colorText: Colors.red,
                            );
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
