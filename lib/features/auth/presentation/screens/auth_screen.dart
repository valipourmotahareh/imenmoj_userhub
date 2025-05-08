import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imenmoj_userhub/core/widgets/custom_button.dart';
import 'package:imenmoj_userhub/core/widgets/custom_text_field.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_event.dart';
import 'package:imenmoj_userhub/features/auth/presentation/bloc/auth_state.dart';
import 'package:imenmoj_userhub/features/user/presentation/screens/user_list_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (_isLogin) {
      context.read<AuthBloc>().add(LoginRequested(email, password));
    } else {
      context.read<AuthBloc>().add(
        RegisterRequested(email, password, name, ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UserListScreen()),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isLogin ? 'auth_screen.login'.tr() :  'auth_screen.register'.tr()),
                  const SizedBox(height: 32),
                  if (!_isLogin)
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'auth_screen.name'.tr(),
                    ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'auth_screen.email'.tr(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'auth_screen.password'.tr(),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    CustomButton(
                      text: _isLogin ? 'auth_screen.login'.tr() :  'auth_screen.register'.tr(),
                      onPressed: _submit,
                    ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _isLogin
                          ? 'auth_screen.label_register'.tr()
                          : 'auth_screen.label_login'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
