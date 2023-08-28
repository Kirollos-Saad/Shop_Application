import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/cubit/cubit.dart';
import 'package:shop_application/cubit/states.dart';
import 'package:shop_application/shared/components.dart';

class SettingsScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state)
      {
      },
      builder: (BuildContext context, Object? state) {
       // // var model = ShopCubit.get(context).userModel;
       //
       //  nameController.text = ShopCubit.get(context).userModel!.data!.name!;
       //  emailController.text = ShopCubit.get(context).userModel!.data!.email!;
       //  phoneController.text = ShopCubit.get(context).userModel!.data!.phone!;

        return ConditionalBuilder(
          condition: true,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update your information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    if(state is ShopLoadingUpdateUserState)
                    LinearProgressIndicator(),
                    SizedBox(
                      height:20.0 ,
                    ),
                    TextFormField(
                     // initialValue:ShopCubit.get(context).userModel!.data!.name! ,
                      controller: nameController,
                      keyboardType:TextInputType.name,
                      validator:(value){
                        if(value!.isEmpty)
                        {
                          return 'Name must not be empty';
                        }
                        return null ;
                      } ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:'Name',
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    SizedBox(
                      height:20.0 ,
                    ),
                    TextFormField(
                     // initialValue:ShopCubit.get(context).userModel!.data!.email! ,
                      controller: emailController,
                      keyboardType:TextInputType.emailAddress,
                      validator:(value){
                        if(value!.isEmpty)
                        {
                          return 'Email must not be empty';
                        }
                        return null ;
                      } ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:'Email Address',
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                    SizedBox(
                      height:20.0 ,
                    ),
                    TextFormField(
                     // initialValue:ShopCubit.get(context).userModel!.data!.phone! ,
                      controller: phoneController,
                      keyboardType:TextInputType.phone,
                      validator:(value){
                        if(value!.isEmpty)
                        {
                          return 'Phone must not be empty';
                        }
                        return null ;
                      } ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:'Phone',
                        prefixIcon: Icon(
                          Icons.phone,
                        ),
                      ),
                    ),
                    SizedBox(
                      height:20.0 ,
                    ),
                    Container(
                      width:double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: (){
                          if(formKey.currentState!.validate())
                            {  ShopCubit.get(context).updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text);
                            }
                          if(state is ShopSuccessUpdateUserState)
                            {
                              showToast(
                                  text: 'Information updated successfully',
                                  state: ToastStates.SUCCESS);
                            }

                        },
                        child: Text(
                          'Update',
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
                    SizedBox(
                      height:20.0 ,
                    ),
                Container(
                  width:double.infinity,
                  height: 50.0,
                  child: MaterialButton(
                    onPressed: (){
                      signOut(context);
                    },
                    child: Text(
                      'Logout',
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
                  ],
                ),
              ),
            ),
          ),
          fallback: (BuildContext context) =>Center(child: CircularProgressIndicator()),

        );
      }


    );
  }
}
