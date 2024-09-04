import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isCodeSent = false;
  bool _isCodeVerified = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _sendResetCode() async {

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.forgotPassword(emailController.text);

    if (response['success'] == true) {
      setState(() {
        _isCodeSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Code de réinitialisation envoyé avec succès.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Echec lors de l\'envoi de code de réinitialisation.')));
    }
  }

  void _verifyResetCode() async {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.verifyResetCode(emailController.text, codeController.text);
    if (emailController.text.isEmpty || codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }
    if (response['success'] == true) {
      setState(() {
        _isCodeVerified = true;
        _isCodeSent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Code vérifié avec succès.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Echec de verification de code.')));
    }
  }

  void _resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Les deux mots de passe doivent être identiques.')));
      return;
    }

    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.resetPassword(emailController.text, codeController.text, newPasswordController.text);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Mot de passe réinitialisé avec succès.')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Echec lors de réinitialisation du mot de passe.')));
    }
  }

  void _resendResetCode() async {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.forgotPassword(emailController.text);
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Code de réinitialisation renvoyé avec succès.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Echec lors du renvoi du code de réinitialisation')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Text(
          "Mot de passe oublié",
          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              if (!_isCodeVerified) ...[
                DETextField(
                  controller: emailController,
                  labelText: "Email",
                ),
                if (_isCodeSent) ...[
                  const SizedBox(height: 20),
                  DETextField(
                    controller: codeController,
                    labelText: "Code de vérification",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: appButton(),
                    onPressed:profileViewModel.isLoading ? null : _verifyResetCode,
                    child:profileViewModel.isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text("Vérifier le code"),
                  ),
                  TextButton(
                    onPressed:profileViewModel.isLoading ? null : _resendResetCode,
                    child: profileViewModel.isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text("Renvoyer le code"),
                  ),
                ],
                if (!_isCodeSent) ...[
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: appButton(),
                    onPressed:profileViewModel.isLoading ? null : _sendResetCode,
                    child:profileViewModel.isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text("Envoyer le code de réinitialisation"),
                  ),
                ],
              ],
              if (_isCodeVerified) ...[
                const SizedBox(height: 20),
                DETextField(
                  controller: newPasswordController,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                    onPressed: _togglePasswordVisibility,
                  ),
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icons.lock,
                  labelText: "Nouveau mot de passe",
                ),
                const SizedBox(height: 20),
                DETextField(
                  controller: confirmPasswordController,
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  prefixIcon: Icons.lock,
                  labelText: "Confirmer nouveau mot de passe",
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: appButton(),
                  onPressed:profileViewModel.isLoading ? null : _resetPassword,
                  child:profileViewModel.isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text("Réinitialiser le mot de passe"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
