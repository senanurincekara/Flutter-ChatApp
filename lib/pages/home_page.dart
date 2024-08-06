import 'package:chatapp/Widgets/chat_box.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppbar(context),
            SizedBox(height: 20),
            _chatsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            // alignment: Alignment.topCenter,
            children: [
              Positioned(
                bottom: 4,
                left: 30,
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 80,
                  height: 70,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 175, 108, 146),
                          blurRadius: 0.9,
                          offset: Offset(0, 1),
                          spreadRadius: 0.05),
                    ],
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF85486B)),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Let's Talk!",
                      style: TextStyle(
                        color: Color(0xFF85486B),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.sizeOf(context).width - 150,
                bottom: 1,
                child: Image.asset(
                  "assets/images/homePageIcon.png",
                  width: 110,
                  height: 110,
                ),
              ),
              Positioned(
                right: 0, // Adjust as needed
                top: 40, // Adjust as needed
                child: IconButton(
                  onPressed: () async {
                    bool result = await _authService.logout();
                    if (result) {
                      _alertService.showToast(
                          text: "Successfully logged out!", icon: Icons.check);

                      _navigationService.pushReplacementNamed("/login");
                    }
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  color: Color(0xFF85486B), // Set the color for the icon
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatsList() {
    return Container(
      width: MediaQuery.sizeOf(context).width - 40,
      height: 630, // Adjust height as needed
      decoration: BoxDecoration(
        color: Color.fromRGBO(249, 149, 176, 40 / 100),
        border: Border.all(color: Color(0xFF85486B)),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<userProfile>>(
            stream: _databaseService.getUserProfiles(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Unable to load data: ${snapshot.error}"),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final users = snapshot.data!.docs;
                if (users.isEmpty) {
                  return Center(
                    child: Text("No users found."),
                  );
                }
                return ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    userProfile user = users[index].data();
                    return ChatBox(
                      userprofile: user,
                      onTap: () async {
                        //check the chat is exist or not ?
                        final chatExists = await _databaseService
                            .checkChatExists(_authService.user!.uid, user.uid!);

                        if (!chatExists) {
                          await _databaseService.createNewChat(
                              _authService.user!.uid, user.uid!);
                        }

                        _navigationService.push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatPage(chatUser: user);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
