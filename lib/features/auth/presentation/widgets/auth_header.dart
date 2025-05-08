import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text(
          title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
