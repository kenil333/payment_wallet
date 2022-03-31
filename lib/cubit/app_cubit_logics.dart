import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/screens/main_screen.dart';
import 'package:tensopay_wallet_prototype/screens/pages/add_credential_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/card_detail_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/confirm_payment_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/create_card_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/edit_profile_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/home_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/offer_detail_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/qr_scan_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/shopping_detail_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/top_up_page.dart';
import 'package:tensopay_wallet_prototype/screens/pages/verification_page.dart';
import 'package:tensopay_wallet_prototype/screens/profile_screen.dart';
import 'package:tensopay_wallet_prototype/screens/splash_screen.dart';

import 'app_cubit_states.dart';
import 'app_cubits.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({Key? key}) : super(key: key);

  @override
  _AppCubitLogicsState createState() => _AppCubitLogicsState();
}

/*
This is where the transitions to different state is handled.
 */
class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Conformation"),
                content: const Text("Are you sure you want to exit ?"),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context);
                  }, child: const Text("NO"),),
                  TextButton(onPressed: () {
                    SystemNavigator.pop();
                  }, child: const Text("YES"),),
                ],
              );
            },
        );
        return false;
      },
      child: Scaffold(
        body: BlocBuilder<AppCubit, CubitState>(
          builder: (context, state){
            if(state is WelcomeState){
              return SplashScreen();
            } if(state is MainScreenState){
              return MainScreen();
            } if(state is ProfileScreenState){
              return ProfileScreen();
            }if(state is CardDetailState){
              return CardDetailPage();
            } if(state is CreateCardState){
              return CreateCardPage();
            } if(state is TopUpState){
              return TopUpPage();
            } if(state is OfferDetailState){
              return OfferDetailPage();
            } if(state is ShoppingOfferDetailState){
              return ShoppingOfferDetailPage();
            } if(state is VerificationState){
              return VerificationPage();
            } if(state is AddCredentialState){
              return AddCredentialPage();
            } if(state is EditProfileState){
              return EditProfilePage();
            } if(state is ConfirmPaymentState){
              return ConfirmPaymentPage();
            } if(state is ScanQRState){
              return QrScan();
            } else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}
