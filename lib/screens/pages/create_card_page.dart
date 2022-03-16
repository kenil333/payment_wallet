import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/models/account_creation.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';
import 'package:tensopay_wallet_prototype/widgets/responsive_button.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';
import 'dart:math' as math;

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({Key? key}) : super(key: key);

  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  String _value = 'cibc';
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
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
                            if (state is CreateCardState) {
                              return AppText(
                                  text: 'Create a card',
                                  colour: Colors.black54.withOpacity(0.8));
                            } else {
                              return Container();
                            }
                          },
                        )),
                  ],
                )),
            SizedBox(height: 20),
            //Drop down menu
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLargeText(text: 'Please select a bank:'),
                  SizedBox(
                    height: 20,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      //background color of dropdown button
                      border: Border.all(color: Colors.black38, width: 3),
                      //border of dropdown button
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: DropdownButton(
                          value: _value,
                          items: [
                            //add items in the dropdown
                            DropdownMenuItem(
                                child: Text('CIBC'), value: 'cibc'),
                            DropdownMenuItem(
                                child: Text('NatWest'), value: 'natwest'),
                            DropdownMenuItem(
                                child: Text('ITAU'), value: 'itau'),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            //_onCreate(context,'$value');
                            setState(() {
                              _value = value!;
                              selected = true;
                              //print(_value);
                            });
                          },
                          icon: Padding(
                              //Icon at tail, arrow bottom is default icon
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.arrow_circle_down_sharp)),
                          iconEnabledColor: Colors.white,
                          //Icon color
                          style: TextStyle(
                              //te
                              color: Colors.white, //Font color
                              fontSize: 20 //font size on dropdown button
                              ),
                          dropdownColor:
                              Colors.redAccent, //dropdown background color
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            selected ? _createSelectedCardText(context, _value) : Container(),
          ],
        ),
      ),
    );
  }
}

Container _createSelectedCardText(BuildContext context, String bankName) {
  String _value = 'CIBC';
  if (bankName == 'natwest') {
    _value = 'NatWest';
  } else if (bankName == 'itau') {
    _value = 'ITAU';
  }
  return Container(
    width: double.maxFinite,
    height: 300,
    margin: const EdgeInsets.only(left: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText(
          text: 'Tap the + button to create a ' + _value + ' card: ',
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {
              _onCreate(context, bankName);
            },
            hoverColor: Colors.blueAccent.withOpacity(0.5),
            child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ))),
      ],
    ),
  );
}

void _onCreate(context, String _bank) async {
  print('Bank selected' + _bank);
  String apiUrl = '';
  String bankName = '';
  if (_bank == 'cibc') {
    apiUrl =
        'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/openAccountCIBC';
    bankName = 'CIBC';
  } else if (_bank == 'itau') {
    apiUrl =
        'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/openAccountITAU';
    bankName = 'ITAU';
  } else if (_bank == 'natwest') {
    apiUrl =
        'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/openAccountNatWest';
    bankName = 'NatWest';
  }

  //Create a blocking bottom modal.
  showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.grey.withOpacity(0.5),
      barrierColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height / 4 + 200,
          color: Colors.white.withOpacity(0.7),
          child: FutureBuilder(
            future: postCreateAccount(apiUrl, 'Rose'),
            builder: (BuildContext bc,
                AsyncSnapshot<AccountCreation> snapshot) {
              if (snapshot!.hasData) {
                TensoAccount newAccount = new TensoAccount(
                    accountId: snapshot.data!.account.accountId,
                    description: snapshot.data!.account.description,
                    currency: snapshot.data!.account.currency,
                    identification: snapshot.data!.account.identification,
                    accountType: snapshot.data!.account.accountType,
                    accountSubType: snapshot.data!.account.accountSubType,
                    nickname: snapshot.data!.account.nickname,
                    validTill: snapshot.data!.card.validTill,
                    cardId: snapshot.data!.card.cardId,
                    cardNumber: snapshot.data!.card.cardNumber,
                    status: snapshot.data!.card.status,
                    balance: 0.00,
                    bankName: bankName,
                    colour: (math.Random().nextDouble() * 0xFFFFFF).toInt());

                //Open the hive box.
                var myAccounts = Hive.box<TensoAccount>(tenso_db_box);
                myAccounts.add(newAccount);
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    BlocProvider.of<AppCubit>(context).goToMainPage(0);
                  },
                  child: Container(
                      child: Column(
                    children: [
                      Icon(Icons.payment, size: 40,),
                      AppText(text: 'Account created! '),
                      AppText(
                        text: 'done!',
                      ),
                    ],
                  )),
                );
              } else {
                return Column(
                  children: [
                    AppText(text: 'Creating...'),
                    SizedBox(height: 50,),
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator()),
                  ],
                );
              }
            },
          ),
        );
      });
  /*
  AccountCreation accountCreation = await postCreateAccount(apiUrl, 'Rose');

  TensoAccount newAccount = new TensoAccount(
      accountId: accountCreation.account.accountId,
      description: accountCreation.account.description,
      currency: accountCreation.account.currency,
      identification: accountCreation.account.identification,
      accountType: accountCreation.account.accountType,
      accountSubType: accountCreation.account.accountSubType,
      nickname: accountCreation.account.nickname,
      validTill: accountCreation.card.validTill,
      cardId: accountCreation.card.cardId,
      cardNumber: accountCreation.card.cardNumber,
      status: accountCreation.card.status,
      balance: 0.00,
      bankName: bankName,
      colour: (math.Random().nextDouble() * 0xFFFFFF).toInt());

  //Open the hive box.
  var myAccounts = Hive.box<TensoAccount>(tenso_db_box);
  myAccounts.add(newAccount);
  String response = 'A '+ newAccount.bankName + ' card is created successfully!';
  ScaffoldMessenger.of(context).showSnackBar(
      _createSnackBar(context, response));

   */
}

SnackBar _createSnackBar(BuildContext context, String response) {
  //Persisting snackbar
  return SnackBar(
    content: Text(response),
    action: SnackBarAction(
      onPressed: () {
        BlocProvider.of<AppCubit>(context).goToMainPage(0);
      },
      label: 'done',
    ),
    //duration: Duration(days: 1),
  );
}
