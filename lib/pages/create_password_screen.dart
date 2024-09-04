import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/de_back_button.dart';
import '../helper/de_text_field.dart';
import '../helper/style.dart';
import '../viewmodels/profile_view_model.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
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

  Future<void> _createPassword() async {
    if (passwordController.text != confirmationPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await viewModel.setPassword(passwordController.text);

    if (viewModel.isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur lors de la création du mot de passe')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mot de passe défini avec succès')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        leading: DEBackButton(),
        title: Text(
          "Création du mot de passe",
          style: TextStyle(
              fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
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
                controller: passwordController,
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                  onPressed: _togglePasswordVisibility,
                ),
                obscureText: !_isPasswordVisible,
                prefixIcon: Icons.lock,
                labelText: "Mot de passe",
              ),
              const SizedBox(height: 20),
              DETextField(
                controller: confirmationPasswordController,
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
                obscureText: !_isConfirmPasswordVisible,
                prefixIcon: Icons.lock,
                labelText: "Confirmation Mot de passe",
              ),
              const SizedBox(height: 30),
              Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
                  return ElevatedButton(
                    style: appButton(),
                    onPressed:viewModel.isLoading ? null : _createPassword,
                    child:viewModel.isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text("Créer mon mot de passe"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
