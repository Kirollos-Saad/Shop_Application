import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/cubit/cubit.dart';
import 'package:shop_application/cubit/states.dart';
import 'package:shop_application/modules/login/shop_login_screen.dart';
import 'package:shop_application/network/cache_helper.dart';
import 'package:shop_application/search/search_screeen.dart';

import '../shared/components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder:(context,state){
        var cubit=ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Hatly',
            ) ,
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              onTap: (int index){
                cubit.changeBottom(index);
              },
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ]),

        ) ;
      } ,

    );
  }
}
