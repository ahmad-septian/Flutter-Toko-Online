import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toko_online_uas_1/widgets/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import '../page/profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio); // Constructor to accept a Dio instance

  Future<dynamic> registerUser(Map<String, dynamic> userData) async {
    try {
      print("Sending request data: $userData"); // Log the request data

      Response response = await _dio.post(
        'https://api.solusidigitalunity.com/api/register', // ENDPOINT URL
        data: userData, // REQUEST BODY
        options: Options(
          headers: {'Accept': 'application/json'}, //HEADERS
        ),
      );

      print("Response data: ${response.data}"); // Log the response data
      // Return the successful JSON object
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        // Custom handling for status code 422
        return {
          'Message': 'Email Sudah Ada, Silahkan Ganti Menggunakan Email Lain.'
        };
      }
      // Log the error
      print("Error occurred: ${e.response?.data ?? e.message}");
      // Return the error object if there is one
      return e.response?.data ?? {'Message': 'An error occurred'};
    }
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio _dio = Dio();

  void showErrorDialog(BuildContext context, String message) {
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    height: 150, // Ubah ukuran sesuai kebutuhan Anda
                  ),
                  SizedBox(height: 20),
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
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) => Validator.validateName(value ?? ''),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) => Validator.validateEmail(value ?? ''),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        Validator.validatePassword(value ?? ''),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          var apiClient = ApiClient(Dio());
                          var response = await apiClient.registerUser({
                            "name": nameController.text,
                            "email": emailController.text,
                            "password": passwordController.text,
                          });

                          if (response['Message'] != null) {
                            showErrorDialog(context, response['Message']);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Success"),
                                  content:
                                      const Text("Registration Successful"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } catch (e) {
                          showErrorDialog(context, 'Failed to register');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 2, 175, 91),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(child: Text('Register')),
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
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('already have an account? '),
                        Text(
                          'Sign in.',
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
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Show snackbar to indicate loading
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      // The user data to be sent
      Map<String, dynamic> userData = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      };

      // Get response from ApiClient
      dynamic res = await ApiClient(_dio).registerUser(userData);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Check if there is no error in the response body
      if (res['ErrorCode'] == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        // If error is present, display a snackbar showing the error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['Message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }
}

class Validator {
  static String? validateName(String value) {
    if (value.length < 3) {
      return 'Nama Terlalu Pendek';
    } else {
      return null;
    }
  }

  static String? validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return 'Format Email Salah.';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password Tidak Boleh Kosong";
    }
    // Add more password validation logic if needed
    return null;
  }
}

// class ApiClient {
//   final Dio _dio;

//   ApiClient(this._dio); // Constructor to accept a Dio instance

//   Future<dynamic> registerUser(Map<String, dynamic> userData) async {
//     try {
//       print("Sending request data: $userData"); // Log the request data

//       Response response = await _dio.post(
//         'https://api.solusidigitalunity.com/api/register', // ENDPOINT URL
//         data: userData, // REQUEST BODY
//         options: Options(
//           headers: {'Accept': 'application/json'}, //HEADERS
//         ),
//       );

//       print("Response data: ${response.data}"); // Log the response data
//       // Return the successful JSON object
//       return response.data;
//     } on DioError catch (e) {
//       if (e.response?.statusCode == 422) {
//         // Custom handling for status code 422
//         return {'Message': 'The email has already been taken.'};
//       }
//       // Log the error
//       print("Error occurred: ${e.response?.data ?? e.message}");
//       // Return the error object if there is one
//       return e.response?.data ?? {'Message': 'An error occurred'};
//     }
//   }
// }
