import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/layout/shop_app/cubit/states.dart';
import 'package:first_app/models/shop_app/categories_model.dart';
import 'package:first_app/models/shop_app/home_model.dart';
import 'package:first_app/modules/shop_app/products/product_details.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
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
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel,
              context),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model.data.banners.map((e) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      image: DecorationImage(
                          image: NetworkImage('${e.image}'), fit: BoxFit.fill),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    height: 220.0,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayInterval: Duration(seconds: 3),
                    enableInfiniteScroll: true,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    reverse: false,
                    scrollDirection: Axis.horizontal)),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                    ),
                    child: Container(
                      height: 130.0,
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => buildCategoryItem(
                              categoriesModel.data.data[index]),
                          separatorBuilder: (context, index) => SizedBox(
                                width: 10.0,
                              ),
                          itemCount: categoriesModel.data.data.length),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              color: Colors.grey,
              child: GridView.count(
                mainAxisSpacing: 7.0,
                crossAxisSpacing: 7.0,
                childAspectRatio: 1 / 1.6,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(
                  model.data.products.length,
                  (index) => buildGridProduct(
                    model.data.products[index],
                    context,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(
    ProductsModel model,
    context,
  ) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(55),
            topLeft: Radius.circular(55),
            bottomLeft: Radius.circular(55),
            bottomRight: Radius.circular(55),
          ),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            // print(model.id);
            // print(model.description);
            navigateTo(context, ProductDetails(model));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Image(
                            image: NetworkImage(
                              model.image,
                            ),
                            width: double.infinity,
                            height: 200.0,
                          ),
                          if (model.disCount != 0)
                            Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                'DISCOUNT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.0,
                                ),
                              ),
                            ),
                        ]),
                    Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.price.round()}' 'LE',
                          style: TextStyle(color: defaultColor, fontSize: 12.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.disCount != 0)
                          Text(
                            '${model.oldPrice.round()}' 'LE',
                            style: TextStyle(
                                color: Colors.black.withOpacity(.6),
                                fontSize: 10.0,
                                decoration: TextDecoration.lineThrough),
                          ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id);
                            },
                            icon: CircleAvatar(
                              radius: 20.0,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildCategoryItem(DataModel model) => Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 130.0,
              width: 130.0,
              fit: BoxFit.fill,
            ),
            Container(
              // color: Colors.black.withOpacity(.8),
              decoration: BoxDecoration(color: Colors.grey),
              width: 130.0,
              child: Text(
                model.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
}
