import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class GenericOfferContainer extends StatelessWidget {
  Offer? offer;
  ShoppingOffer? shoppingOffer;
  bool? isOffer;
  GenericOfferContainer({Key? key, this.isOffer = true, this.offer, this.shoppingOffer }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 5),
      height: 200,
      width: MediaQuery.of(context).size.width - 60,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          image: DecorationImage(
              fit: isOffer!?BoxFit.cover:BoxFit.contain,
              image: AssetImage(isOffer!? offer!.imgLocation:shoppingOffer!.imgLocation)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(margin: const EdgeInsets.only(top:20),child: AppText(text: isOffer!? offer!.title:shoppingOffer!.title,colour: Colors.white,)),
          AppText(text:isOffer!? offer!.location:shoppingOffer!.description, colour: isOffer!?Colors.white:Colors.black54,)
        ],
      ),
    );
  }
}
