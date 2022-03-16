import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/src/extensions/widget_extensions.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/models/tenso_transaction.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/square_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';
import 'package:tensopay_wallet_prototype/widgets/transaction_component.dart';

class CardDetails extends StatelessWidget {
  final TensoAccount? mainAccount;
  final TensoAccount? tensoAccount;
  final List<TensoTransaction>? transactions;
  final int index;
  CardDetails({Key? key, required this.mainAccount, required this.tensoAccount, required this.transactions, required this.index}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          //Balance details
          Container(
            height:80,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColours.mainColour,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(margin: const EdgeInsets.only(left: 20),child: AppText(text: 'Your Balance:', colour: Colors.white)),
                    SizedBox(height: 5),
                    //AppText(text: tensoAccount!.currency + ' '+ tensoAccount!.balance.toStringAsFixed(2),colour: Colors.white)
                    AppText(text: getCurrencyAmount(context, tensoAccount!.currency, tensoAccount!.balance),colour: Colors.white)
                  ],
                ),
                tensoAccount!.bankName == 'NatWest' || tensoAccount!.bankName == 'ITAU'?Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: (){
                      BlocProvider.of<AppCubit>(context).goToTopUp(mainAccount!, tensoAccount!, index);
                    },
                    child: AppSquareButton(size: 60, colour: AppColours.textColour2, backgroundColour: Colors.white, borderColour: AppColours.textColour2,
                      isIcon: true, icon: Icons.add,),
                  ),
                ): Container(),
              ],
            ),
          ),
          SizedBox(height:20),
          //Recent Activity
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'Recent activity'),
                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward), color: Colors.lightBlueAccent,)
              ],
            ),
          ),
          //Transactions list
          Container(
            width: double.maxFinite,
            height: 400,
            margin: const EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: transactions!.map((transaction) {
                  return TransactionComponent(transaction: transaction);
                }).toList(),
              ).paddingAll(20),
            ),
          )
        ],
      ),
    );
  }
}
