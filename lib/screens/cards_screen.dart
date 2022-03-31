import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:nb_utils/src/extensions/widget_extensions.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/account_balance.dart';
import 'package:tensopay_wallet_prototype/models/nab_account_balance.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';
import 'package:tensopay_wallet_prototype/widgets/card_component.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

import '../data/spinkit/spinkit.dart';
import '../utils/tenso_colours.dart';
import '../widgets/tenso_large_text.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<TensoAccount?> cardList = generateCards();
  TensoAccount? mainAccount = findMainAccount();
  String profileName = "Rose";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 25,
            ),
            // const SizedBox(height: 20),
            AppLargeText(
                    text: 'Your Cards',
                    size: size.width * 0.065,
                    colour: Colors.black87.withOpacity(0.7),
                  weight: FontWeight.w600,
                ),
            SizedBox(
              height: size.width * 0.04,
            ),
            Column(
              children: [
                AppText(
                  text: 'Press the card to see the details',
                  colour: Colors.black54,
                  size: size.width * 0.038,
                ),
                AppText(
                  text: 'Press the + button to create a new card',
                  colour: Colors.black54,
                  size: size.width * 0.038,
                ),
                AppText(
                  text: 'Swipe left to remove a card',
                  colour: Colors.black54,
                  size: size.width * 0.038,
                ),
              ],
            ),
            SizedBox(
              height: size.width * 0.04,
            ),
            SizedBox(
              height: size.height * 0.73,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: List.generate(cardList.length, (index) {
                        return FutureBuilder(
                            future: cardList[index]!.bankName == 'NAB'
                                ? getNABData()
                                : getAccountBalance(cardList[index]!.bankName,
                                    cardList[index]!.identification),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                //Update the balance of each card..
                                if (cardList[index]!.bankName == 'NAB') {
                                  NABAccountBalance nab =
                                      snapshot.data as NABAccountBalance;
                                  var balance = nab.availableBalance;
                                  cardList[index]!.balance =
                                      double.parse(balance);
                                } else {
                                  AccountBalance bal =
                                      snapshot.data as AccountBalance;
                                  var balance = bal.amount;
                                  cardList[index]!.balance =
                                      double.parse(balance);
                                }
                                Hive.box<TensoAccount>(tenso_db_box)
                                    .putAt(index, cardList[index]!);
                                return InkWell(
                                  onTap: () {
                                    BlocProvider.of<AppCubit>(context)
                                        .goToCardDetailPage(mainAccount!,
                                            cardList[index]!, index);
                                  },
                                  child: Dismissible(
                                    key: Key(cardList[index]!.toString()),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      height: size.width * 0.52,
                                      color: Colors.red.shade500,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Text(
                                            " Delete",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onDismissed: (direction) {
                                      cardList.removeAt(index);
                                      setState(() {});
                                    },
                                    child: CardComponent(
                                      tensoAccount: cardList[index]!,
                                      size: size,
                                      profilename: profileName,
                                      islast: true,
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return AppText(text: 'Error: ${snapshot.error}');
                              } else {
                                return Container(
                                  height: size.width * 0.52,
                                  width: size.width * 0.85,
                                  margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05, bottom: size.width * 0.05),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF4F8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.width * 0.04,
                                      horizontal: 18),
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
                    _buildAddCardButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      color: AppColours.buttoncolor,
                      context: context,
                      size: size,
                    ),
                    SizedBox(height: size.width * 0.15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Build the FloatingActionButton
Widget _buildAddCardButton({
  required Icon icon,
  required Color color,
  required Size size,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      BlocProvider.of<AppCubit>(context).goToCreateCard();
    },
    child: Container(
      height: size.width * 0.145,
      width: size.width * 0.145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: AppColours.buttoncolor,
      ),
      child: icon,
    ),
  );

  //   Container(
  //   alignment: Alignment.center,
  //   child: FloatingActionButton(
  //     heroTag: 'crtCards',
  //     elevation: 2.0,
  //     onPressed: () {
  //       BlocProvider.of<AppCubit>(context).goToCreateCard();
  //     },
  //     backgroundColor: color,
  //     mini: false,
  //     child: icon,
  //   ),
  // );
}
