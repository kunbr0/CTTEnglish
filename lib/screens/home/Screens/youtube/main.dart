
import 'dart:ffi';

import 'package:cttenglish/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class VideoScreen extends StatefulWidget {
  String videoUrl;
  VideoScreen({this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState(videoUrl: videoUrl);
}

class _Caption {
  int statusCode = 0; // 0: Begin, 1: Getting, 2: Get successfully, 3: Get Fail
  List<String> captionData = [];
  List<String> captionWithMissingData = [];
  List<String> correctAnswers = [];
  List<double> timeData = [];
}

class _VideoScreenState extends State<VideoScreen> {
    final videoUrl;
    final Color normalRow = Colors.white;
    final Color currentPlayingRow = Colors.yellow[100];
    final scrollDirection = Axis.vertical;
    final int intervalSyncTime = 200;
    final double minHeightOfAnswerModal = 200;

    _VideoScreenState({this.videoUrl});

    Function _setStateModalBottom;

    AutoScrollController _captionScrollController;
    YoutubePlayerController _youtubeController;

    int _lastSyncTime;

    bool _muted = false;
    bool _isPlayerReady = false;
    bool _isPlayerPlaying = false;
    bool _isOpenBottomModal = false;

    String _answerValue;

    int _playOption = 0;

    int _currentIndex = 0;
    _Caption _caption;
    

    int getKTime(){
        return DateTime.now().microsecondsSinceEpoch;
    }

    void initState() {
        super.initState();
        _captionScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
        
        
        _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(
            videoUrl),
        flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            hideControls: true,
            enableCaption: false,
            controlsVisibleAtStart: false,
        ),
        )..addListener(youtubePlayerListener);
        _lastSyncTime = getKTime();
        _caption = new _Caption();
        _playOption = 0;
        _answerValue = "";
    }
    
    void youtubePlayerListener() {
     
        
        if(_isPlayerPlaying && _caption.timeData.length < 1){
           debugPrint("Pauseeee");
          _youtubeController.pause();
        }
        if (_youtubeController.value.metaData.videoId.toString().length > 0 && _caption.statusCode == 0) {
            debugPrint("Begin get caption");
            setState(() {
                _caption.statusCode = 1;
            });
            getCaption(_youtubeController.value.metaData.videoId.toString());
        }

        if(!isReadyForNextSync()) return;

        setState(() {
            _isPlayerReady = _youtubeController.value.isReady;
            _isPlayerPlaying = _youtubeController.value.isPlaying;
        });
        debugPrint("Video id: " + _youtubeController.value.metaData.videoId.toString());
        

        if(_isPlayerPlaying){
            syncCurrentIndexWithPlayingTime(_currentIndex);
            _lastSyncTime = getKTime();
        }
    }

    
    

    String cleanString (str){
        String result = str.toString().replaceAll("\n", "");
        return result;
    }
    
    int kRandomNumber(int min, int max){
      final _random = new Random();
      int result = min + _random.nextInt(max - min);
      return result;
    } 

   

    String getMissingWordSentences(String str){
        String result = "";
        var arrayOfWord = str.trim().split(" ");
        if(arrayOfWord.length == 1){
            _caption.correctAnswers.add(arrayOfWord[0]);
            return arrayOfWord[0];
        }
        int randomIndex = kRandomNumber(0, arrayOfWord.length-1);
        for(int i=0; i<arrayOfWord.length;i++){
            if(randomIndex == i) {
                if(arrayOfWord[i] == " "){
                    i+= 1;
                }
                _caption.correctAnswers.add(arrayOfWord[i]);
                result += "_____ ";
            }
            else result += arrayOfWord[i] + " ";
        }
        
        return result;
    }

    void generateCaptionWithMissing(){
        
        _caption.captionWithMissingData =  _caption.captionData.map((e)=>getMissingWordSentences(e)).toList();

        debugPrint(_caption.correctAnswers.toString());
    }


    void getCaption(videoId) async {
        debugPrint("Getting Caption " + videoId + " ..." );
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
            generateCaptionWithMissing();
            if(_playOption != 0)
                _youtubeController.play();
        }
    }

    void updateCurrentIndex(int index, {bool isSeekToIndex = false}) {
        if(index < 0 || index >= _caption.timeData.length) return;
        //double totalLength = _captionScrollController.position.maxScrollExtent;
        setState(() {
            _currentIndex = index;
        });

        if(_captionScrollController.position.isScrollingNotifier.value == false)
            _captionScrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
        
        if(isSeekToIndex)
            _youtubeController.seekTo(Duration(milliseconds: (_caption.timeData[index] * 1000).toInt()));
        
        
        _lastSyncTime = getKTime();
    }
    
    

    bool isReadyForNextSync(){
        int timestamp = getKTime();
        if(timestamp < _lastSyncTime + intervalSyncTime) return false;
        return true;
    }


    void syncCurrentIndexWithPlayingTime(int crIndex){
        
        if(_currentIndex > 0 && _currentIndex < _caption.timeData.length-1){
            int currentPlayingTime = (_youtubeController.value.position.inSeconds);
            int prevTime = _caption.timeData[crIndex-1].toInt();
            int nextTime = _caption.timeData[crIndex+1].toInt();
            if(currentPlayingTime > prevTime){
                if(currentPlayingTime < nextTime){
                    if(crIndex != _currentIndex && isReadyForNextSync()){
                        if(_playOption == 2) {
                            _youtubeController.pause();
                            _showQuestionModal(_caption.captionWithMissingData[crIndex-1],crIndex-1);
                        }
                        else updateCurrentIndex(crIndex);
                        
                    }
                        
                }else{
                    crIndex += 1;
                    syncCurrentIndexWithPlayingTime(crIndex);
                }
            }else{
                crIndex -= 1;
                syncCurrentIndexWithPlayingTime(crIndex);
            }
        }else{
            if(crIndex == 0 && _caption.timeData.length > 0){
                int currentPlayingTime = (_youtubeController.value.position.inSeconds);
                int nextTime = _caption.timeData[crIndex+1].toInt();
                if(currentPlayingTime > nextTime){
                    if(_playOption == 2) {
                        _youtubeController.pause();
                        _showQuestionModal(_caption.captionWithMissingData[crIndex],crIndex);
                    }
                    else updateCurrentIndex(crIndex + 1);
                } 
                    
            }
            else if(crIndex == _caption.timeData.length-1){
                // End
            }
        }
    }


    Widget _playOptionWidget(IconData iconData, String mainTitle, optionId){
        return 
            Container(
                    margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(0.0)),
                          color: Colors.white
                      ),
                    child: new Material(
                      child: new InkWell(
                        onTap: () {
                            setState(() {
                                _playOption = optionId;
                            });
                            if(_caption.timeData.length > 0) _youtubeController.play();
                        },
                        child: new Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    children: [
                                        Icon(
                                            iconData,
                                            size: 40,
                                        ),
                                        Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                child: Text(
                                                    mainTitle,
                                                    style: TextStyle(
                                                    color: cArticleTitle,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                                ),
                                            ),
                                        )
                                    ],
                                )
                                
                                
                              ]
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    
                  );
    }

    Widget _optionsSelect(){
        return 
        Container(
            width: double.infinity,
            height: 100,
            child:
            Column(
                
                children: [
                    _playOptionWidget(MdiIcons.closedCaption, "Only Listening", 1),
                    _playOptionWidget(MdiIcons.puzzleRemove, "Practice Multiple Choice", 2),
                ],
            )
        );
    }


    void _closeModal(int nextSente) {
        setState((){
            _answerValue = "";
        });
        _isOpenBottomModal = false;
        _youtubeController.play();
        _lastSyncTime = getKTime();
        updateCurrentIndex(nextSente);
    }

    Widget _answerButton(
        String value, Function onPress, 
        {Color btnColor = kAnswerBtnColor, double kWidth = 28, TextStyle textStyle = const TextStyle(fontSize: 15)} 
    ){
        return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(3),
            width: kWidth,
            height: 30,
            color: Colors.green[50],
            child: RawMaterialButton(
            
                onPressed: (){
                    
                    onPress();
                    _setStateModalBottom((){});
                },
                child: Text(
                    value,
                    style: textStyle,
                ),
                fillColor: btnColor,
                elevation: 0,
                
            ),
        );
    }

    List<Widget> _generateAnswerBtns (String correctAnswer) {
        
        String keyboardPattern = "QWERTYUIOP-ASDFGHJKL'-ZXCVBNM,.";

        // = ( screen width - 10 ) / numOfKey - 2*marginLeftRight
        double kWidth = (MediaQuery.of(context).size.width - 10) / 10 - 6;
        List<Widget> generateRowElm(String kContent){
            return kContent.split('').map<Widget>((e){
                return _answerButton(e.toUpperCase(), (){
                            setState(() {
                                _answerValue = _answerValue + e.toUpperCase().toString();
                            });
                        }, kWidth: kWidth);
            }).toList();
        }

        return keyboardPattern.split('-').map<Row>((kRow)=>Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: generateRowElm(kRow),
        )).toList();

        

        
    }


    Widget _modalBottomContent (String paragraph, String correctAnswerWithOtherChars){
        

        return Column(children: [
                Text(paragraph,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                    )
                ),

                SizedBox(height: 5),
                Row(children: [
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            color: Colors.amber[200],
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Text(_answerValue),

                        ),
                    ),
                    _answerButton(
                        "Delete", 
                        (){
                            if (_answerValue != null && _answerValue.length > 0) {
                                setState((){
                                    _answerValue = _answerValue.substring(0, _answerValue.length - 1);
                                });
                            }
                        }, 
                        btnColor: kDeleteBtnColor, 
                        kWidth: 55
                    )
                ],),
                SizedBox(height: 5),
                Wrap(children: _generateAnswerBtns(correctAnswerWithOtherChars)),
                
                
                
            
            ]
        );
    }

    void _cShowModalBottomSheet(String sente, int currentSenteIndex) {
        
        Future<void> future = showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            elevation: 10,
            builder: (BuildContext context) {
                return BottomSheet(
                    onDragStart: (a){},
                    onClosing: (){}, 
                    builder: (BuildContext context){
                        return StatefulBuilder(
                            builder: (BuildContext context, setState){
                                _setStateModalBottom = setState;
                                if(_answerValue.toUpperCase() == _caption.correctAnswers[currentSenteIndex].toUpperCase()){
                                    Navigator.pop(context);
                                }
                                return Container(
                                    padding: EdgeInsets.fromLTRB(5,10,5,0),
                                    height:  sente.length < 48 ? 195 : 215,
                                    child: SizedBox.expand(
                                        child: SingleChildScrollView(
                                            child: _modalBottomContent(sente, "QWERTYUIOP"),
                                        )
                                    
                                    ),
                                );
                            }
                        );
                    }
                );
            });
        
        future.then((void value) => _closeModal(currentSenteIndex+1));
    }

   
    void _showQuestionModal(
        String sente, int currentSenteIndex) {
        if(_isOpenBottomModal == false){
            _isOpenBottomModal = true;
            _cShowModalBottomSheet(
                sente,
                currentSenteIndex
            );
            
        }
       
    }

    Widget _captionRow(AutoScrollController controller, int index, String caption, double time){
        return 
        AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: 
            Container(
                margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(0.0)),
                        color: _currentIndex == index ? currentPlayingRow : normalRow
                    ),
                child: new Material(
                    child: new InkWell(
                    onTap: () {
                        updateCurrentIndex(index, isSeekToIndex: true);  
                        
                    },
                    child: new Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Text(caption),
                    ),
                    ),
                    color: Colors.transparent,
                ),
                
            )
        );
    }

    Widget _getListViewCaption(){
        if(_playOption == 0){
            return _optionsSelect();
        }
        else if(_caption.timeData.length > 0){
            return 
               ListView.builder(
                    itemCount: _caption.timeData.length,
                    controller: _captionScrollController,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index){
                        return _captionRow(
                            _captionScrollController, 
                            index, 
                            _playOption == 1 ? _caption.captionData[index] : _caption.captionWithMissingData[index], 
                            _caption.timeData[index]
                        );
                    }
                );
        }   
        else
            return Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Loading..."),
            );
    }

    Widget bottomBarController(){
        if(_playOption == 0){
            return Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Please section options above ..."),
            );
        }
        else if(_caption.timeData.length > 0)
            return
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: _isPlayerReady
                                ? (){
                                    setState(() {
                                        updateCurrentIndex(_currentIndex-1, isSeekToIndex: true);
                                    });
                                }
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
                                        ? _youtubeController.pause()
                                        : _youtubeController.play();
                                    setState(() {});
                                }
                                : null,
                        ),
                        

                        IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: _isPlayerReady
                                ? () {
                                    setState(() {
                                        updateCurrentIndex(_currentIndex+1, isSeekToIndex: true);
                                    });
                                }
                                : null,
                        ),

                        IconButton(
                            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                            onPressed: _isPlayerReady
                                ? () {
                                    _muted
                                        ? _youtubeController.unMute()
                                        : _youtubeController.mute();
                                    setState(() {
                                    _muted = !_muted;
                                    });
                                }
                                : null,
                        ),
                        
                    ],
                );
        else
            return Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Loading..."),
            );
    }

    Widget build(BuildContext context) {
        
        return SafeArea(child: 
            Scaffold(
                floatingActionButton: null,
                body: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: 
                        [
                            Column(children: 
                                <Widget>[
                                    YoutubePlayer(
                                    controller: _youtubeController,
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
                                        height: 45,
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
                
                            Positioned(
                                left: 5,
                                top: 5,
                                child: 
                                    RawMaterialButton(
                                        onPressed: () {
                                            Navigator.pop(context);
                                        },
                                        fillColor: _isPlayerPlaying ? Color(0x00FFFFFF) : Color(0x66FFFFFF),
                                        child: Icon(
                                            Icons.arrow_back_ios,
                                            size: 30.0,
                                        ),
                                        padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                        constraints: BoxConstraints(maxWidth: 48, maxHeight: 48),
                                        shape: CircleBorder(),
                                    )
                            ),
                        ],
                    )
                    
                    ),
                )
            )
        );
    }
}
