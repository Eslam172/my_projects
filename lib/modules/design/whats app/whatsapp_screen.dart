import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhatsAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
              SizedBox(
                width: 5.0,
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ],
        title: Text('Whats App'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt),
                  ),
                  //SizedBox(
                  // width: 20,
                  //),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'CHATS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'CALLS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: 0.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 650,
              child: ListView.separated(
                  itemBuilder: (context, index) => buildChatItem(),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 20.0,
                      ),
                  itemCount: 15),
            )
          ],
        ),
      ),
    );
  }

  Widget buildChatItem() => Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
                'https://1.bp.blogspot.com/-I-LWeV3H5o8/Xzf3Oy2lYrI/AAAAAAAB2gk/E964F52Z5Twzo9IykoJyTgPW5R48YrsOQCLcBGAsYHQ/s1600/https___mashable.com_wp-content_gallery_causes-people-changed-their-profile-pictures-for_9591711465_880c55c0b6_o.jpg'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10.0),
                    child: Text(
                      'Ahmed Mohamed',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 100.0),
                    child: Text('8:55 PM'),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Text(
                  'Hello My Friend My Name Is Ahmed',
                  style: TextStyle(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      );
}
