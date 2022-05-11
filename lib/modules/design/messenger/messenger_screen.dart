import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessengerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        titleSpacing: 25.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  'https://1.bp.blogspot.com/-I-LWeV3H5o8/Xzf3Oy2lYrI/AAAAAAAB2gk/E964F52Z5Twzo9IykoJyTgPW5R48YrsOQCLcBGAsYHQ/s1600/https___mashable.com_wp-content_gallery_causes-people-changed-their-profile-pictures-for_9591711465_880c55c0b6_o.jpg'),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              'Chats',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.camera_alt, size: 20.0, color: Colors.black)),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.edit,
                size: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text('Search'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 100.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => buildStoryItem(),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 20.0,
                  ),
                  itemCount: 10,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => buildChatItem(),
                separatorBuilder: (context, index) => SizedBox(
                  height: 20.0,
                ),
                itemCount: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStoryItem() {
    return Container(
      width: 60.0,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://1.bp.blogspot.com/-I-LWeV3H5o8/Xzf3Oy2lYrI/AAAAAAAB2gk/E964F52Z5Twzo9IykoJyTgPW5R48YrsOQCLcBGAsYHQ/s1600/https___mashable.com_wp-content_gallery_causes-people-changed-their-profile-pictures-for_9591711465_880c55c0b6_o.jpg'),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(bottom: 3.0, end: 3.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 7.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            'Ahmed Mohamed Ahmed Ali',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChatItem() => Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://1.bp.blogspot.com/-I-LWeV3H5o8/Xzf3Oy2lYrI/AAAAAAAB2gk/E964F52Z5Twzo9IykoJyTgPW5R48YrsOQCLcBGAsYHQ/s1600/https___mashable.com_wp-content_gallery_causes-people-changed-their-profile-pictures-for_9591711465_880c55c0b6_o.jpg'),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(bottom: 3.0, end: 3.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 7.0,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ahmed Mohamed Ahmed Ali',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    'Hello My Name Is Ahmed ',
                    style: TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 7.0,
                      height: 7.0,
                      decoration: BoxDecoration(
                          color: Colors.amber, shape: BoxShape.circle),
                    ),
                  ),
                  Text(
                    '02:00 PM',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
