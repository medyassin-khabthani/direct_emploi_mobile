import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({required this.email, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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

  void _resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New passwords do not match')));
      return;
    }

    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.resetPassword(widget.email, codeController.text, newPasswordController.text);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Password reset successfully')));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Failed to reset password')));
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
          "Reset Password",
          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              DETextField(
                controller: codeController,
                labelText: "Verification Code",
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
                labelText: "New Password",
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
                labelText: "Confirm New Password",
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
          ),
        ),
      ),
    );
  }
}
