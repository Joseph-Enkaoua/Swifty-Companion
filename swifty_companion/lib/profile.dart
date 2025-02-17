import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.login});

  final String login;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.filled(color: Colors.white, child: Text(login)),
    );
  }
}
