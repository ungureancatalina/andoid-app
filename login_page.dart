import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For File
import 'package:mood_tracker/save_load.dart';
import 'start_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  List<List<dynamic>> _userData = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await loadUserData();
    setState(() {
      _userData = userData;
    });
  }

  Future<void> _createUserFile(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$email.txt';

    // Create a new file and write the email address into it
    File file = File(filePath);
    await file.writeAsString('User Email: $email\n');
    print('File created: $filePath');
  }

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_formKey.currentState!.validate()) {
      bool userExists = false;
      for (var user in _userData) {
        if (user.isNotEmpty && user[0] == email) {
          userExists = true;
          if (user[1] == password) {
            // Create a file for the user
            _createUserFile(email);

            // Pass the user email to StartPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StartPage(userEmail: email)),
            );
          } else {
            setState(() {
              _errorMessage = 'Incorrect password';
            });
          }
          break;
        }
      }
      if (!userExists) {
        setState(() {
          _errorMessage = 'Email not found';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: veryDarkGreen,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imag1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Progress(),
                  SizedBox(height: 50.0),
                  Text(
                    'Enter your log in details:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                        return 'Password must contain digits, uppercase and lowercase letters';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    SizedBox(height: 10.0),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(veryDarkGreen),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 300.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Text(
          'We are trying to help you understand your emotions better',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        LinearProgressIndicator(value: 0.0),
        SizedBox(height: 20.0),
      ],
    );
  }
}