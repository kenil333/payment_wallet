import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/data/spinkit/spinkit.dart';
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AppCubit>(context).goToMainPage(0);
                    },
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      margin: EdgeInsets.only(left: size.width * 0.05),
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
                  Container(
                      margin: EdgeInsets.only(right: size.width * 0.05),
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
              ),
              SizedBox(
                height: size.width * 0.05,
              ),
              //Drop down menu
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLargeText(
                      text: 'Please select a bank:',
                      size: size.width * 0.065,
                      colour: Colors.black87.withOpacity(0.7),
                      weight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: size.width * 0.1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(2, 2),
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: _value,
                          items: const [
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
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconEnabledColor: Colors.black,
                          //Icon color
                          style: TextStyle(
                              //te
                              color: Colors.black, //Font color
                              fontSize: size.width *
                                  0.048 //font size on dropdown button
                              ),
                          dropdownColor: Colors.white,
                          //dropdown background color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              selected ? _createSelectedCardText(context, _value, size) : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

Stack _createSelectedCardText(BuildContext context, String bankName, Size size) {
  String _value = 'CIBC';
  if (bankName == 'natwest') {
    _value = 'NatWest';
  } else if (bankName == 'itau') {
    _value = 'ITAU';
  }
  return Stack(
    alignment: Alignment.center,
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 22.5, left: 20, right: 20),
        decoration: BoxDecoration(
          color: AppColours.buttoncolor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: AppColours.buttoncolor,),
        ),
        child: AppText(
          text: 'Tap the + button to create a ' + _value + ' card: ',
          colour: Colors.white,
          size: size.width * 0.05,
        ),
      ),
      Positioned(
        bottom: 0,
        child: InkWell(
          onTap: () {
            _onCreate(context, bankName, size);
          },
          hoverColor: Colors.blueAccent.withOpacity(0.5),
          child: Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColours.buttoncolor, width: 1),
            ),
            child: const Icon(
              Icons.add,
              color: AppColours.buttoncolor,
            ),
          ),
        ),
      ),
    ],
  );
}

void _onCreate(context, String _bank, Size size) async {
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
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height / 4 + 200,
          color: Colors.white.withOpacity(0.7),
          child: FutureBuilder(
            future: postCreateAccount(apiUrl, 'Rose'),
            builder:
                (BuildContext bc, AsyncSnapshot<AccountCreation> snapshot) {
              if (snapshot.hasData) {
                TensoAccount newAccount = TensoAccount(
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
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Image(
                      image: const AssetImage("assets/images/addcard.png"),
                      height: size.width * 0.3,
                      width: size.width * 0.6,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    AppText(
                        text: 'Account created! ',
                        colour: Colors.green.shade600,
                        size: size.width * 0.09,
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<AppCubit>(context).goToMainPage(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: AppColours.buttoncolor,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Text("Done", style: TextStyle(fontSize: 16, color: Colors.white),),
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox(
                  height: size.width * 0.3,
                  width: size.width * 0.3,
                  child: spinkit,
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
