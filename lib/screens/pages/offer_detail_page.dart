import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/responsive_button.dart';
import 'package:tensopay_wallet_prototype/widgets/square_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class OfferDetailPage extends StatefulWidget {
  const OfferDetailPage({Key? key}) : super(key: key);

  @override
  _OfferDetailPageState createState() => _OfferDetailPageState();
}

class _OfferDetailPageState extends State<OfferDetailPage> {
  //int reviewRating = 4;
  bool faved = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, CubitState>(builder: (context, state) {
      if (state is OfferDetailState) {
        Offer _offer = state.offer;
        print('Offer detail '+ '${state.fromOfferPage}');
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  //color: Colors.blue,
                  height: 350.0,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_offer.imgLocation),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<AppCubit>(context).goToMainPage(state.fromOfferPage?3:0);
                    },
                    icon: Icon(Icons.menu),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 320,
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
                       /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppLargeText(
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

                        */
                        AppLargeText(
                          text: _offer.title,
                          colour: Colors.black.withOpacity(0.8),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColours.mainColour,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                AppText(
                                  //text: 'California, USA',
                                  text: _offer.location,
                                  colour: AppColours.textColour2,
                                ),
                              ],
                            ),
                            AppLargeText(
                              //text: '\$ 250',
                              text: _offer.price,
                              colour: AppColours.mainColour,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Wrap(
                              children: List.generate(5, (pos) {
                                return Icon(
                                  Icons.star,
                                  color: pos < _offer.review
                                      ? Colors.yellow
                                      : Colors.grey,
                                );
                              }),
                            ),
                            AppText(
                              text: '(4.0)',
                              colour: AppColours.textColour2,
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        AppLargeText(text: 'Description'),
                        SizedBox(
                          height: 10,
                        ),
                        AppText(
                            size: 12,
                            //text:
                             //   'Yosemite National Park is in California’s Sierra Nevada mountains. It’s famed for its giant, ancient sequoia trees, and for Tunnel View, the iconic vista of towering Bridalveil Fall and the granite cliffs of El Capitan and Half Dome. In Yosemite Village are shops, restaurants, lodging, the Yosemite Museum and the Ansel Adams Gallery, with prints of the photographer’s renowned black-and-white landscapes of the area.'),
                          text: _offer.description),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
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
                          text: 'Find out more',
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
