import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'app_localizations.dart'; // Removed localization import
import 'home_screen.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  bool _codeSent = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          await _auth.signInWithCredential(credential);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
            _errorMessage = e.message ?? 'Verification failed'; // Provide default message
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: ${e.toString()}'; // Provide default message
      });
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _codeController.text,
      );

      await _auth.signInWithCredential(credential);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid verification code'; // Hardcoded string
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed localizations variable

    return Scaffold(
      appBar: AppBar(
        title: Text('CheaperData'), // Hardcoded string
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                'Welcome!', // Hardcoded string
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              if (!_codeSent) ...[
                Text(
                  'Phone Number', // Hardcoded string
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number', // Hardcoded string
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number'; // Hardcoded string
                    }
                    // Basic validation (can be improved)
                    if (!value.startsWith('+')) {
                      return 'Phone number must start with +country code'; // Hardcoded string
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _verifyPhone();
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Send Verification Code'), // Hardcoded string
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ] else ...[
                Text(
                  'Verification Code', // Hardcoded string
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Enter the 6-digit code', // Hardcoded string
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code'; // Hardcoded string
                    }
                    if (value.length != 6) {
                       return 'Code must be 6 digits'; // Hardcoded string
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _verifyCode();
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Verify & Login'), // Hardcoded string
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

