import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class ShoppingContainer extends StatelessWidget {
  final ShoppingOffer shoppingOffer;
  final Size size;
  final bool islast;
  const ShoppingContainer({Key? key, required this.shoppingOffer, required this.size, required this.islast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.05, right: islast ? size.width * 0.05 : 0, bottom: size.width * 0.05, top: size.width * 0.02),
      height: size.width * 0.6,
      width: size.width * 0.65,
      decoration: BoxDecoration(
          color: const Color(0xffE6EFF2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(shoppingOffer.imgLocation)),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.width * 0.02),
            child: AppText(text:shoppingOffer.description, colour: Colors.black54,),
          )
        ],
      ),
    );
  }
}
