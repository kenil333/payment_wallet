import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class ShoppingContainer extends StatelessWidget {
  final ShoppingOffer shoppingOffer;
  const ShoppingContainer({Key? key, required this.shoppingOffer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 5),
      height: 300,
      width: 200,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(shoppingOffer.imgLocation)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Container(margin: const EdgeInsets.only(top:20),child: AppText(text: shoppingOffer.title,colour: Colors.black,)),
          //AppText(text:shoppingOffer.price, colour: Colors.black,),
          AppText(text: shoppingOffer.description)
        ],
      ),
    );
  }
}
