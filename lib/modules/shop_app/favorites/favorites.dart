import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/layout/shop_app/cubit/states.dart';
import 'package:first_app/models/shop_app/fanorites_model_get.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangFavoritesState) {
          if (!state.model.status) {
            showToast(text: state.model.message, state: ToastStates.ERROR);
          } else {
            showToast(text: state.model.message, state: ToastStates.SUCCESS);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) => buildListProduct(
                    ShopCubit.get(context)
                        .favoritesModel
                        .data
                        .data[index]
                        .product,
                    context),
                separatorBuilder: (context, index) => SizedBox(
                      height: 10.0,
                    ),
                itemCount:
                    ShopCubit.get(context).favoritesModel.data.data.length),
            fallback: (context) => CircularProgressIndicator());
      },
    );
  }
}
