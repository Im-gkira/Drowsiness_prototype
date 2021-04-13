import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dds/detector/live_camera.dart';
import 'package:dds/map/map.dart';
import 'package:dds/main.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
NetworkImage _avatarImg =
NetworkImage('https://www.w3schools.com/howto/img_avatar.png');
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CollapsibleSidebar(
        avatarImg: _avatarImg,
        body: _body(Size.lerp(Size.square(4),Size.square(4),6), context),
        items: [CollapsibleItem(
          text: 'Dashboard',
          icon: Icons.assessment,
          onPressed: (){},
          isSelected: true,
        ),],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 160,
                child: ElevatedButton(
                  child: Text("Real Time Detection"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveFeed(cameras),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 160,
                child: ElevatedButton(
                  child: Text("Google Map"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GMap(cameras),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 160,
                child: ElevatedButton(
                  child: Text("Settings (TO BE IMPLEMENTED)"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _body(Size size, BuildContext context) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Colors.blueGrey[50],
    child: Container(
      alignment: Alignment.centerRight,
      child: Transform.rotate(
        angle: 3.15 / 2,
        child: Transform.translate(
          offset: Offset(-size.height * 0.1, -size.width * 0.23),
          child: Text(
            "Hello Driver!!",
            style: Theme.of(context).textTheme.headline1,
            overflow: TextOverflow.visible,
            softWrap: false,
          ),
        ),
      ),
    ),
  );
}
