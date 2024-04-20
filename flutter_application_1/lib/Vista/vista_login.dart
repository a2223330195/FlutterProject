import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_management_app/sign_in.dart';
import 'package:school_management_app/first_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_management_app/Vista/vista_clases.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:school_management_app/Vista/vista_principal.dart';
import 'package:school_management_app/Controlador/controlador_authservice.dart';

class VistaLogin extends StatefulWidget {
  const VistaLogin({super.key});

  @override
  VistaLoginState createState() => VistaLoginState();
}

class VistaLoginState extends State<VistaLogin> {
  final AuthService _authService = AuthService();
  bool _isRed = true;
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _email = '';
  // ignore: unused_field
  String _password = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  void changeColor() {
    setState(() {
      _isRed = !_isRed;
    });
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? error = (await _authService.signIn(_email, _password)) as String?;
      if (error != null) {
        showErrorSnackBar(error);
      } else {
        await saveLoginStateAndNavigate(const VistaClases());
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        if (mounted) {
          await saveLoginStateAndNavigate(const VistaClases());
        }
      } else {
        if (mounted) {
          showErrorSnackBar('Error al iniciar sesión con Google');
        }
      }
    } catch (error) {
      logger.log(Level.SEVERE, 'Error en signInWithGoogle: $error');
      if (mounted) {
        showErrorSnackBar('Error al iniciar sesión con Google');
      }
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        if (mounted) {
          await saveLoginStateAndNavigate(const HomePage());
        }
      } else {
        if (mounted) {
          showErrorSnackBar('Error al iniciar sesión con Facebook');
        }
      }
    } catch (error) {
      if (mounted) {
        showErrorSnackBar('Error al iniciar sesión con Facebook');
      }
    }
  }

  Future<void> saveLoginStateAndNavigate(Widget page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        flexibleSpace: Container(
          color: Colors.red,
          child: Image.asset(
            'lib/assets/imagen/imagen01.jpg',
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bienvenido!',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff384B70),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email'),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Password'),
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                  suffixIcon: Icon(
                    Icons.visibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Passowrd?',
                    style: TextStyle(
                      color: Color(0xffFFA851),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xffFF8100),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    signInWithGoogle().whenComplete(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const FirstScreen();
                          },
                        ),
                      );
                    });
                  },
                  child: const Text('Sign in with Google'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signInWithFacebook,
                  child: const Text('Sign in with Facebook'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xffFFA851),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: IconButton(
                  icon: const Icon(
                    Icons.home,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                secondChild: const Icon(
                  Icons.lock,
                  size: 40,
                ),
                duration: const Duration(seconds: 1),
                crossFadeState: _isRed
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
