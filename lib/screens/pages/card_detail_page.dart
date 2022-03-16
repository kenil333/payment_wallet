import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/tenso_transaction.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/widgets/card_detail_transaction.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({Key? key}) : super(key: key);

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage>  {
  String profileName = 'Rose';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back button and page title
            Container(
                margin: const EdgeInsets.only(top: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<AppCubit>(context).goToMainPage(0);
                        },
                        icon: Icon(Icons.menu)),
                    Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: BlocBuilder<AppCubit, CubitState>(
                          builder: (context, state) {
                            if (state is CardDetailState) {
                              var bankName = state.account.bankName;
                              return AppText(
                                  text: bankName + ' Card details',
                                  colour: Colors.black54.withOpacity(0.8));
                            } else {
                              return Container();
                            }
                          },
                        )),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<AppCubit, CubitState>(
                builder: (context, state) {
                  if (state is CardDetailState) {
                    var account = state.account;
                    var mainAccount = state.mainAccount;
                    print(state.account.identification);
                    //Card balance and transactions are called here.. See card_detail_transaction in Widget folder
                    return Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Center(
                            child: FutureBuilder(
                          future: getTransactions(account.bankName, account.identification),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<TensoTransaction>> snapshot) {
                            if (snapshot.hasData) {
                              return CardDetails(
                                  mainAccount: mainAccount,
                                  tensoAccount: account,
                                  transactions: snapshot!.data,
                                  index:state.index,
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
                          },
                        )));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
