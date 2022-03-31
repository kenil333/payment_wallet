import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/data/spinkit/spinkit.dart';
import 'package:tensopay_wallet_prototype/models/account_balance.dart';
import 'package:tensopay_wallet_prototype/models/nab_account_balance.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/data_generator.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';
import 'package:tensopay_wallet_prototype/widgets/card_component.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/circle_pointer_tab.dart';
import 'package:tensopay_wallet_prototype/widgets/offer_container.dart';
import 'package:tensopay_wallet_prototype/widgets/shopping_container.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String profileName = 'Rose';

  //Find the nab account/ main account and update its balance..
  TensoAccount? mainAccount = findMainAccount();
  List<TensoAccount?> cardList = generateCards();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            //Menu icon and profile name
            Container(
              // height: size.height * 0.1,
              width: size.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F4F7),
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     offset: const Offset(1.5, 1.5),
                  //     color: Colors.grey.withOpacity(0.2),
                  //     blurRadius: 10,
                  //     spreadRadius: 2,
                  //   ),
                  // ],
              ),
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: size.width * 0.15,
                    width: size.width * 0.15,
                    margin: const EdgeInsets.only(left: 15, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSB8vuaWT6wGaoDz6T0UEilQ8wwcFO-hvserEgijbpPulSLBBpgbkxZBjwhUsU3ULuPazM&usqp=CAU'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: 'Hi ' + profileName + '!',
                          colour: Colors.black54.withOpacity(0.5),
                          size: size.width * 0.052,
                          weight: FontWeight.w500,
                        ),
                        AppText(
                          text: "Welcome Back!",
                          colour: Colors.black87.withOpacity(0.7),
                          size: size.width * 0.06,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.width * 0.1,
                    width: size.width * 0.1,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            //Cards text
            SizedBox(
              height: size.width * 0.03,
            ),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.05),
              child: AppLargeText(
                text: 'Cards',
                size: size.width * 0.065,
                colour: Colors.black87.withOpacity(0.7),
                weight: FontWeight.w600,
              ),
            ),

            SizedBox(height: size.width * 0.05),
            //Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(cardList.length, (index) {
                  return FutureBuilder(
                      future: cardList[index]!.bankName == 'NAB'
                          ? getNABData()
                          : getAccountBalance(cardList[index]!.bankName,
                              cardList[index]!.identification),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          //Update the balance of each card..
                          if (cardList[index]!.bankName == 'NAB') {
                            NABAccountBalance nab =
                                snapshot.data as NABAccountBalance;
                            var balance = nab.availableBalance;
                            cardList[index]!.balance = double.parse(balance);
                          } else {
                            AccountBalance bal =
                                snapshot.data as AccountBalance;
                            var balance = bal.amount;
                            cardList[index]!.balance = double.parse(balance);
                          }
                          Hive.box<TensoAccount>(tenso_db_box)
                              .putAt(index, cardList[index]!);
                          return InkWell(
                            onTap: () {
                              BlocProvider.of<AppCubit>(context)
                                  .goToCardDetailPage(
                                      mainAccount!, cardList[index]!, index);
                            },
                            child: CardComponent(
                              tensoAccount: cardList[index]!,
                              size: size,
                              profilename: profileName,
                              islast:
                                  (index == cardList.length - 1) ? true : false,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return AppText(text: 'Error: ${snapshot.error}');
                        } else {
                          return Container(
                            height: size.width * 0.52,
                            width: size.width * 0.85,
                            margin: EdgeInsets.only(
                                left: size.width * 0.05,
                                bottom: size.width * 0.05),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF4F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: size.width * 0.04, horizontal: 18),
                            child: const SizedBox(
                              width: 80,
                              height: 80,
                              child: spinkit,
                            ),
                          );
                        }
                      });
                }),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.05),
              child: AppLargeText(
                text: 'Discover',
                size: size.width * 0.065,
                colour: Colors.black87.withOpacity(0.7),
                weight: FontWeight.w600,
              ),
            ),
            //Tab bars
            Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelPadding: EdgeInsets.only(left: size.width * 0.05),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const CircleTabIndicator(
                  colour: AppColours.buttoncolor,
                  radius: 4.0,
                ),
                controller: _tabController,
                labelColor: AppColours.buttoncolor,
                unselectedLabelColor: Colors.black54,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Places'),
                  Tab(text: 'Experiences'),
                  Tab(text: 'Offers'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: size.width * 0.65,
              width: double.maxFinite,
              child: TabBarView(
                controller: _tabController,
                children: [
                  //Places
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: places.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<AppCubit>(context)
                              .goToOfferDetail(places[index], index, false);
                        },
                        child: OfferContainer(
                          offer: places[index],
                          size: size,
                          islast: (index == places.length - 1) ? true : false,
                        ),
                      );
                    },
                  ),
                  //Experiences
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: experiences.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context).goToOfferDetail(
                                experiences[index], index, false);
                          },
                          child: OfferContainer(
                            offer: experiences[index],
                            size: size,
                            islast: (index == experiences.length - 1)
                                ? true
                                : false,
                          ));
                    },
                  ),
                  //Offers
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shopping.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context)
                                .goToShoppingOfferDetail(
                                    shopping[index], index, false);
                          },
                          child: ShoppingContainer(
                            shoppingOffer: shopping[index],
                            size: size,
                            islast:
                                (index == shopping.length - 1) ? true : false,
                          ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
