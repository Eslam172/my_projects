import 'package:first_app/modules/counter/cubit/cubit.dart';
import 'package:first_app/modules/counter/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => CounterCubit(),
        child: BlocConsumer<CounterCubit, CounterStates>(
          listener: (context, state) {
            if (state is CounterPlusState) {
              print("PLUS STATE :${state.counter}");
            }
            if (state is CounterMinusState) {
              print("MINUS STATE :${state.counter}");
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                    'COUNTER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        CounterCubit.get(context).minus();
                      },
                      child: Text('MINUS'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        '${CounterCubit.get(context).counter}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 60.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        CounterCubit.get(context).plus();
                      },
                      child: Text('PLUS'),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
