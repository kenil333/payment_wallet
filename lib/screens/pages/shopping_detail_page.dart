import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/responsive_button.dart';
import 'package:tensopay_wallet_prototype/widgets/square_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class ShoppingOfferDetailPage extends StatefulWidget {
  const ShoppingOfferDetailPage({Key? key}) : super(key: key);

  @override
  _ShoppingOfferDetailPageState createState() => _ShoppingOfferDetailPageState();
}

class _ShoppingOfferDetailPageState extends State<ShoppingOfferDetailPage> {
  //int reviewRating = 4;
  bool faved = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, CubitState>(builder: (context, state) {
      if (state is ShoppingOfferDetailState) {
        ShoppingOffer _offer = state.offer;
        print('Shopping Offer detail '+ '${state.fromOfferPage}');
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                //Image container
                Container(
                  //color: Colors.blue,
                  height: 350.0,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(_offer.imgLocation),
                          fit: BoxFit.contain)),
                ),
                //back button
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<AppCubit>(context).goToMainPage(state.fromOfferPage?3:0);
                    },
                    icon: Icon(Icons.menu),
                    color: Colors.black,
                  ),
                ),
                //Title, price, and description..
                Positioned(
                  top: 300,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20,bottom:20),
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLargeText(
                            //text: 'Yosemite',
                            text: _offer.title,
                            colour: Colors.black.withOpacity(0.8),
                          ),
                          AppLargeText(
                            //text: '\$ 250',
                            text: _offer.price,
                            colour: AppColours.mainColour,
                          )
                        ],
                      ),
                    )),
                Positioned(
                  top: 350,
                  child: Container(
                    padding:
                    const EdgeInsets.only(top: 30, left: 20, right: 20),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 20),
                        AppLargeText(text: 'Description'),
                        SizedBox(
                          height: 10,
                        ),
                        AppText(
                            size: 12,
                            text: _offer.description),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                //Fave and shop buttons
                Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              faved = !faved;
                            });
                          },
                          child: AppSquareButton(
                            size: 60,
                            colour: faved
                                ? Colors.redAccent
                                : AppColours.mainColour,
                            backgroundColour: Colors.white,
                            borderColour: AppColours.mainColour,
                            isIcon: true,
                            icon:
                            faved ? Icons.favorite : Icons.favorite_border,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        AppResponsiveButton(
                          text: 'Shop now',
                          colour: AppColours.mainColour,
                          isResponsive: true,
                          textColour: Colors.white,
                        )
                      ],
                    )),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
