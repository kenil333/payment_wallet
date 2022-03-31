import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class GenericOfferContainer extends StatelessWidget {
  Offer? offer;
  final Size size;
  ShoppingOffer? shoppingOffer;
  bool? isOffer;
  final int length;
  final int index;
  GenericOfferContainer({Key? key, this.isOffer = true, this.offer, this.shoppingOffer, required this.size, required this.index, required this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.width * 0.6,
      width:  size.width,
      margin: EdgeInsets.only(bottom: (index == (length-1)) ? size.width * 0.2 : size.width * 0.05,left: size.width * 0.05,right: size.width * 0.05, top: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0xFFEBF4F8),
          borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  image: DecorationImage(
                      fit: isOffer! ? BoxFit.fill : BoxFit.none,
                      image: AssetImage(isOffer!? offer!.imgLocation:shoppingOffer!.imgLocation)),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.width * 0.007),
            child: Column(
              children: [
                AppText(text: isOffer!? offer!.title:shoppingOffer!.title,colour: Colors.black,size: size.width * 0.038),
                AppText(text:isOffer!? offer!.location:shoppingOffer!.description,size: size.width * 0.035, colour: isOffer!?Colors.black54:Colors.black54,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
