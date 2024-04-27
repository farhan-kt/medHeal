import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:medheal/widgets/text_widgets.dart';
import 'package:medheal/widgets/snackbar_widget.dart';
import 'package:medheal/widgets/textformfield_widget.dart';
import 'package:medheal/view/user/authentication/sign_in.dart';
import 'package:medheal/controller/authentication_provider.dart';
import 'package:medheal/view/user/authentication/fill_profile.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: poppinsText(
                          text: 'Sign In',
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1995AD)))
                ],
              ),
              SizedBox(height: size.height * .04),
              SizedBox(
                width: size.width * .6,
                height: size.height * .15,
                child: poppinsText(
                    text: 'Create Your Account',
                    fontSize: 34,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: size.height * .02),
              SizedBox(
                height: size.height * .42,
                width: size.width * .9,
                child: Form(
                  key: authProvider.createAccountFormkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextFormField(
                        controller: authProvider.userNameController,
                        hintText: 'User Name',
                        validateMessage: 'Enter User Name',
                      ),
                      CustomTextFormField(
                        controller: authProvider.emailController,
                        hintText: 'Email',
                        validateMessage: 'Enter Email',
                      ),
                      CustomTextFormField(
                        controller: authProvider.passwordController,
                        hintText: 'Password',
                        suffixIcon: const Icon(EneftyIcons.eye_outline),
                        validateMessage: 'Enter password',
                      ),
                      CustomTextFormField(
                        controller: authProvider.confirmPasswordController,
                        hintText: 'Confirm Password',
                        suffixIcon: const Icon(EneftyIcons.eye_outline),
                        validateMessage: 'Renter Password',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .02),
              SizedBox(
                width: size.width * .9,
                height: size.height * .058,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1995AD),
                    ),
                    onPressed: () {
                      if (authProvider.createAccountFormkey.currentState!
                          .validate()) {
                        try {
                          if (authProvider.emailController.text == 'medHeal') {
                            SnackBarWidget()
                                .showErrorSnackbar(context, 'adminKey');
                          } else if (authProvider.passwordController.text ==
                              authProvider.confirmPasswordController.text) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FillProfileScreen()),
                                (route) => false);
                            authProvider.clearAccountCreateControllers();
                            SnackBarWidget().showSuccessSnackbar(
                                context, 'Account created successfully');
                          } else {
                            SnackBarWidget().showErrorSnackbar(
                                context, 'Passwords do not match');
                          }
                        } catch (error) {
                          SnackBarWidget().showErrorSnackbar(context,
                              'Email address already exists or is invalid');
                        }
                      }
                    },
                    child: poppinsText(
                        text: 'CREATE ACCOUNT',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: size.height * .02),
              Row(children: [
                const Flexible(child: Divider(thickness: 1)),
                poppinsText(
                    text: '  or create with  ',
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                const Flexible(child: Divider(thickness: 1))
              ]),
              SizedBox(height: size.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * .065,
                    width: size.width * .2,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 199, 212, 226)),
                        borderRadius: BorderRadius.circular(18)),
                    child: Transform.scale(
                      scale: 0.5,
                      child: Image.network(
                        'https://cdn.iconscout.com/icon/free/png-256/free-google-1772223-1507807.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * .1),
                  Container(
                    height: size.height * .065,
                    width: size.width * .2,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 199, 212, 226)),
                        borderRadius: BorderRadius.circular(18)),
                    child: Transform.scale(
                      scale: 0.55,
                      child: Image.network(
                        'https://cdn-icons-png.freepik.com/256/100/100313.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
