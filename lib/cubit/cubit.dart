import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/categories/categories_screeen.dart';
import 'package:shop_application/cubit/states.dart';
import 'package:shop_application/favorites/favorites_screeen.dart';
import 'package:shop_application/models/categories_model.dart';
import 'package:shop_application/models/change_favorites_model.dart';
import 'package:shop_application/models/favorites_model.dart';
import 'package:shop_application/models/home_model.dart';
import 'package:shop_application/models/login_model.dart';
import 'package:shop_application/network/dio_helper.dart';
import 'package:shop_application/network/end_points.dart';
import 'package:shop_application/products/products_screeen.dart';
import 'package:shop_application/settings/settings_screeen.dart';
import 'package:shop_application/shared/components.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then(
          (value) {
        homeModel = HomeModel.fromJson(value.data);
        favorites.clear();
        homeModel?.data?.products.forEach((element) {
          favorites[element.id] = element.inFavorites;
        });
        emit(ShopSuccessHomeDataState());
      },
    ).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then(
          (value) {
        categoriesModel = CategoriesModel.fromJson(value.data);
        emit(ShopSuccessCategoriesState());
      },
    ).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !(favorites[productId] ?? false);
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then(
          (value) {
        changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
        if (!(changeFavoritesModel?.status ?? true)) {
          favorites[productId] = !(favorites[productId] ?? false);
        } else {
          getFavorites();
          emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
        }
      },
    ).catchError((error) {
      favorites[productId] = !(favorites[productId] ?? false);
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then(
          (value) {
        favoritesModel = FavoritesModel.fromJson(value.data);
        emit(ShopSuccessGetFavoritesState());
      },
    ).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

 late ShopLoginModel userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then(
          (value) {
        userModel = ShopLoginModel.fromJson(value.data);
        emit(ShopSuccessUserDataState(userModel));
      },
    ).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then(
          (value) {
        userModel = ShopLoginModel.fromJson(value.data);
        emit(ShopSuccessUpdateUserState(userModel!));
      },
    ).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

}
