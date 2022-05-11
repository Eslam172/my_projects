import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state) {
          return Scaffold(
            // resizeToAvoidBottomInset: false,
            // backgroundColor: HexColor('#242529'),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'S',
                    style:
                        TextStyle(color: HexColor('#4DBCE1'), fontSize: 45.0),
                  ),
                  Text(
                    'O',
                    style:
                        TextStyle(color: HexColor('#91DF4F'), fontSize: 45.0),
                  ),
                  Text(
                    'C',
                    style:
                        TextStyle(color: HexColor('#D72687'), fontSize: 45.0),
                  ),
                  Text(
                    'I',
                    style:
                        TextStyle(color: HexColor('#D72687'), fontSize: 45.0),
                  ),
                  Text(
                    'A',
                    style:
                        TextStyle(color: HexColor('#91DF4F'), fontSize: 45.0),
                  ),
                  Text(
                    'L',
                    style:
                        TextStyle(color: HexColor('#FE5D0C'), fontSize: 45.0),
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  Text(
                    'A',
                    style:
                        TextStyle(color: HexColor('#4DBCE1'), fontSize: 45.0),
                  ),
                  Text(
                    'P',
                    style:
                        TextStyle(color: HexColor('#D72687'), fontSize: 45.0),
                  ),
                  Text(
                    'P',
                    style:
                        TextStyle(color: HexColor('#FE5D0C'), fontSize: 45.0),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
//Container(
//           width: 250.0,
//           child: Image(
//               image: NetworkImage(
//                   'https://previews.123rf.com/images/nnv/nnv1106/nnv110600691/9733172-the-word-friends-isolated-on-a-black-background.jpg?fj=1')),
//         )
