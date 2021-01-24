import 'package:cttenglish/screens/authenticate/components/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:cttenglish/constants.dart';

import 'package:cttenglish/size_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Scaffold(
        body: MainContainer(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: SizedBox(),
      // On Android it's false by default
      centerTitle: true,
      title: Text("Video Player"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Icon(
            MdiIcons.heart,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class MainContainer extends StatelessWidget {
  String videoUrl;
  MainContainer({
    Key key, this.videoUrl = "https://www.youtube.com/watch?v=3VTsIju1dLI"
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
            SizedBox(
                height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(10), 
                child: Row(
                    children: <Widget>[
                        Expanded(child:  Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            child: 
                                TextField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    style: TextStyle(color: Colors.black, fontSize: 18),
                                    onChanged: (value){videoUrl = value;},
                                    decoration: InputDecoration(
                                        hintText: "Enter Url",
                                        hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                                        border: InputBorder.none,
                                        contentPadding:
                                             EdgeInsets.symmetric(horizontal: 25, vertical: 13)
                                    ),
                                ),
                            ),
                        ),
                        Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            child: 
                                FlatButton(onPressed: (){
                                    Navigator.of(context).pushNamed('/video_player',
                                        arguments: videoUrl);
                                }, 
                                child: Text("Search"))
                        ),
                        
                    ],
                ),
            ),
            
        ],
      ),
    );
  }
}
