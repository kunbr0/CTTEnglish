import 'package:flutter/material.dart';
import '../screens/book_reader.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int rating;
  final String imgUrl;
  const BookCard({
    Key key,
    this.title,
    this.subtitle,
    this.rating,
    this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BookReader();
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: <Widget>[
                    for (int i = 0; i < rating; i++)
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 25.0,
                      ),
                  ],
                ),
              ],
            ),
            Image.asset(
              imgUrl,
              width: 160,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
