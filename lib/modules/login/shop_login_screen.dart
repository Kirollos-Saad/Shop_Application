import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_application/layout/shop_layout.dart';
import 'package:shop_application/modules/login/cubit/cubit.dart';
import 'package:shop_application/network/cache_helper.dart';

import '../../shared/components.dart';
import '../register/shop_register_screen.dart';
import 'cubit/states.dart';

class ShopLoginScreen extends StatelessWidget {
 var formKey= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) =>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context,state){
          if (state is ShopLoginSuccessState )
            {
              if(state.loginModel.status!)
                {
                  print(state.loginModel.message);
                  print(state.loginModel.data!.token);
                  CacheHelper.saveData(
                    key: 'token',
                    value: state.loginModel.data!.token,).
                  then((value) => {
                    token= state.loginModel.data!.token!,
                    navigateAndFinish(context,ShopLayout())
                  });
                  showToast(text: state.loginModel.message, state: ToastStates.SUCCESS);


                } else
                  {
                    print(state.loginModel.message);

                    showToast(text: state.loginModel.message, state: ToastStates.ERROR);
                  }
            }
        },
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType:TextInputType.emailAddress ,
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return 'Please enter your email address';
                            }
                          } ,
                          decoration: InputDecoration(
                            labelText:'Email Address',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          obscureText: ShopLoginCubit.get(context).isPassword,
                          controller: passwordController,
                          keyboardType:TextInputType.visiblePassword ,
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return 'Password is too short';
                            }
                          } ,
                          decoration: InputDecoration(
                            labelText:'Password',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                                onPressed: (){
                               ShopLoginCubit.get(context).changePasswordVisibility();
                                },
                                icon:Icon( ShopLoginCubit.get(context).suffix) ),

                          ),
                          onFieldSubmitted:(value){
                            if (formKey.currentState!.validate())
                            {
                              ShopLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);

                            }
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState ,
                            builder: (context)=> Container(

                              width:double.infinity,
                              height: 50.0,
                              child: MaterialButton(
                                onPressed: (){
                               if (formKey.currentState!.validate())
                                 {
                                   ShopLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);

                                 }
                                },
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  3.0,
                                ),
                                color: Colors.blue,
                              ),
                            ),
                            fallback:(context)=> Center(child: CircularProgressIndicator()),
                        ),

                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                              onPressed: (){
                                navigateTo(
                                  context,
                                  ShopRegisterScreen(),
                                );
                              },
                              child:Text('register'),
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
        } ,

      ),
    );
  }
}
