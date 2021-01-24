import 'package:cached_network_image/cached_network_image.dart';
import 'package:cttenglish/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cttenglish/models/user.dart';
import 'package:cttenglish/screens/authenticate/authenticate.dart';
import 'package:cttenglish/screens/home/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import './assets.dart';
import 'package:cttenglish/widgets/cache_image.dart';

class OnBoardScreen extends StatefulWidget {
  BuildContext context;

  OnBoardScreen({Key key, this.context}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  SwiperController _controller = SwiperController();
  int _currentIndex = 0;
  final List<String> titles = [
    "Welcome",
    "Awesome App",
    "Flutter App",
  ];
  final List<String> subtitles = [
    "Welcome to this awesome intro screen app.",
    "This is an awesome app, of intro screen design",
    "Flutter is awesome for app development"
  ];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
  ];
  Future<bool> kPrecache(List<String> listAssetPath) async {
    await Future.forEach(listAssetPath, (path) async {
      if (path.substring(path.length - 3) == "svg") {
        await precachePicture(
            ExactAssetPicture(SvgPicture.svgStringDecoder, path), null);
      } else {}
    });
    return true;
  }

  Future<bool> loadAssetAuthenticate() async {
    await kPrecache([
      'assets/icons/login.svg',
      'assets/icons/signup.svg',
      'assets/icons/chat.svg'
    ]);
    return true;
  }

  Future<bool> loadAssetHome() async {
    await kPrecache([
      'assets/icons/home.svg',
      'assets/icons/list.svg',
      'assets/icons/camera.svg',
      'assets/icons/chef_nav.svg',
      'assets/icons/user.svg',
      'assets/icons/menu.svg',
      'assets/images/logo.svg',
      'assets/icons/search.svg'
    ]);
    return true;
  }

  Future<int> getScreen() async {
    final user = Provider.of<User>(context, listen: false);
    if (_currentIndex < 2) return 0;
    if (user == null) return 1;
    return 2;
  }

  @override
  void initState() {
    super.initState();
    getScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Swiper(
            loop: false,
            index: _currentIndex,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            controller: _controller,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: Colors.red,
                activeSize: 20.0,
              ),
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return IntroItem(
                title: titles[index],
                subtitle: subtitles[index],
                bg: colors[index],
                imageUrl: introIllus[index],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FlatButton(
              child: Text("Skip"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon:
                  Icon(_currentIndex == 2 ? Icons.check : Icons.arrow_forward),
              onPressed: () async {
                if (_currentIndex != 2)
                  _controller.next();
                else {
                  int screen = await getScreen();
                  if (screen == 0) return;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              screen == 1 ? Authenticate() : Home()));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class IntroItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bg;
  final String imageUrl;

  const IntroItem(
      {Key key, @required this.title, this.subtitle, this.bg, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg ?? Theme.of(context).primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                    color: Colors.white),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 20.0),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40.0),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 70),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Material(
                        elevation: 4.0,
                        child: CachedNetworkImage(
                          // height: 200,
                          // width: 1000,
                          imageUrl: imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
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
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
