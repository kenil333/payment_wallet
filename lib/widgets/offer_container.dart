import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class OfferContainer extends StatelessWidget {
  final Offer offer;
  final Size size;
  final bool islast;
  const OfferContainer({Key? key, required this.offer, required this.size, required this.islast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.05, right: islast ? size.width * 0.05 : 0, bottom: size.width * 0.05, top: size.width * 0.02),
      height: size.width * 0.6,
      width: size.width * 0.65,
      decoration: BoxDecoration(
        color: const Color(0xFFEBF4F8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
          borderRadius: BorderRadius.circular(10),
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
                      fit: BoxFit.cover,
                      image: AssetImage(offer.imgLocation)),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.width * 0.01),
            child: Column(
              children: [
                Text(offer.title, style: TextStyle(fontSize: size.width * 0.04, color: Colors.black87),maxLines: 1, overflow: TextOverflow.ellipsis,),
                SizedBox(height: size.width * 0.002),
                Text(offer.location, style: TextStyle(fontSize: size.width * 0.036, color: Colors.black54),maxLines: 1, overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
