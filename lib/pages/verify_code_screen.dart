import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';
import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  void _verifyResetCode() async {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final response = await profileViewModel.verifyResetCode(emailController.text, codeController.text);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Code verified successfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: emailController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'] ?? 'Failed to verify code')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Text(
          "Verify Code",
          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'semi-bold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              DETextField(
                controller: emailController,
                labelText: "Email",
              ),
              const SizedBox(height: 20),
              DETextField(
                controller: codeController,
                labelText: "Verification Code",
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _verifyResetCode,
                style: appButton(),
                child: Text("Verify Code"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
