import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/modules/login/shop_login_screen.dart';
import 'package:shop_application/modules/register/cubit/cubit.dart';

import '../../layout/shop_layout.dart';
import '../../network/cache_helper.dart';
import '../../shared/components.dart';
import '../login/cubit/cubit.dart';
import '../login/cubit/states.dart';
import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget
{
  var formKey= GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShopRegisterCubit() ,
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (BuildContext context, state) {
          if (state is ShopRegisterSuccessState )
          {
            if(state.LoginModel.status!)
            {
              print(state.LoginModel!.message);
              print(state.LoginModel.data!.token);
              CacheHelper.saveData(
                key: 'token',
                value: state.LoginModel.data!.token,).
              then((value) => {
                token= state.LoginModel.data!.token!,
                navigateAndFinish(context,ShopLoginScreen())
              });
              showToast(text: state.LoginModel.message, state: ToastStates.SUCCESS);


            } else
            {
              print(state.LoginModel.message);

              showToast(text: state.LoginModel.message, state: ToastStates.ERROR);
              navigateTo(context, ShopRegisterScreen());
            }
          }
        },
        builder: (BuildContext context, Object? state) {
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
                          'REGISTER',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          keyboardType:TextInputType.name ,
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return 'Please enter your name';
                            }
                          } ,
                          decoration: InputDecoration(
                            labelText:'User Name',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
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
                          obscureText: ShopRegisterCubit.get(context).isPassword,
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
                                  ShopRegisterCubit.get(context).changePasswordVisibility();
                                },
                                icon:Icon( ShopRegisterCubit.get(context).suffix) ),

                          ),
                          onFieldSubmitted:(value){
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: phoneController,
                          keyboardType:TextInputType.phone ,
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return 'Please enter your phone number';
                            }
                          } ,
                          decoration: InputDecoration(
                            labelText:'Phone',
                            prefixIcon: Icon(
                              Icons.phone,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is!ShopRegisterLoadingState ,
                          builder: (context)=> Container(
                            width:double.infinity,
                            height: 50.0,
                            child: MaterialButton(
                              onPressed: (){
                                if (formKey.currentState!.validate())
                                {
                                  ShopRegisterCubit.get(context).userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                    phone: phoneController.text,
                                  );
                               //   navigateTo(context, ShopLoginScreen());


                                }
                              },
                              child: Text(
                                'Register',
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




                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
