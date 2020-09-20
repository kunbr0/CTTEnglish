import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cttenglish/screens/home/Screens/home/components/Categories/Newspaper.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewspaperView extends StatefulWidget {
  final String word;
  NewspaperView({Key key, this.word}) : super(key: key);

  @override
  _NewspaperViewState createState() => _NewspaperViewState(word);
}

class _NewspaperViewState extends State<NewspaperView> {
  final String data;
  _NewspaperViewState(this.data);

  final ariclesList = StreamController<List<Newspaper>>();

  void getNewspaper() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
        'https://api3.vnexpress.net/api/article?type=get_rule_2&cate_id=1003894&limit=60&offset=0&option=video_autoplay&app_id=9e304d';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var articlesData = jsonResponse['data']['1003894'].map<Newspaper>((news) {
        var newsId = news['article_id'].toString();

        return Newspaper(
            id: news['article_id'],
            title: news['title'],
            thumbnailUrl: news['thumbnail_url'],
            publishTime: news['publish_time'],
            urlFull:
                'https://api3.vnexpress.net/api/article?type=get_full&article_id=$newsId&app_id=9e304d');
      }).toList();

      print('Get wordmeaning successfully .');
      ariclesList.sink.add(articlesData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      ariclesList.sink
          .addError('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getNewspaper();
  }

  @override
  void dispose() {
    super.dispose();
    ariclesList.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ariclesList.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          // return Text("fd");
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                // return Text(index.toString());
                return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/reader',
                          arguments: snapshot.data[index].urlFull);
                    },
                    // child: Container(
                    //     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    //     margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    //     decoration: BoxDecoration(
                    //         border:
                    //             Border.all(width: 1, color: Colors.blue[200])),
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  blurRadius: 10.0),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                height: 100,
                                width: 120,
                                imageUrl: snapshot.data[index].thumbnailUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Vnexpress',
                                          style: TextStyle(
                                              color: Color(0xff911f20),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                            timeago.format(new DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                snapshot.data[index]
                                                        .publishTime *
                                                    1000)),
                                            style: TextStyle(
                                                color: Color(0xff696969)))
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(snapshot.data[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    // Row(
                    //   children: [
                    //     CachedNetworkImage(
                    //       height: 55,
                    //       width: 90,
                    //       imageUrl: snapshot.data[index].thumbnailUrl,
                    //       imageBuilder: (context, imageProvider) =>
                    //           Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           image: DecorationImage(
                    //             image: imageProvider,
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       ),
                    //       errorWidget: (context, url, error) =>
                    //           Icon(Icons.error),
                    //     ),
                    //     // Image.network('https://placeimg.com/640/480/any',
                    //     //     width: 90, height: 55, fit: BoxFit.fill),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(
                    //                 'Vnexpress',
                    //                 style:
                    //                     TextStyle(color: Color(0xff911f20)),
                    //               ),
                    //               Text(
                    //                   timeago.format(new DateTime
                    //                           .fromMillisecondsSinceEpoch(
                    //                       snapshot.data[index].publishTime *
                    //                           1000)),
                    //                   style: TextStyle(
                    //                       color: Color(0xff696969)))
                    //             ],
                    //           ),
                    //           SizedBox(height: 5),
                    //           Text(snapshot.data[index].title,
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // )
                    // ),
                    );
              });
        });
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class NewspaperView extends StatefulWidget {
//   @override
//   _NewspaperViewState createState() => _NewspaperViewState();
// }

// const FOOD_DATA = [
//   {"name": "Burger", "brand": "Hawkers", "price": 2.99, "image": "burger.png"},
//   {
//     "name": "Cheese Dip",
//     "brand": "Hawkers",
//     "price": 4.99,
//     "image": "cheese_dip.png"
//   },
//   {"name": "Cola", "brand": "Mcdonald", "price": 1.49, "image": "cola.png"},
//   {"name": "Fries", "brand": "Mcdonald", "price": 2.99, "image": "fries.png"},
//   {
//     "name": "Ice Cream",
//     "brand": "Ben & Jerry's",
//     "price": 9.49,
//     "image": "ice_cream.png"
//   },
//   {
//     "name": "Noodles",
//     "brand": "Hawkers",
//     "price": 4.49,
//     "image": "noodles.png"
//   },
//   {"name": "Pizza", "brand": "Dominos", "price": 17.99, "image": "pizza.png"},
//   {
//     "name": "Sandwich",
//     "brand": "Hawkers",
//     "price": 2.99,
//     "image": "sandwich.png"
//   },
//   {"name": "Wrap", "brand": "Subway", "price": 6.99, "image": "wrap.png"}
// ];

// class _NewspaperViewState extends State<NewspaperView> {
//   final CategoriesScroller categoriesScroller = CategoriesScroller();
//   ScrollController controller = ScrollController();
//   bool closeTopContainer = false;
//   double topContainer = 0;

//   List<Widget> itemsData = [];

//   void getPostsData() {
//     List<dynamic> responseList = FOOD_DATA;
//     List<Widget> listItems = [];
//     responseList.forEach((post) {
//       listItems.add(Container(
//           height: 150,
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20.0)),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
//               ]),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//             child: Row(
//               mainAxisAlignmentmap: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       post["name"],
//                       style: const TextStyle(
//                           fontSize: 28, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       post["brand"],
//                       style: const TextStyle(fontSize: 17, color: Colors.grey),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "\$ ${post["price"]}",
//                       style: const TextStyle(
//                           fontSize: 25,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//                 Image.asset(
//                   "assets/images/best_2020.png",
//                   // height: double.infinity,
//                   width: 80,
//                 )
//               ],
//             ),
//           )));
//     });
//     setState(() {
//       itemsData = listItems;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPostsData();
//     controller.addListener(() {
//       double value = controller.offset / 119;

