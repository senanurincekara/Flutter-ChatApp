import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/Widgets/customTextField.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7D8E2),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height -
                      MediaQuery.sizeOf(context).height / 1.6,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/gif.gif"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 0,
                top: 280,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 249, 191, 210),
                          blurRadius: 2,
                          offset: Offset(-2, -2),
                          spreadRadius: 0.5),
                    ],
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: MediaQuery.sizeOf(context).width / 2 - 150,
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image(image: AssetImage("assets/images/img.png")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 342.0),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height / 1.2,
                    color: Colors.transparent,
                    child: (Stack(
                      children: [
                        Positioned(
                          top: 50,
                          left: MediaQuery.sizeOf(context).width / 2 - 150,
                          child: Container(
                            width: 300,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xFFFFB8CE),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF85486b),
                                    blurRadius: 2,
                                    offset: Offset(3, 2),
                                    spreadRadius: 0.1),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: CustomFormField(
                                controller: _emailController,
                                hintText: "Enter your email",
                                obscureText: false,
                                onSaved: (value) {
                                  _email = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: MediaQuery.sizeOf(context).width / 2 - 160,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF85486b),
                                    blurRadius: 1,
                                    offset: Offset(-1, -1),
                                    spreadRadius: 0.1),
                              ],
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Center(
                              child: Image(
                                image: AssetImage("assets/images/icon.png"),
                                width: 65,
                                height: 65,
                              ),
                            ),
                          ),
                        ),
                        //password
                        Positioned(
                          top: 150,
                          left: MediaQuery.sizeOf(context).width / 2 - 150,
                          child: Container(
                            width: 300,
                            height: 60,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF85486b),
                                    blurRadius: 2,
                                    offset: Offset(3, 2),
                                    spreadRadius: 0.1),
                              ],
                              shape: BoxShape.rectangle,
                              color: Color(0xFFFFB8CE),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5),
                              child: CustomFormField(
                                controller: _passwordController,
                                hintText: "Enter your password",
                                obscureText: true,
                                onSaved: (value) {
                                  _password = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 140,
                          left: MediaQuery.sizeOf(context).width / 2 - 160,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF85486b),
                                    blurRadius: 1,
                                    offset: Offset(-1, -1),
                                    spreadRadius: 0.1),
                              ],
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Center(
                              child: Image(
                                image: AssetImage("assets/images/icon.png"),
                                width: 65,
                                height: 65,
                              ),
                            ),
                          ),
                        ),
                        //text
                        Positioned(
                          top: 250,
                          left: 75,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Don't you have an account?"),
                                  GestureDetector(
                                      onTap: () {
                                        _navigationService
                                            .pushNamed("/register");
                                      },
                                      child: Text(" Sign up here!")),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFFB8CE),
                                    side: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 177, 104, 146),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                      20,
                                    ))),
                                onPressed: _submitForm,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF85486b),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await _authService.login(_email!, _password!);
      if (success) {
        _navigationService.pushReplacementNamed("/home");
      } else {
        _alertService.showToast(
            text: "Failed to login! Try again", icon: Icons.error);
      }
    }
  }
}
