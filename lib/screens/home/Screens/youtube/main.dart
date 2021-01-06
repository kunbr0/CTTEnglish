import 'dart:ffi';

import 'package:cttenglish/constants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class VideoScreen extends StatefulWidget {
  VideoScreen();

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _Caption {
  int statusCode = 0; // 0: Begin, 1: Getting, 2: Get successfully, 3: Get Fail
  List<String> captionData = [];
  List<double> timeData = [];
}

class _VideoScreenState extends State<VideoScreen> {
    
    final Color normalRow = Colors.white;
    final Color currentPlayingRow = Colors.yellow[100];
    final ScrollController _captionScrollController = ScrollController();
    YoutubePlayerController _controller;

    bool _muted = false;
    bool _isPlayerReady = false;
    bool _isPlayerPlaying = false;
    int _currentIndex = 0;
    _Caption _caption;
    _VideoScreenState();

    void initState() {
        super.initState();
        _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(
            "https://www.youtube.com/watch?v=3VTsIju1dLI"),
        flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            hideControls: true,
        ),
        )..addListener(listener);
        
        _caption = new _Caption();
    }

    String cleanString (str){
        String result = str.toString().replaceAll("\n", "");
        return result;
    }

    void getCaption(videoId) async {
        var url = "https://api.kunbr0.com/youtube/kun/kun/getCaption.php?url=" + videoId;
        var response = await http.get(url);
        if (response.statusCode == 200) {
            var jsonResponse = convert.jsonDecode(response.body);
            
            if(jsonResponse['data_time'].length > 0 && jsonResponse['data_script'].length > 0){
                setState(() {
                    _caption.captionData = jsonResponse['data_script'].map<String>((a) => cleanString(a)).toList();
                    _caption.timeData = jsonResponse['data_time'].map<double>((a) => double.parse(a)).toList();
                });
            }
        }
    }

    void updateCurrentIndex(int index){
        //_captionScrollController.jumpTo(_controller.position.maxScrollExtent);
        setState(() {
            _currentIndex = index;
        });
    }

    void syncCurrentIndexWithPlayingTime(){
        debugPrint(_currentIndex.toString());
        if(_currentIndex > 0 && _currentIndex < _caption.timeData.length-1){
            int currentPlayingTime = (_controller.value.position.inSeconds);
            int prevTime = _caption.timeData[_currentIndex-1].toInt();
            int nextTime = _caption.timeData[_currentIndex+1].toInt();
            if(currentPlayingTime > prevTime){
                if(currentPlayingTime < nextTime){
                    updateCurrentIndex(_currentIndex);
                }else{
                    _currentIndex += 1;
                    syncCurrentIndexWithPlayingTime();
                }
            }else{
                _currentIndex -= 1;
                syncCurrentIndexWithPlayingTime();
            }
        }else{
            if(_currentIndex == 0){
                int currentPlayingTime = (_controller.value.position.inSeconds);
                int nextTime = _caption.timeData[_currentIndex+1].toInt();
                if(currentPlayingTime > nextTime) 
                    updateCurrentIndex(_currentIndex + 1);
            }
            else if(_currentIndex == _caption.timeData.length-1){
                // End
            }
        }
    }

    void listener() {
        
        setState(() {
            _isPlayerReady = _controller.value.isReady;
            _isPlayerPlaying = _controller.value.isPlaying;
        });

        if (_isPlayerReady && _controller.metadata.videoId != "" &&  _caption.statusCode == 0) {
            setState(() {
                _caption.statusCode = 1;
            });
            getCaption(_controller.metadata.videoId);
        }

        if(_isPlayerPlaying){
            syncCurrentIndexWithPlayingTime();
        }
    }

    
    Widget _captionRow(int index, String caption, double time){
        return 
            Container(
                margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(0.0)),
                        color: _currentIndex == index ? currentPlayingRow : normalRow
                    ),
                child: new Material(
                    child: new InkWell(
                    onTap: () {
                        setState(() {
                            _currentIndex = index;
                        });
                        _controller.seekTo(Duration(milliseconds: (_caption.timeData[index] * 1000).toInt()));
                    },
                    child: new Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Text(caption),
                    ),
                    ),
                    color: Colors.transparent,
                ),
                
            );
    }

    Widget _getListViewCaption(){
        if(_caption.timeData.length > 0)
            return 
               ListView.builder(
                    itemCount: _caption.timeData.length,
                    controller: _captionScrollController,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index){
                        return _captionRow(index, _caption.captionData[index], _caption.timeData[index]);
                    }
                );
        else
            return Container(
                width: double.infinity,
                child: Text("Loading..."),
            );
    }

    Widget bottomBarController(){
        return
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _isPlayerReady
                            ? (){}
                            : null,
                    ),
                    IconButton(
                        icon: Icon(
                        _isPlayerPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        ),
                        onPressed: true
                            ? () {
                                debugPrint("Toggle Pause Play ...");
                                _isPlayerPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                            }
                            : null,
                    ),
                    IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                _muted = !_muted;
                                });
                            }
                            : null,
                    ),
                    FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                    ),
                    IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: _isPlayerReady
                            ? () {}
                            : null,
                    ),
                ],
            );
    }

    Widget build(BuildContext context) {
        
        return Scaffold(
            floatingActionButton: null,
            body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                children: <Widget>[
                    YoutubePlayer(
                    controller: _controller,
                    liveUIColor: Colors.amber,
                    ),
                    //////
                    Expanded(
                        child: Container(
                            color: Colors.grey[600],
                            child:  _getListViewCaption(),
                        ),
                    ),
                    Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            // border: Border(
                            //     top: BorderSide( //                   <--- left side
                            //         color: cArticleTime,
                            //         width: 3.0,
                            //     ),
                            // )
                        ),
                        child: bottomBarController(),
                    )
                    
                ],
                ),
            ),
        ));
    }
}
