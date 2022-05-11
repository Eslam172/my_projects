import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/layout/shop_app/cubit/states.dart';
import 'package:first_app/models/shop_app/categories_model.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
            padding: const EdgeInsets.all(10.0),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildCatItem(
                ShopCubit.get(context).categoriesModel.data.data[index]),
            separatorBuilder: (context, index) => SizedBox(
                  height: 10.0,
                ),
            itemCount: ShopCubit.get(context).categoriesModel.data.data.length);
      },
    );
  }

  Widget buildCatItem(DataModel model) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45),
            topLeft: Radius.circular(45),
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image(
                image: NetworkImage(model.image),
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                model.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      );
}
