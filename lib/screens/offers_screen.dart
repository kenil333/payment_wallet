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

class _OffersScreenState extends State<OffersScreen> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppLargeText(text: 'Discover'),
            SizedBox(height: 20,),
            //Tab bars
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelPadding: const EdgeInsets.only(left: 20, right: 20),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: CircleTabIndicator(
                      colour: AppColours.mainColour, radius: 4.0),
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Places'),
                    Tab(text: 'Experiences'),
                    Tab(text: 'Offers')
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: MediaQuery.of(context).size.height - 280,
              width: double.maxFinite,
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
                          child: GenericOfferContainer(offer: places[index]));
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
                          child: GenericOfferContainer(offer: experiences[index]));
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
                                .goToShoppingOfferDetail(shopping[index], index, true);
                          },
                          child: GenericOfferContainer(isOffer: false,
                            shoppingOffer: shopping[index],
                          ));
                    },
                  ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
}
