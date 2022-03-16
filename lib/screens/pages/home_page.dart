import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
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
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Menu icon and profile name
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Icon(Icons.menu, size: 30, color: Colors.black),
                Expanded(child: Container()),
                Container(
                  width: 80,
                  child: AppText(text: 'Hi ' + profileName + '!'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          //Cards text
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: AppLargeText(
              text: 'Cards',
              size: 25,
            ),
          ),

          //SizedBox(height: 20),
          //Cards
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                children: List.generate(cardList.length, (index) {
                  return FutureBuilder(
                    future: cardList[index]!.bankName == 'NAB'? getNABData():getAccountBalance(cardList[index]!.bankName, cardList[index]!.identification),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        //Update the balance of each card..
                        if(cardList[index]!.bankName == 'NAB'){
                          NABAccountBalance nab = snapshot.data as NABAccountBalance;
                          var balance = nab.availableBalance;
                          cardList[index]!.balance = double.parse(balance!);
                        }else{
                          AccountBalance bal = snapshot.data as AccountBalance;
                          var balance = bal.amount;
                          cardList[index]!.balance = double.parse(balance!);
                        }
                        Hive.box<TensoAccount>(tenso_db_box).putAt(index, cardList[index]!);
                        return InkWell(
                          onTap: () {
                            BlocProvider.of<AppCubit>(context)
                                .goToCardDetailPage(mainAccount!,cardList[index]!, index);
                          },
                          child: CardComponent(tensoAccount: cardList[index]!),
                        );
                      }else if(snapshot.hasError){
                        return AppText(text: 'Error: ${snapshot.error}');
                      }else{
                        return Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting result...'),
                            )
                          ],
                        );
                      }
                    }
                  );
                }),
              )),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: AppLargeText(
              text: 'Discover',
              size: 25,
            ),
          ),
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
            height: 250,
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
                        child: OfferContainer(offer: places[index]));
                  },
                ),
                //Experiences
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: experiences.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          BlocProvider.of<AppCubit>(context)
                              .goToOfferDetail(experiences[index], index, false);
                        },
                        child: OfferContainer(offer: experiences[index]));
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
                              .goToShoppingOfferDetail(shopping[index], index, false);
                        },
                        child: ShoppingContainer(
                          shoppingOffer: shopping[index],
                        ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
