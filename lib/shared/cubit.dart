import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/shared/states.dart';

import '../network/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super (AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isDark=false;
  void changeAppMode()
  {
    isDark=!isDark;
    CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
      emit(NewsChangeModeState());

    });
  }
}