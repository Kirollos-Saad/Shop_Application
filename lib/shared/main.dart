import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_application/cubit/cubit.dart';
import 'package:shop_application/layout/shop_layout.dart';
import 'package:shop_application/modules/login/shop_login_screen.dart';
import 'package:shop_application/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_application/shared/styles/themes.dart';
import '../network/cache_helper.dart';
import '../network/dio_helper.dart';
import 'bloc_observer.dart';
import 'components.dart';
import 'cubit.dart';
import 'states.dart';


void main() async
{  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
 await CacheHelper.init();
token = CacheHelper.getData(key: 'token');
 //bool? isDark= CacheHelper.getBoolean(key: 'isDark');

 runApp(MyApp());
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  // constructor
  // build

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
       // BlocProvider(create: (context)=>NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider(create: (context)=> AppCubit(),),
        BlocProvider (create: (context)=>ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),

      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {
          return   MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark? ThemeMode.dark:ThemeMode.light,
            home: OnBoardingScreen(),
          );

        },
      ),
    );
  }
}