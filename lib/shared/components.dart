

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/cubit.dart';
import '../modules/login/shop_login_screen.dart';
import '../network/cache_helper.dart';


Widget buildArticleItem(article,context)=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0,),
          image: DecorationImage(
            image: NetworkImage('${article['urlToImage']}'),
  //https://previews.123rf.com/images/ionutparvu/ionutparvu1612/ionutparvu161200915/67602462-business-stamp-sign-text-word-logo-blue.jpg
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Container(
          height: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${article['title']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis ,
                ),
              ),
              Text(
                '${article['publishedAt']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

Widget myDivider()=> Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

void navigateTo(context,widget)=> Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=>widget),
);

void navigateAndFinish(context,widget)=>
    Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
      builder: (context)=>widget,
  ),
        (Route<dynamic> route)=>false

    );

void showToast({
  required String text,
  required ToastStates state,

})=> Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates{SUCCESS,ERROR,WARNING}

Color ?chooseToastColor(ToastStates state)
{
  Color ?color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

void signOut(context)
{
  CacheHelper.removeData(key: 'token',).then((value) =>{
    if(value!)
      {
        navigateAndFinish(context,ShopLoginScreen()),
      }
  });
}
String token= '';

Widget buildListProduct(
    model,
    context, {
      bool isOldPrice = true,
    }) =>
    Padding(
padding: const EdgeInsets.all(20.0),
child: Container(
height: 120.0,
child: Row(
children: [
Stack(
alignment: AlignmentDirectional.bottomStart,
children: [
Image(
image: NetworkImage(model.image),
width: 120.0,
height: 120.0,
),
if (model.discount != 0 && isOldPrice)
Container(
color: Colors.red,
padding: EdgeInsets.symmetric(
horizontal: 5.0,
),
child: Text(
'DISCOUNT',
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
model.name,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 14.0,
height: 1.3,
),
),
Spacer(),
Row(
children: [
Text(
model.price.toString(),
style: TextStyle(
fontSize: 12.0,
color: Colors.blue,
),
),
SizedBox(
width: 5.0,
),
if (model.discount != 0 && isOldPrice)
Text(
model.oldPrice.toString(),
style: TextStyle(
fontSize: 10.0,
color: Colors.grey,
decoration: TextDecoration.lineThrough,
),
),
Spacer(),
IconButton(
onPressed: () {
ShopCubit.get(context).changeFavorites(model.id);
},
icon: CircleAvatar(
radius: 15.0,
backgroundColor:
ShopCubit.get(context).favorites[model.id]==true
? Colors.blue
    : Colors.grey,
child: Icon(
Icons.favorite_border,
size: 14.0,
color: Colors.white,
),
),
),
],
),
],
),
),
],
),
),
    );