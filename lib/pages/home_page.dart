import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_login_assignment/widgets/button_widget.dart';

import '../authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({required this.user});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    log(widget.user.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xff151f2c) : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Align(
                child: Text(
                  'Welcome Back,',
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                    fontSize: size.height * 0.03,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.015),
              child: Align(
                child: Text(
                  _currentUser.displayName!,
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                    fontSize: size.height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
          Column(children: [
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(75), // Image radius
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: _currentUser.photoURL ??
                          "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.05),
              child: Align(
                child: Text(
                  _currentUser.email!,
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                    fontSize: size.height * 0.03,
                  ),
                ),
              ),
            ),
          ]),
          AnimatedPadding(
            duration: const Duration(milliseconds: 500),
            padding: EdgeInsets.only(bottom: size.height * 0.25),
            child: ButtonWidget(
              text: "Logout",
              backColor: isDarkMode
                  ? [
                      Colors.black,
                      Colors.black,
                    ]
                  : const [Color(0xff92A3FD), Color(0xff9DCEFF)],
              textColor: const [
                Colors.white,
                Colors.white,
              ],
              onPressed: () async {
                context.read<AuthenticationProvider>().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
