import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tensopay_wallet_prototype/screens/pages/top_up_page.dart';

import '../../cubit/app_cubit_states.dart';
import '../../cubit/app_cubits.dart';
import '../../data/spinkit/spinkit.dart';
import '../../models/rate.dart';
import '../../models/rate_data.dart';
import '../../models/tenso_bank_account.dart';
import '../../utils/api_helper.dart';
import '../../utils/tenso_colours.dart';
import '../../utils/tenso_constants.dart';
import '../../widgets/tenso_text.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key}) : super(key: key);

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  double balance = 0;
  double finalAmount = 0;
  double rate = 0;
  bool isloading = false;
  bool isclicked = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AppCubit, CubitState>(
      builder: (context, state) {
        if (state is ConfirmState) {
          var mainAccount = state.mainAccount;
          var account = state.account;
          var bankName = state.account.bankName;
          var index = 1;
          String amount = state.amount;
          String res = state.res;
          balance = state.account.balance;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: size.width * 0.05, right: size.width * 0.05),
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
                        AppText(text: 'Confirm', colour: Colors.black)
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (isloading)
                          ? Container(
                              height: size.width * 0.3,
                              width: size.width,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: SizedBox(
                                height: size.width * 0.2,
                                width: size.width * 0.2,
                                child: spinkit,
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: 0,
                                  child: Container(
                                    height: 80,
                                    width: size.width * 0.32,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Lightning.gif"),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: size.width * 0.2,
                                          width: size.width * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                (mainAccount.bankName == "NAB")
                                                    ? "assets/images/nab.png"
                                                    : (mainAccount.bankName ==
                                                            "NatWest")
                                                        ? "assets/images/netwest.png"
                                                        : (mainAccount
                                                                    .bankName ==
                                                                "CIBC")
                                                            ? "assets/images/cibc.png"
                                                            : "assets/images/itau.png",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // border: Border.all(
                                            //     width: 2,
                                            //     color: AppColours.buttoncolor),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        AppText(
                                          text: 'Available fund: ',
                                          size: size.width * 0.04,
                                          colour:
                                              Colors.black54.withOpacity(0.6),
                                        ),
                                        AppText(
                                          text: getCurrencyAmount(
                                              context,
                                              mainAccount.currency,
                                              mainAccount.balance),
                                          size: size.width * 0.045,
                                          colour: AppColours.buttoncolor
                                              .withOpacity(0.9),
                                          weight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: size.width * 0.2,
                                          width: size.width * 0.3,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                (account.bankName == "NAB")
                                                    ? "assets/images/nab.png"
                                                    : (account.bankName ==
                                                            "NatWest")
                                                        ? "assets/images/netwest.png"
                                                        : (account.bankName ==
                                                                "CIBC")
                                                            ? "assets/images/cibc.png"
                                                            : "assets/images/itau.png",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // border: Border.all(
                                            //     width: 2,
                                            //     color: AppColours.buttoncolor),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        AppText(
                                          text: 'Your Balance: ',
                                          size: size.width * 0.04,
                                          colour:
                                              Colors.black54.withOpacity(0.6),
                                        ),
                                        AppText(
                                          text: getCurrencyAmount(
                                              context,
                                              state.account.currency,
                                              state.account.balance),
                                          size: size.width * 0.045,
                                          colour: AppColours.buttoncolor
                                              .withOpacity(0.9),
                                          weight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        height: size.height * 0.05,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: Colors.black87.withOpacity(0.4)),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Amount You Pay: ",
                              style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black87.withOpacity(0.6)),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Text(
                              amount,
                              style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  color:
                                      AppColours.buttoncolor.withOpacity(0.9),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<RateData>(
                          stream: generateRateStream(state.account.currency),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Rate rateData = snapshot.data!.rate;
                              rate = rateData.rate;
                              return Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.1),
                                            padding: EdgeInsets.only(
                                                top: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.07,
                                                    ),
                                                    AppText(
                                                      text: 'Available fund: ',
                                                      size: size.width * 0.04,
                                                      colour: Colors.black54,
                                                    ),
                                                    AppText(
                                                      text: getCurrencyAmount(
                                                          context,
                                                          mainAccount.currency,
                                                          mainAccount.balance),
                                                      size: size.width * 0.045,
                                                      colour: AppColours
                                                          .buttoncolor
                                                          .withOpacity(0.9),
                                                      weight: FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.009,
                                                ),
                                                Container(
                                                  height: 1,
                                                  width: size.width * 0.6,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  margin: EdgeInsets.only(
                                                      left: size.width * 0.05),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: size.width * 0.094,
                                            top: size.width * 0.034,
                                            child: Container(
                                              height: 7,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.1),
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.008),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.07,
                                                ),
                                                AppText(
                                                  text: 'Exchange rate: ',
                                                  size: size.width * 0.038,
                                                  colour: Colors.black87
                                                      .withOpacity(0.4),
                                                ),
                                                AppText(
                                                  text: getCurrencyAmount(
                                                          context,
                                                          mainAccount.currency,
                                                          1.00) +
                                                      ' is ' +
                                                      getCurrencyAmount(
                                                          context,
                                                          state
                                                              .account.currency,
                                                          rateData.rate),
                                                  size: size.width * 0.041,
                                                  colour: Colors.black87
                                                      .withOpacity(0.7),
                                                  weight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: size.width * 0.094,
                                            top: size.width * 0.031,
                                            child: Container(
                                              height: 7,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.1),
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.008),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.07,
                                                ),
                                                AppText(
                                                  text: 'Fees: ',
                                                  size: size.width * 0.038,
                                                  colour: Colors.black87
                                                      .withOpacity(0.5),
                                                ),
                                                AppText(
                                                  text: "AUD 0.00",
                                                  size: size.width * 0.041,
                                                  colour: Colors.black87
                                                      .withOpacity(0.7),
                                                  weight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: size.width * 0.094,
                                            top: size.width * 0.031,
                                            child: Container(
                                              height: 7,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.1),
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.008),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.07,
                                                ),
                                                AppText(
                                                  text: 'Total Fees: ',
                                                  size: size.width * 0.038,
                                                  colour: Colors.black54
                                                      .withOpacity(0.5),
                                                ),
                                                AppText(
                                                  text: "AUD 0.00",
                                                  size: size.width * 0.041,
                                                  colour: Colors.black87
                                                      .withOpacity(0.7),
                                                  weight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: size.width * 0.094,
                                            top: size.width * 0.031,
                                            child: Container(
                                              height: 7,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.1),
                                            padding: EdgeInsets.only(
                                                bottom: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 1,
                                                  width: size.width * 0.6,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  margin: EdgeInsets.only(
                                                      left: size.width * 0.05),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.009,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.07,
                                                    ),
                                                    AppText(
                                                      text: 'Your Balance: ',
                                                      size: size.width * 0.04,
                                                      colour: Colors.black54,
                                                    ),
                                                    AppText(
                                                      text: getCurrencyAmount(
                                                          context,
                                                          state
                                                              .account.currency,
                                                          state
                                                              .account.balance),
                                                      size: size.width * 0.045,
                                                      colour: AppColours
                                                          .buttoncolor
                                                          .withOpacity(0.9),
                                                      weight: FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: size.width * 0.094,
                                            top: size.width * 0.034,
                                            child: Container(
                                              height: 7,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "Error: " + "${snapshot.error}",
                                style: const TextStyle(color: Colors.white70),
                              );
                            }
                            return Container(
                              height: size.height * 0.185,
                              width: size.width,
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 60,
                                height: 60,
                                child: spinkit,
                              ),
                            );
                          }),
                      Container(
                        height: size.height * 0.05,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: Colors.black54.withOpacity(0.4)),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Amount Recipient get: ",
                              style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black87.withOpacity(0.6)),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Text(
                              res,
                              style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  color:
                                      AppColours.buttoncolor.withOpacity(0.9),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: GestureDetector(
                            onTap: () async {
                              isclicked = true;
                              isloading = true;
                              setState(() {});
                              print('Old Balance : ' + '$balance');
                              String response = await postTransfer(
                                  state.account.bankName,
                                  state.account.identification,
                                  amount,
                                  'Top-up: ' + amount);
                              balance += finalAmount;
                              print('Balance: ' + '$balance');
                              state.account.balance = balance;
                              mainAccount.balance -= double.parse(amount);
                              print('NAB balance :' +
                                  mainAccount.balance.toStringAsFixed(2));
                              isloading = false;
                              setState(() {});
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context1) {
                                    return alert(
                                      context,
                                      response,
                                      mainAccount,
                                      state.account,
                                      state.index,
                                      size,
                                    );
                                  });
                              debugPrint("goto card detail page");
                              isclicked = false;
                              setState(() {});
                            },
                            child: Container(
                              width: size.width,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: (isclicked)
                                    ? Colors.white
                                    : AppColours.buttoncolor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: AppText(
                                text: 'Confirm',
                                colour: Colors.white,
                                size: 20,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

Widget alert(BuildContext context, String response, TensoAccount mainAccount,
    TensoAccount account, int index, Size size) {
  Hive.box<TensoAccount>(tenso_db_box).putAt(index, account);
  int? mainAccount_index = findMainAccountIndex();
  Hive.box<TensoAccount>(tenso_db_box).putAt(mainAccount_index!, mainAccount);
  return Center(
    child: Container(
      padding: const EdgeInsets.all(20),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: const AssetImage("assets/images/check.png"),
            height: size.width * 0.2,
            width: size.width * 0.2,
            fit: BoxFit.contain,
            color: AppColours.buttoncolor,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            response,
            style: TextStyle(
                fontSize: size.width * 0.07,
                color: AppColours.buttoncolor,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<AppCubit>(context)
                      .goToCardDetailPage(mainAccount, account, index);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    ),
  );
  //   AlertDialog(
  //   title: Image(image: const AssetImage("assets/images/transaction.png"),height: size.width * 0.2, width: size.width * 0.2, fit: BoxFit.contain),
  //   content: Text(response, style: TextStyle(fontSize: size.width * 0.07, color: (response == "Successful") ? Colors.green : Colors.red, fontWeight: FontWeight.w600),),
  //   alignment: Alignment.center,
  //   actions: [
  //     TextButton(
  //       onPressed: () {
  //         Navigator.pop(context);
  //         BlocProvider.of<AppCubit>(context)
  //             .goToCardDetailPage(mainAccount, account, index);
  //       },
  //       child: const Text("Done"),
  //     ),
  //   ],
  // );
}
