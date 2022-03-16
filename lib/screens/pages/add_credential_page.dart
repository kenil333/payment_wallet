import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';


class AddCredentialPage extends StatefulWidget {
  const AddCredentialPage({Key? key}) : super(key: key);
  static String tag = '/AddCredentialPage';
  @override
  _AddCredentialPageState createState() => _AddCredentialPageState();
}

class _AddCredentialPageState extends State<AddCredentialPage> {
  @override
  void initState() {
    super.initState();
    //init();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          Text('SKIP', style: boldTextStyle()).paddingOnly(right: 8).center().onTap(() {
            BlocProvider.of<AppCubit>(context).goToMainPage(0);
          }),
        ],
      ),
      body: Container(
        height: context.height(),
        width: context.width(),
        //decoration: BoxDecoration(
        //image: DecorationImage(image: AssetImage('images/walletApp/wa_bg.jpg'), fit: BoxFit.cover),
        //),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/top_up.png',
              width: context.width() * 0.80,
              height: context.width() * 0.80,
              fit: BoxFit.cover,
            ),
            8.height,
            Text(
              'Add Creditionals to Loop',
              style: boldTextStyle(size: 20),
              textAlign: TextAlign.center,
            ),
            16.height,
            Text(
              'Add your bank credit/debit card to Loop for manage your experience and set your budget for saving',
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            30.height,
            SizedBox(
              width: context.width() * 0.5,
              child: AppButton(
                  text: "Next",
                  color: Colors.white,
                  textColor: Colors.white,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  width: context.width(),
                  onTap: () {
                    BlocProvider.of<AppCubit>(context).goToVerification();
                  }),
            ),
          ],
        ).paddingOnly(left: 30, right: 30).paddingTop(40),
      ),
    );
  }
}
