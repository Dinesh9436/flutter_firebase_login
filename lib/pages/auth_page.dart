import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_assignment/authentication_provider.dart';
import 'package:firebase_login_assignment/pages/helper.dart';
import 'package:firebase_login_assignment/pages/home_page.dart';
import 'package:firebase_login_assignment/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool checkedValue = false;
  bool register = true;
  List textfieldsStrings = [
    "", //firstName
    "", //lastName
    "", //email
    "", //password
    "", //confirmPassword
  ];

  final _firstnamekey = GlobalKey<FormState>();
  final _lastNamekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: Align(
                        child: Text(
                          'Hey there,',
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                            fontSize: size.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.015),
                      child: Align(
                        child: register
                            ? Text(
                                'Create an Account',
                                style: GoogleFonts.poppins(
                                  color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                'Welcome Back',
                                style: GoogleFonts.poppins(
                                  color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.01),
                    ),
                    register
                        ? buildTextField(
                            "First Name",
                            Icons.person_outlined,
                            false,
                            size,
                            (valuename) {
                              if (valuename.length <= 2) {
                                buildSnackError(
                                  'Invalid name',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              return null;
                            },
                            _firstnamekey,
                            0,
                            isDarkMode,
                          )
                        : Container(),
                    register
                        ? buildTextField(
                            "Last Name",
                            Icons.person_outlined,
                            false,
                            size,
                            (valuesurname) {
                              if (valuesurname.length <= 2) {
                                buildSnackError(
                                  'Invalid last name',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              return null;
                            },
                            _lastNamekey,
                            1,
                            isDarkMode,
                          )
                        : Container(),
                    Form(
                      child: buildTextField(
                        "Email",
                        Icons.email_outlined,
                        false,
                        size,
                        (valuemail) {
                          if (valuemail.length < 5) {
                            buildSnackError(
                              'Invalid email',
                              context,
                              size,
                            );
                            return '';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+").hasMatch(valuemail)) {
                            buildSnackError(
                              'Invalid email',
                              context,
                              size,
                            );
                            return '';
                          }
                          return null;
                        },
                        _emailKey,
                        2,
                        isDarkMode,
                      ),
                    ),
                    Form(
                      child: buildTextField(
                        "Passsword",
                        Icons.lock_outline,
                        true,
                        size,
                        (valuepassword) {
                          if (valuepassword.length < 6) {
                            buildSnackError(
                              'Invalid password',
                              context,
                              size,
                            );
                            return '';
                          }
                          return null;
                        },
                        _passwordKey,
                        3,
                        isDarkMode,
                      ),
                    ),
                    Form(
                      child: register
                          ? buildTextField(
                              "Confirm Passsword",
                              Icons.lock_outline,
                              true,
                              size,
                              (valuepassword) {
                                if (valuepassword != textfieldsStrings[3]) {
                                  buildSnackError(
                                    'Passwords must match',
                                    context,
                                    size,
                                  );
                                  return '';
                                }
                                return null;
                              },
                              _confirmPasswordKey,
                              4,
                              isDarkMode,
                            )
                          : Container(),
                    ),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 500),
                      padding: register ? EdgeInsets.only(top: size.height * 0.025) : EdgeInsets.only(top: size.height * 0.085),
                      child: ButtonWidget(
                        text: register ? "Register" : "Login",
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
                          if (register) {
                            //validation for register
                            if (_firstnamekey.currentState!.validate()) {
                              if (_lastNamekey.currentState!.validate()) {
                                if (_emailKey.currentState!.validate()) {
                                  if (_passwordKey.currentState!.validate()) {
                                    if (_confirmPasswordKey.currentState!.validate()) {
                                      Helper(context).showProgressIndicator();

                                      User? user = await context.read<AuthenticationProvider>().signup(
                                            name: textfieldsStrings[0] + " " + textfieldsStrings[1],
                                            email: textfieldsStrings[2],
                                            password: textfieldsStrings[3],
                                          );
                                      Helper(context).hideProgressIndicator();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    user: user!,
                                                  )),
                                          (route) => false);
                                    }
                                  }
                                }
                              }
                            }
                          } else {
                            //validation for login
                            if (_emailKey.currentState!.validate()) {
                              if (_passwordKey.currentState!.validate()) {
                                Helper(context).showProgressIndicator();
                                print('login');
                                await context
                                    .read<AuthenticationProvider>()
                                    .signIn(
                                      email: textfieldsStrings[2],
                                      password: textfieldsStrings[3],
                                    )
                                    .then((user) => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  user: user!,
                                                )),
                                        (route) => false));
                              }
                            }
                          }
                        },
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: register ? "Already have an account? " : "Don’t have an account yet? ",
                              style: TextStyle(
                                  color: isDarkMode ? Colors.white : const Color(0xff1D1617),
                                  fontSize: size.height * 0.018,
                                  fontFamily: GoogleFonts.poppins().fontFamily),
                            ),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () => setState(() {
                                  if (register) {
                                    register = false;
                                  } else {
                                    register = true;
                                  }
                                }),
                                child: register
                                    ? Text(
                                        "Login",
                                        style: TextStyle(
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: <Color>[
                                                Color(0xffEEA4CE),
                                                Color(0xffC58BF2),
                                              ],
                                            ).createShader(
                                              const Rect.fromLTWH(
                                                0.0,
                                                0.0,
                                                200.0,
                                                70.0,
                                              ),
                                            ),
                                          fontSize: size.height * 0.018,
                                        ),
                                      )
                                    : Text(
                                        "Register",
                                        style: TextStyle(
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: <Color>[
                                                Color(0xffEEA4CE),
                                                Color(0xffC58BF2),
                                              ],
                                            ).createShader(
                                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                            ),
                                          // color: const Color(0xffC58BF2),
                                          fontSize: size.height * 0.018,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool pwVisible = false;
  Widget buildTextField(
    String hintText,
    IconData icon,
    bool password,
    size,
    FormFieldValidator validator,
    Key key,
    int stringToEdit,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.05,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: key,
          child: TextFormField(
            style: TextStyle(color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            onChanged: (value) {
              setState(() {
                textfieldsStrings[stringToEdit] = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.012,
              ),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
              suffixIcon: password
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.005,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pwVisible = !pwVisible;
                          });
                        },
                        child: pwVisible
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Color(0xff7B6F72),
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Color(0xff7B6F72),
                              ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
