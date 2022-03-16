import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class OfferContainer extends StatelessWidget {
  final Offer offer;
  const OfferContainer({Key? key, required this.offer}) : super(key: key);

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
              fit: BoxFit.cover,
              image: AssetImage(offer.imgLocation)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(margin: const EdgeInsets.only(top:20),child: AppText(text: offer.title,colour: Colors.white,)),
          AppText(text:offer.location, colour: Colors.white,)
        ],
      ),
    );
  }
}