//       setState(() {
//         topContainer = value;
//         closeTopContainer = controller.offset > 50;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final double categoryHeight = size.height * 0.30;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leading: Icon(
//             Icons.menu,
//             color: Colors.black,
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.black),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.person, color: Colors.black),
//               onPressed: () {},
//             )
//           ],
//         ),
//         body: Container(
//           height: size.height,
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Text(
//                     "Loyality Cards",
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                   Text(
//                     "Menu",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               AnimatedOpacity(
//                 duration: const Duration(milliseconds: 200),
//                 opacity: closeTopContainer ? 0 : 1,
//                 child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: size.width,
//                     alignment: Alignment.topCenter,
//                     height: closeTopContainer ? 0 : categoryHeight,
//                     child: categoriesScroller),
//               ),
//               Expanded(
//                   child: ListView.builder(
//                       controller: controller,
//                       itemCount: itemsData.length,
//                       physics: BouncingScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         double scale = 1.0;
//                         if (topContainer > 0.5) {
//                           scale = index + 0.5 - topContainer;
//                           if (scale < 0) {
//                             scale = 0;
//                           } else if (scale > 1) {
//                             scale = 1;
//                           }
//                         }
//                         return Opacity(
//                           opacity: scale,
//                           child: Transform(
//                             transform: Matrix4.identity()..scale(scale, scale),
//                             alignment: Alignment.bottomCenter,
//                             child: Align(
//                                 heightFactor: 0.7,
//                                 alignment: Alignment.topCenter,
//                                 child: itemsData[index]),
//                           ),
//                         );
//                       })),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CategoriesScroller extends StatelessWidget {
//   const CategoriesScroller();

//   @override
//   Widget build(BuildContext context) {
//     final double categoryHeight =
//         MediaQuery.of(context).size.height * 0.30 - 50;
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: FittedBox(
//           fit: BoxFit.fill,
//           alignment: Alignment.topCenter,
//           child: Row(
//             children: <Widget>[
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.orange.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Most\nFavorites",
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.blue.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Newest",
//                           style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           "20 Items",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.lightBlueAccent.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Super\nSaving",
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
