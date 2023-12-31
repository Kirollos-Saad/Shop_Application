
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/search/cubit/states.dart';
import '../../models/search_model.dart';
import '../../network/dio_helper.dart';
import '../../network/end_points.dart';
import '../../shared/components.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value)
    {
      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}