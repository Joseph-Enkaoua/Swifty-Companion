import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swifty_companion/profile.dart';
import 'package:swifty_companion/search.dart';
import 'package:google_fonts/google_fonts.dart';

final _storage = FlutterSecureStorage();

const String tokenUrl = "https://api.intra.42.fr/oauth/token";

// Get the stored token, or request a new one if expired
Future<String?> getAccessToken() async {
  String? token = await _storage.read(key: "access_token");
  String? expiration = await _storage.read(key: "token_expiration");

  if (token != null && expiration != null) {
    DateTime expirationTime = DateTime.parse(expiration);

    if (DateTime.now().isBefore(expirationTime)) {
      debugPrint("✅ Using stored token.");
      return token;
    }
  }

  return await fetchNewToken();
}

/// Request a new token and store it securely
Future<String?> fetchNewToken() async {
  try {
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "grant_type": "client_credentials",
        "client_id": dotenv.get('42UID'),
        "client_secret": dotenv.get('42SECRET'),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String accessToken = data["access_token"];
      int expiresIn = data["expires_in"];

      // Calculate expiration time
      DateTime expirationTime =
          DateTime.now().add(Duration(seconds: expiresIn));

      // Store the token and its expiration securely
      await _storage.write(key: "access_token", value: accessToken);
      await _storage.write(
          key: "token_expiration", value: expirationTime.toIso8601String());

      debugPrint("🔄 New token saved!");
      return accessToken;
    } else {
      // TODO
      debugPrint(
          "❌ Failed to get token: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    // TODO
    debugPrint("Error fetching token: $e");
    return null;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        textTheme: GoogleFonts.libreFranklinTextTheme(),
        useMaterial3: true,
      ),
      home: SearchView(),
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          final List<dynamic> userData = settings.arguments as List<dynamic>;
          return MaterialPageRoute(
            builder: (context) => ProfileView(userData: userData),
          );
        }
        return null;
      },
    );
  }
}
