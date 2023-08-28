import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/models/favorites_model.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/components.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (BuildContext context) {
            final favoritesModel = ShopCubit.get(context).favoritesModel;

            if (favoritesModel != null && favoritesModel.data != null) {
              final favoritesDataList = favoritesModel.data!.data;

              if (favoritesDataList!.isNotEmpty) {
                return ListView.separated(
                  itemBuilder: (context, index) =>
                      buildFavItem(favoritesDataList[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: favoritesDataList!.length,
                );
              } else {
                return Center(
                  child: Text("No favorites available.",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text("No favorites available.",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
          fallback: (BuildContext context) => CircularProgressIndicator(),
        );
      },
    );
  }
  Widget buildFavItem(FavoritesData model,context)=>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.product.image),
                width: 120.0 ,
                height: 120.0,
              ),
              if(model.product.discount!=0)
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: 8.0,
                      color: Colors.white,
                    ),
                  ),
                ),

            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.product.name,
                  maxLines: 2,
                  overflow:TextOverflow.ellipsis ,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),

                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.product.price.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blue,
                      ),

                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    if(model.product.discount!=0)
                      Text(
                        model.product.oldPrice.toString(),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),

                      ),
                    Spacer(),
                    IconButton(
                      onPressed: ()
                      {
                          ShopCubit.get(context).changeFavorites(model.product.id);
                      },
                      icon:CircleAvatar(
                        radius:15.0 ,
                        backgroundColor: ShopCubit.get(context).favorites[model.product.id] == true ? Colors.blue : Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ), )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
