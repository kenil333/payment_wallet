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

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<TensoAccount?> cards = generateCards();
  TensoAccount? mainAccount = findMainAccount();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 70),
            child: AppText(
                text: ' Your Cards', colour: Colors.black54.withOpacity(0.8))),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Column(
            children: [
              AppText(
                text: 'Press the card to see the details',
                colour: Colors.black54.withOpacity(0.5),
                size: 12,
              ),
              AppText(
                text: 'Press the + button to create a new card',
                colour: Colors.black54.withOpacity(0.5),
                size: 12,
              ),
            ],
          ),
        ),
        Container(
            width: double.maxFinite,
            height: 300,
            margin: const EdgeInsets.only(top: 20, left: 25),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                    direction: Axis.vertical,
                    spacing: 20,
                    children: List.generate(cards.length, (index) {
                      return FutureBuilder(
                          future: cards[index]!.bankName == 'NAB'? getNABData():getAccountBalance(cards[index]!.bankName, cards[index]!.identification),
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              //Update the balance of each card..
                              if(cards[index]!.bankName == 'NAB'){
                                NABAccountBalance nab = snapshot.data as NABAccountBalance;
                                var balance = nab.availableBalance;
                                cards[index]!.balance = double.parse(balance!);
                              }else{
                                AccountBalance bal = snapshot.data as AccountBalance;
                                var balance = bal.amount;
                                cards[index]!.balance = double.parse(balance!);
                              }
                              Hive.box<TensoAccount>(tenso_db_box)
                                  .putAt(index, cards[index]!);
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<AppCubit>(context)
                                      .goToCardDetailPage(
                                          mainAccount!, cards[index]!, index);
                                },
                                child:
                                    CardComponent(tensoAccount: cards[index]!),
                              );
                            } else if (snapshot.hasError) {
                              return AppText(text: 'Error: ${snapshot.error}');
                            } else {
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
                          });
                    })))),
        SizedBox(
          height: 20,
        ),
        _buildAddCardButton(
            icon: Icon(Icons.add), color: Colors.black, context: context)
      ],
    ));
  }
}

// Build the FloatingActionButton
Container _buildAddCardButton({
  required Icon icon,
  required Color color,
  //required size,
  required BuildContext context,
}) {
  return Container(
    //margin: const EdgeInsets.only(right: 5.0),
    alignment: Alignment.center,
    child: FloatingActionButton(
      heroTag: 'crtCards',
      elevation: 2.0,
      onPressed: () {
        BlocProvider.of<AppCubit>(context).goToCreateCard();
      },
      backgroundColor: color,
      mini: false,
      child: icon,
    ),
  );
}


