import 'package:chatapp/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBox extends StatelessWidget {
  final userProfile userprofile;
  final Function onTap;

  const ChatBox({super.key, required this.userprofile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Color(0xFFF995B0),
              ),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height / 15,
              child: Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userprofile.name!,
                      style: GoogleFonts.indieFlower(fontSize: 30),
                    ),
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 60,
                      color: Color(0xFFFFC8DD),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: MediaQuery.sizeOf(context).width - 120,
          bottom: 5,
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userprofile.profilePicUrl!,
                ),
                radius: 32.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
