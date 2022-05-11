import 'package:first_app/models/user/user_model.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  List<UserModel> users = [
    UserModel(id: 1, name: 'Ahmed Mohamed', phone: '+201097643182'),
    UserModel(id: 2, name: 'Ayman Mohamed', phone: '+201096889247'),
    UserModel(id: 3, name: 'Ahmed Mohamed', phone: '+201096888921'),
    UserModel(id: 4, name: 'Ahmed Mohamed', phone: '+201096885260'),
    UserModel(id: 5, name: 'Ahmed Mohamed', phone: '+201096894853'),
    UserModel(id: 6, name: 'Ahmed Mohamed', phone: '+201096582134'),
    UserModel(id: 7, name: 'Ahmed Mohamed', phone: '+201085631472'),
    UserModel(id: 8, name: 'Ahmed Mohamed', phone: '+201078963214'),
    UserModel(id: 9, name: 'Ahmed Mohamed', phone: '+201096358742'),
    UserModel(id: 10, name: 'Ahmed Mohamed', phone: '+201089654712'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'USERS',
          style: TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => buildUserItem(users[index]),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black,
              ),
          itemCount: users.length),
    );
  }

  Widget buildUserItem(UserModel user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              child: Text(
                '${user.id}',
                style: TextStyle(fontSize: 50.0),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '${user.phone}',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ],
        ),
      );
}
