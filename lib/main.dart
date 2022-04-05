import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_logics.dart';
import 'package:tensopay_wallet_prototype/screens/main_screen.dart';
import 'package:tensopay_wallet_prototype/screens/pages/card_detail_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/offer_detail_page.dart';
import 'package:tensopay_wallet_prototype/screens/splash_screen.dart';
import 'package:tensopay_wallet_prototype/utils/api_helper.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';
import 'package:intl/intl.dart';
import 'cubit/app_cubits.dart';
import 'models/nab_account_balance.dart';
import 'models/tenso_bank_account.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  //await Hive.deleteBoxFromDisk(tenso_db_box);
  //await Hive.close();
  Hive.registerAdapter(TensoAccountAdapter());
  var myAccounts = await Hive.openBox<TensoAccount>(tenso_db_box);

  if (myAccounts.isEmpty) {
    //Enter the 1st data here.
    //Grab the NAB data here..
    //AccountModel nab = new AccountModel(accountId: '123456789', description: 'NAB Isaver', currency: 'AUD', identification: '123456789', accountType: 'Personal', accountSubType: 'Savings', nickname: 'Rose', bankName: 'NAB');
    NABAccountBalance nab = await getNABData();

    TensoAccount nabAccount = TensoAccount(
      accountId: nab.accountId,
      description: 'NAB Isaver',
      currency: nab.currency,
      identification: '123456789',
      accountType: 'Personal',
      accountSubType: 'Savings',
      nickname: 'Rose',
      validTill: DateFormat('MM/yyyy').parse('04/2025'),
      cardId: '123456789',
      cardNumber: '123456789',
      status: 'Valid',
      balance: double.parse(nab.availableBalance),
      bankName: 'NAB',
      colour: (math.Random().nextDouble() * 0xFFFFFF).toInt(),
    );
    myAccounts.add(nabAccount);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TensoPay Wallet',
        //home: SplashScreen(),
        //home: MainScreen(),
        //home:CardsPage(),
        home: BlocProvider<AppCubit>(
          create: (context) => AppCubit(),
          child: AppCubitLogics(),
        ));
  }
}
