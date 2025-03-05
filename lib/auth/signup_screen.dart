import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tasks/task_list_screen.dart';
import 'auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(emailController, "Email", Icons.email, false),
              SizedBox(height: 10),
              _buildTextField(passwordController, "Password", Icons.lock, true),
              SizedBox(height: 10),
              _buildTextField(confirmPasswordController, "Confirm Password",
                  Icons.lock, true,
                  isConfirm: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }

                  try {
                    await ref
                        .read(authProvider)
                        .signUp(emailController.text, passwordController.text);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => TaskListScreen()),
                    );
                  } on FirebaseAuthException catch (e) {
                    String errorMessage = "Registration failed";

                    if (e.code == 'email-already-in-use') {
                      errorMessage =
                          "This email is already registered. Please log in.";
                    } else if (e.code == 'weak-password') {
                      errorMessage =
                          "Password is too weak. Use a stronger password.";
                    } else if (e.code == 'invalid-email') {
                      errorMessage = "Invalid email format.";
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("An unexpected error occurred.")),
                    );
                  }
                },
                child: Text(
                  "Register",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool isPassword,
      {bool isConfirm = false}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(isConfirm
                      ? (isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : (isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  onPressed: () {
                    setState(() {
                      if (isConfirm) {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      } else {
                        isPasswordVisible = !isPasswordVisible;
                      }
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        obscureText: isPassword
            ? (isConfirm ? !isConfirmPasswordVisible : !isPasswordVisible)
            : false,
      ),
    );
  }
}
