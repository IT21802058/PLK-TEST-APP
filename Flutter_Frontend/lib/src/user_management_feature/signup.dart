import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../common/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // Track loading state

  // Validation error messages
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();

    // Add listeners for real-time validation
    _firstNameController.addListener(() {
      _validateFirstName();
    });
    _lastNameController.addListener(() {
      _validateLastName();
    });
    _emailController.addListener(() {
      _validateEmail();
    });
    _phoneNoController.addListener(() {
      _validatePhoneNo();
    });
    _passwordController.addListener(() {
      _validatePassword();
    });
    _confirmPasswordController.addListener(() {
      _validateConfirmPassword();
    });
  }

  // Real-time validation functions
  void _validateFirstName() {
    setState(() {
      if (_firstNameController.text.isEmpty ||
          !_firstNameController.text.contains(RegExp(r'^[a-zA-Z]+$'))) {
        _firstNameError = 'Invalid First Name';
      } else {
        _firstNameError = null;
      }
    });
  }

  void _validateLastName() {
    setState(() {
      if (_lastNameController.text.isEmpty ||
          !_lastNameController.text.contains(RegExp(r'^[a-zA-Z]+$'))) {
        _lastNameError = 'Invalid Last Name';
      } else {
        _lastNameError = null;
      }
    });
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty ||
          !_emailController.text.contains(
              RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"))) {
        _emailError = 'Invalid Email';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePhoneNo() {
    setState(() {
      if (_phoneNoController.text.isEmpty ||
          !_phoneNoController.text.contains(RegExp(r'^\d{10}$'))) {
        _phoneError = 'Invalid Phone Number';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Confirm Password is required';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Password mismatch';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  Future<void> _registerUser() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final baseUrl = dotenv.env[Constants.baseURL];
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      body: {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phoneNo': _phoneNoController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
        'userType': 'admin', // UserType hardcoded as "Resident"
      },
    );

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (response.statusCode == 201) {
      // Handle success
      Navigator.pop(context); // Return to the sign-in page
    } else {
      // Handle error
      // You might want to show an error message here
    }
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _validateFirstName();
      _validateLastName();
      _validateEmail();
      _validatePhoneNo();
      _validatePassword();
      _validateConfirmPassword();
    });

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('    Register to PLK TEST APP'),
        backgroundColor:
            const Color.fromARGB(255, 65, 168, 125), // Gray color for AppBar
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/signupbg.png', // Update the path as needed
              fit: BoxFit.cover,
            ),
          ),
          // White box container
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // SIGN UP Heading
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: const Text(
                          '-SIGN UP-',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 79, 102, 124),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          errorText: _firstNameError,
                        ),
                      ),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          errorText: _lastNameError,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _emailError,
                        ),
                      ),
                      TextField(
                        controller: _phoneNoController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          errorText: _phoneError,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                          errorText: _passwordError,
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          errorText: _confirmPasswordError,
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _registerUser,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color.fromARGB(
                              255, 79, 102, 124), // Blue color for button
                        ),
                        child: _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
