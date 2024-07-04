import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_toko_online_uas_1/widgets/home.dart';
import 'package:flutter_toko_online_uas_1/widgets/register.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../page/profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Jika token ada, langsung navigasi ke ProductListScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductListScreen()),
      );
    }
  }

  Future<void> _login(BuildContext context) async {
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse("https://api.solusidigitalunity.com/api/login"),
        body: {"email": username.text, "password": password.text},
      );

      print(response.body);
      print(response.statusCode);

      final responseData = jsonDecode(response.body); // Decode JSON response

      if (response.statusCode == 200 && responseData['token'] != null) {
        // Simpan token ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);

        // Navigasi ke ProductListScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
        );
      } else {
        _showErrorDialog(context, "Email atau Password tidak sesuai");
      }
    } else {
      _showErrorDialog(context, "Username dan Password tidak boleh kosong");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  height: 150, // Ubah ukuran sesuai kebutuhan Anda
                ),
                Text(
                  'Toko Sayuran ASG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins',
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Phone number, username, or email',
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 2, 175, 91), // Warna tombol utama Instagram
                    foregroundColor: Colors.white, // Warna teks
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Login')),
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Don\'t have an account? '),
                      Text(
                        'Sign up.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
