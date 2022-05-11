import 'package:first_app/layout/news_app/cubit/cubit.dart';
import 'package:first_app/layout/news_app/cubit/states.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var list = NewsCubit.get(context).search;
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                      controller: searchController,
                      decorationBorder: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrange, width: 5.0),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      type: TextInputType.text,
                      label: 'Search',
                      prefix: Icons.search,
                      validated: (String value) {
                        if (value.isEmpty) {
                          return 'Search Must Not Be Empty';
                        }
                        return null;
                      },
                      onChange: (value) {
                        NewsCubit.get(context).getSearch(value);
                      }),
                ),
                Expanded(child: articleBuilder(list, context, isSearch: true)),
              ],
            ),
          );
        });
  }
}
