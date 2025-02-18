import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    // debugPrint("Full userData[0]: ${jsonEncode(userData['cursus_users'])}",
    //     wrapWidth: 1024);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Column(
                      children: [
                        // Profile picture
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: userData['image']['link'] !=
                                        null
                                    ? NetworkImage(userData['image']['link'])
                                    : const AssetImage(
                                            "assets/default-avatar.png")
                                        as ImageProvider,
                                backgroundColor: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['login'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userData['email'],
                                    style: TextStyle(
                                        color: Colors.cyanAccent, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Data - lvl, wallet, eval points
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "Lvl ${userData['cursus_users'][1]['level']}",
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 15)),
                              Text("Wallet ${userData['wallet']}₳",
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 15)),
                              Text(
                                  "Eval. points ${userData['correction_point']}",
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 15)),
                            ],
                          ),
                        ),

                        // Skills
                        Card(
                          color: Colors.transparent,
                          child: Placeholder(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
