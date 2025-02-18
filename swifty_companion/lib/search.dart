import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swifty_companion/main.dart';
import 'package:http/http.dart' as http;

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getUserData(String login) async {
    String? accessToken = await getAccessToken();
    debugPrint(accessToken);
    if (accessToken == null) {
      // TODO
      debugPrint("❌ No access token. Cannot fetch data.");
      return null;
    }

    final url = 'https://api.intra.42.fr/v2/users/$login';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // TODO
      debugPrint("❌ Failed to fetch data: ${response.statusCode}");
      return null;
    }
  }

  void navigateToProfile() async {
    Map<String, dynamic>? data = await getUserData(_controller.text);

    if (mounted) {
      Navigator.pushNamed(context, '/profile', arguments: data);
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.12,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/42_Logo.png',
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "Enter a login to show data:",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: 'Login',
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: _hasText
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                setState(() {
                                  _hasText = false;
                                });
                              },
                            )
                          : null,
                    ),
                    autocorrect: false,
                    maxLength: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty<Color>.fromMap(
                          <WidgetStatesConstraint, Color>{
                            WidgetState.pressed | WidgetState.hovered:
                                Colors.indigo,
                            WidgetState.any:
                                _hasText ? Colors.white : Colors.white70,
                          },
                        ),
                      ),
                      onPressed: navigateToProfile,
                      child: Text("Search"),
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
