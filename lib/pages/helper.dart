import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Helper {
   BuildContext context;

  Helper( this.context);

   showProgressIndicator() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
      ),
    );
  }

  hideProgressIndicator() async {
    Navigator.pop(context);
  }

}
