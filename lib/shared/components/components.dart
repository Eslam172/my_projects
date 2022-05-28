import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/models/shop_app/fanorites_model_get.dart';
import 'package:first_app/modules/news_app/web_view/web_view.dart';
import 'package:first_app/shared/cubit/cubit.dart';
import 'package:first_app/shared/style/colors.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.green,
  @required Function function,
  @required String text,
  TextStyle textStyle,
  bool isUpperCase = true,
  double radius = 5.0,
  Color colorText,
}) =>
    Container(
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: textStyle ??
              TextStyle(
                color: colorText ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
Widget defaultTextButton({
  @required Function function,
  @required String text,
  Color colorText,
}) =>
    TextButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: colorText),
        ));
Widget defaultFormField(
        {@required TextEditingController controller,
        @required TextInputType type,
        @required Function validated,
        @required IconData prefix,
        @required String label,
        bool isPassword = false,
        Color colorLayout,
        Color colorPrefix,
        Color colorBorder,
        TextStyle textStyle,
        TextStyle labelStyle,
        Function onSubmit,
        Function onTap,
        Function onChange,
        Function suffixPressed,
        InputDecoration decorationBorder,
        IconData suffix}) =>
    TextFormField(
      style: textStyle,
      controller: controller,
      keyboardType: type,
      validator: validated,
      onChanged: onChange,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      decoration: InputDecoration(
        // fillColor: Colors.blue,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: colorBorder ?? defaultColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorLayout,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(100)),
        prefixIcon: Icon(
          prefix,
          color: colorPrefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        labelText: label,
        labelStyle: labelStyle,
        border: OutlineInputBorder(),
      ),
    );

Widget defaultAppBar({
  @required BuildContext context,
  String title,
  Color color,
  Color iconColor,
  Color textColor,
  List<Widget> actions,
}) =>
    AppBar(
      backgroundColor: color,
      leading: IconButton(
          color: iconColor,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(IconBroken.Arrow___Left_2)),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      titleSpacing: 5.0,
      actions: actions,
    );
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),

                  // SizedBox(

                  //   height: 5.0,

                  // ),

                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.blue[700],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: Icon(Icons.archive, color: Colors.black54)),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget tasksBuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks yet , Please Add Some Tasks',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        navigateTo(context, WebViewScreen(article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${article['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        height: 1.0,
        color: Colors.grey,
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              buildArticleItem(list[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: list.length),
      fallback: (context) =>
          isSearch ? Container() : Center(child: CircularProgressIndicator()),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
void showToast({@required String text, @required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);
enum ToastStates { SUCCESS, ERROR, WARNING }
Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildNoInternet() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    // crossAxisAlignment: CrossAxisAlignment.center,
    // mainAxisSize: MainAxisSize.max,
    children: [
      Center(
        child: Container(
          height: 200.0,
          // width: 300.0,
          child: Image.asset(
            'assets/images/no_internet.png',
            color: Colors.grey,
          ),
        ),
      ),
      Text(
        'Oooops!',
        style: TextStyle(color: Colors.grey[500], fontSize: 25.0),
      ),
      Text(
        'No internet connection found',
        style: TextStyle(color: Colors.grey[500], fontSize: 20.0),
      ),
      Text(
        'Check your connection',
        style: TextStyle(color: Colors.grey[500], fontSize: 20.0),
      ),
    ],
  );
}

Widget buildListProduct(model, context, {bool oldPrice = true}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        height: 280.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Image(
                      image: NetworkImage(
                        model.image,
                      ),
                      width: double.infinity,
                      height: 140.0,
                    ),
                    if (model.discount != 0 && oldPrice)
                      Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                  ]),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17.0, height: 1.3),
                    ),
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                          '${model.price.round()}' 'LE',
                          style: TextStyle(color: defaultColor, fontSize: 15.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0 && oldPrice)
                          Text(
                            '${model.oldPrice.round()}' 'LE',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                decoration: TextDecoration.lineThrough),
                          ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id);
                            },
                            icon: CircleAvatar(
                              radius: 15.0,
                              backgroundColor:
                                  ShopCubit.get(context).favorites[model.id]
                                      ? defaultColor
                                      : Colors.grey,
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 14.0,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
