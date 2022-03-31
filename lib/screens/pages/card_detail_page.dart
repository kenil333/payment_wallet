import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/tenso_transaction.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/card_detail_transaction.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

import '../../data/spinkit/spinkit.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({Key? key}) : super(key: key);

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  String profileName = 'Rose';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 25,
          ),
          //back button and page title
          Container(
              margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
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
                  BlocBuilder<AppCubit, CubitState>(
                    builder: (context, state) {
                      if (state is CardDetailState) {
                        var bankName = state.account.bankName;
                        return AppText(
                            text: bankName + ' Card details',
                            colour: Colors.black.withOpacity(0.8));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),),
          SizedBox(
            height: size.width * 0.07,
          ),
          Expanded(
            child: BlocBuilder<AppCubit, CubitState>(
              builder: (context, state) {
                if (state is CardDetailState) {
                  var account = state.account;
                  var mainAccount = state.mainAccount;
                  print(state.account.identification);
                  //Card balance and transactions are called here.. See card_detail_transaction in Widget folder
                  return SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Center(
                      child: FutureBuilder(
                        future: getTransactions(
                            account.bankName, account.identification),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TensoTransaction>>
                                snapshot) {
                          if (snapshot.hasData) {
                            return CardDetails(
                              mainAccount: mainAccount,
                              tensoAccount: account,
                              transactions: snapshot.data,
                              index: state.index,
                              size: size,
                            );
                          } else if (snapshot.hasError) {
                            return AppText(
                                text: 'Error: ${snapshot.error}');
                          } else {
                            return const SizedBox(
                              width: 60,
                              height: 60,
                              child: spinkit,
                            );
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
