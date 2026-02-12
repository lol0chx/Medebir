import 'package:flutter/material.dart';

class BuildTitleRow extends StatelessWidget {
  BuildTitleRow({@required this.mainPadding, @required this.onPressed, @required this.title});

  final EdgeInsets mainPadding;
  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: mainPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            // TextButton(
            //   onPressed: onPressed,
            //   child: Text('More'),
            // ),
          ],
        ),
      ),
    );
  }
}
