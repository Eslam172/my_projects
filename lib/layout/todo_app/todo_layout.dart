import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:first_app/shared/cubit/cubit.dart';
import 'package:first_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();
var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();

class TodoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit.get(context)
                  .titles[AppCubit.get(context).currentIndex]),
              // actions: [
              //   IconButton(
              //     icon: CircleAvatar(
              //         radius: 150,
              //         backgroundColor: Colors.white,
              //         child: Icon(
              //           Icons.cleaning_services_rounded,
              //           color: Colors.black,
              //           size: 25.0,
              //         )),
              //     onPressed: () {
              //       AppCubit.get(context).deleteData();
              //     },
              //   )
              // ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertDatabase(
                        taskTitle: titleController.text,
                        taskTime: timeController.text,
                        taskDate: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet((context) => Container(
                            color: Colors.grey[200],
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      validated: (String value) {
                                        if (value.isEmpty) {
                                          return 'Title Must Not Be Empty';
                                        }
                                        return null;
                                      },
                                      prefix: Icons.title,
                                      label: 'Task Title'),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      validated: (String value) {
                                        if (value.isEmpty) {
                                          return 'Time Must Not Be Empty';
                                        }
                                        return null;
                                      },
                                      prefix: Icons.watch_later_outlined,
                                      label: 'Task Time',
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          print(value.toString());
                                          timeController.text =
                                              value.format(context).toString();
                                          print(timeController.text);
                                        });
                                      }),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      validated: (String value) {
                                        if (value.isEmpty) {
                                          return 'Date Must Not Be Empty';
                                        }
                                        return null;
                                      },
                                      prefix: Icons.calendar_today,
                                      label: 'Task Date',
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2021-12-07'),
                                        ).then((value) {
                                          print(value.toString());
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetStates(
                        icon: Icons.edit, isShow: false);
                  });
                  cubit.changeBottomSheetStates(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
