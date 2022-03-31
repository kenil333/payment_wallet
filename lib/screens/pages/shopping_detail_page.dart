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
  _ShoppingOfferDetailPageState createState() =>
      _ShoppingOfferDetailPageState();
}

class _ShoppingOfferDetailPageState extends State<ShoppingOfferDetailPage> {
  //int reviewRating = 4;
  bool faved = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AppCubit, CubitState>(builder: (context, state) {
      if (state is ShoppingOfferDetailState) {
        ShoppingOffer _offer = state.offer;
        print('Shopping Offer detail ' + '${state.fromOfferPage}');
        return Scaffold(
          body: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  height: size.width * 0.9,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage(_offer.imgLocation),
                        fit: BoxFit.contain),
                  ),
                ),
                //back button
                Positioned(
                  top: size.width * 0.15,
                  left: size.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<AppCubit>(context).goToMainPage(0);
                    },
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                        color: AppColours.buttoncolor,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            width: 0.5, color: AppColours.buttoncolor),
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                //Title, price, and description..
                Positioned(
                  top: size.width * 0.75,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color(0xff036488),
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
                          colour: Colors.white,
                        ),
                        AppLargeText(
                          //text: '\$ 250',
                          text: _offer.price,
                          colour: Colors.white60,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: size.width * 0.9,
                  child: SingleChildScrollView(
                    child: Container(
                      height: size.height * 0.5,
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLargeText(text: 'Description'),
                          const SizedBox(
                            height: 10,
                          ),
                          AppText(
                              size: 16,
                              colour: Colors.black87,
                              text: _offer.description),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
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
                            colour:
                                faved ? Colors.redAccent : AppColours.buttoncolor,
                            backgroundColour: Colors.white,
                            borderColour: AppColours.buttoncolor,
                            isIcon: true,
                            icon:
                                faved ? Icons.favorite : Icons.favorite_border,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AppResponsiveButton(
                          text: 'Shop now',
                          colour: AppColours.buttoncolor,
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
