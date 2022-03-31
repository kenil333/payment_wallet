import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/utils/data_generator.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/circle_pointer_tab.dart';
import 'package:tensopay_wallet_prototype/widgets/generic_offer_container.dart';
import 'package:tensopay_wallet_prototype/widgets/offer_container.dart';
import 'package:tensopay_wallet_prototype/widgets/shopping_container.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 25,
          ),
          Container(
            margin: EdgeInsets.only(left: size.width * 0.05),
            child: AppLargeText(
              text: 'Discover',
              colour: Colors.black87.withOpacity(0.7),
              size: size.width * 0.07,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(height: size.width * 0.005),
          //Tab bars
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              labelPadding: EdgeInsets.only(left: size.width * 0.05),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const CircleTabIndicator(
                  colour: AppColours.buttoncolor, radius: 4.0),
              controller: _tabController,
              labelColor: AppColours.buttoncolor,
              unselectedLabelColor: Colors.black54,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Places'),
                Tab(text: 'Experiences'),
                Tab(text: 'Offers')
              ],
            ),
          ),
          Expanded(
            child: Container(
              // height: size.height * 0.75,
              width: size.width,
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: TabBarView(
                controller: _tabController,
                children: [
                  //Places
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: places.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context)
                                .goToOfferDetail(places[index], index, true);
                          },
                          child: GenericOfferContainer(
                            offer: places[index],
                            size: size,
                            index: index,
                            length: places.length,
                          ));
                    },
                  ),
                  //Experiences
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: experiences.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context)
                                .goToOfferDetail(experiences[index], index, true);
                          },
                          child: GenericOfferContainer(
                            offer: experiences[index],
                            size: size,
                            index: index,
                            length: experiences.length,
                          ));
                    },
                  ),
                  //Offers
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: shopping.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<AppCubit>(context)
                              .goToShoppingOfferDetail(
                                  shopping[index], index, true);
                        },
                        child: GenericOfferContainer(
                          isOffer: false,
                          shoppingOffer: shopping[index],
                          size: size,
                          index: index,
                          length: shopping.length,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.width * 0.1,
          )
        ],
      ),
    );
  }
}
