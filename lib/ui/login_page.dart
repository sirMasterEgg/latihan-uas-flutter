import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:latihanuas/config/firebase_auth_config.dart';
import 'package:latihanuas/ui/home_page.dart';
import 'package:latihanuas/ui/register_page.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthConfig();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  void checkAuth() {
    if (_auth.user != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // tempat panggil provider

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Login Page', style: TextStyle(fontSize: 24)),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                controller: _emailController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final user = await _auth.signIn(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (user != null) {
                      Navigator.of(context).pushNamed(HomePage.routeName);
                      return;
                    }
                  }
                 on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid email or password'),
                      ),
                    );
                  }

                },
                child: const Text('LOGIN'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterPage.routeName);
                },
                child: const Text('GO TO REGISTER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
