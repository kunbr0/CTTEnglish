import 'package:cttenglish/constants.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class BeautifulAppBar extends StatelessWidget {
  const BeautifulAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            Text(
              "Dictionary",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
