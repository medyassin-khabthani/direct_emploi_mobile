import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  void _toggleOldPasswordVisibility() {
    setState(() {
      _isOldPasswordVisible = !_isOldPasswordVisible;
    });
  }
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

  void _changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Les deux nouveaux mot de passe ne sont pas identiques.')));
      return;
    }

    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.changePassword(
      oldPasswordController.text,
      newPasswordController.text,
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Mot de passe changé avec succès')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Failed to change password')));
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
          "Modification du mot de passe",
          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              DETextField(
                controller: oldPasswordController,
                suffixIcon: IconButton(
                  icon: Icon(_isOldPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                  onPressed: _toggleOldPasswordVisibility,
                ),
                obscureText: !_isOldPasswordVisible,
                prefixIcon: Icons.lock,
                labelText: "Ancien mot de passe",
              ),
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
                labelText: "Confirmer votre nouveau mot de passe",
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: appButton(),
                onPressed:profileViewModel.isLoading ? null : _changePassword,
                child:profileViewModel.isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text("Changer le mot de passe"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
