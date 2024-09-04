import 'package:direct_emploi/pages/first_signup_screen.dart';
import 'package:direct_emploi/pages/forgot_password_screen.dart';
import 'package:direct_emploi/pages/signup_screen.dart';
import 'package:direct_emploi/pages/tabbar_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/de_text_field.dart';
import '../helper/style.dart';
import '../viewmodels/signup_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String pageId = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _login() async {
    if (passwordController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);
    bool success = await signupViewModel.login(emailController.text, passwordController.text);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TabBarScreen()),
      );
    } else {
      // Handle login error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur lors de l\'authentification'),
          content: Text(signupViewModel.error ?? 'Une erreur est survenue'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: strokeColor, width: 1),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'OU',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: strokeColor, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            RichText(
              text: TextSpan(
                text: "Vous n'avez pas de compte ?",
                style: const TextStyle(
                    color: textColor, fontSize: 14, fontFamily: 'regular'),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Inscrivez-vous',
                    style: const TextStyle(
                        color: appColor,
                        fontSize: 14,
                        fontFamily: 'regular'),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FirstSignupScreen()));
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: headerBackground,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Text(
        'Me connecter',
        style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
      ),
    );
  }

  Widget _buildBody() {
    final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 72, // specify the height
              ),
              const SizedBox(
                height: 60,
              ),
              DETextField(controller: emailController, labelText: "Email"),
              const SizedBox(
                height: 20,
              ),
              DETextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                        !_isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                    onPressed: _togglePasswordVisibility,
                  ),
                  labelText: "Mot de passe"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: appButton(),
                onPressed:signupViewModel.isLoading ? null : _login,
                child:signupViewModel.isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text("Me connecter"),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                            fontSize: 12, fontFamily: 'regular', color: textColor),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
