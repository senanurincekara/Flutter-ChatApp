import 'dart:io';
import 'package:chatapp/Widgets/customTextField.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/image_serrvice.dart';
import 'package:chatapp/services/navigation.dart';
import 'package:chatapp/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? selectedImage;

  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? email, password, name;
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
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
                  child:
                      Image(image: AssetImage("assets/images/imgregister.png")),
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
                        //profilePicSelect:

                        Positioned(
                          top: 20,
                          left: 150,
                          child: GestureDetector(
                            onTap: () async {
                              File? file =
                                  await _mediaService.getIamgeFromGallery();
                              if (file != null) {
                                setState(() {
                                  selectedImage = file;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF85486b),
                                      blurRadius: 1,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0.1),
                                ],
                              ),
                              child: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.15,
                                backgroundImage: selectedImage != null
                                    ? FileImage(selectedImage!)
                                    : null,
                                child: selectedImage == null
                                    ? Icon(Icons.photo_camera_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.10)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        //name
                        Positioned(
                          top: 180,
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
                                controller: _nameController,
                                hintText: "Enter your name",
                                obscureText: false,
                                onSaved: (value) {
                                  name = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 170,
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

                        //email:
                        Positioned(
                          top: 280,
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
                                hintText: "Enter your e-mail",
                                obscureText: false,
                                onSaved: (value) {
                                  email = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 270,
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
                          top: 380,
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
                                  password = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 370,
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
                          top: 460,
                          left: 100,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("You have an account?"),
                                  GestureDetector(
                                      onTap: () {
                                        _navigationService.goBack();
                                      },
                                      child: Text(" Sign in here!")),
                                ],
                              ),
                              _isLoading
                                  ? CircularProgressIndicator() // Show loading indicator if _isLoading is true
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFFB8CE),
                                          side: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 177, 104, 146),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                            20,
                                          ))),
                                      onPressed: _submitForm,
                                      child: const Text(
                                        "Register",
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

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      if (selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a profile picture")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      _formKey.currentState?.save();

      bool result = await _authService.signup(email, password);
      if (result) {
        String? profilePicUrl = await _storageService.uploadUserPfp(
          file: selectedImage!,
          uid: _authService.user!.uid,
        );

        if (profilePicUrl != null) {
          await _databaseService.createUserProfile(
            userprofile: userProfile(
              uid: _authService.user!.uid,
              name: name,
              profilePicUrl: profilePicUrl,
            ),
          );

          _alertService.showToast(
            text: "User registered successfully",
            icon: Icons.check,
          );
          _navigationService.goBack();
          _navigationService.pushReplacementNamed("/home");
        }
      } else {
        _alertService.showToast(
          text: "Failed to register , please try again",
          icon: Icons.error,
        );
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
