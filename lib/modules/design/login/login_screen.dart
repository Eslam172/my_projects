import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        // title: Text(
        //   "Login Screen",
        //   style: TextStyle(
        //     fontSize: 50.0,
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                      onSubmit: (value) {
                        print(value);
                      },
                      onChange: (value) {
                        print(value);
                      },
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validated: (String value) {
                        if (value.isEmpty) {
                          return 'Email Address must not be empty';
                        }
                        return null;
                      },
                      prefix: Icons.email,
                      label: 'Email'),
                  SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                    onSubmit: (value) {
                      print(value);
                    },
                    onChange: (value) {
                      print(value);
                    },
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    validated: (String value) {
                      if (value.isEmpty) {
                        return 'Password must not be empty';
                      }
                      return null;
                    },
                    suffix:
                        isPassword ? Icons.visibility : Icons.visibility_off,
                    suffixPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    isPassword: isPassword,
                    prefix: Icons.lock,
                    label: 'Password',
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  defaultButton(
                      function: () {
                        if (formKey.currentState.validate()) {
                          print(emailController.text);
                          print(passwordController.text);
                        }
                      },
                      isUpperCase: true,
                      radius: 20.0,
                      text: "login"),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t Have An Account? '),
                      TextButton(
                        onPressed: () {},
                        child: Text('Register Now'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
