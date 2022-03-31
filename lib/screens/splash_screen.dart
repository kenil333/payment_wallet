import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_text.dart';
import 'package:tensopay_wallet_prototype/widgets/responsive_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List images = ['Illus1.png', 'Illus2.png', 'Illus3.png'];

  List descriptions = [
    'Earn points when spending cash',
    'Use cash for online purchases',
    'Start using TensoPay and \n start earning points!'
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/splash_screen/' + images[index]),
                    )),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.7, left: 20),
                    alignment: Alignment.center,
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          AppLargeText(
                              text: 'Welcome',
                              colour: Colors.white,
                              weight: FontWeight.w400),
                          AppText(
                              text: descriptions[index],
                              colour: Colors.white.withOpacity(0.8),
                              weight: FontWeight.w300),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AppCubit>(context)
                                  .goToMainPage(0);
                            },
                            child: Container(
                              width: size.width * 0.4,
                              height: size.width * 0.12,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColours.backcolor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      color: AppColours.buttoncolor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.04),
                                  const  Image(
                                    image:  AssetImage(
                                        "assets/images/arrow.png"),
                                    color: AppColours.buttoncolor,
                                  ),
                                  SizedBox(width: size.width * 0.04),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Expanded(child: Container()),
                  Container(
                    alignment: const Alignment(0.0, 2.0),
                    margin: const EdgeInsets.only(top: 100, right: 20),
                    child: Column(
                      children: List.generate(images.length, (indexDots) {
                        return Container(
                          width: 8,
                          height: index == indexDots ? 25 : 8,
                          margin: const EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index == indexDots
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5)),
                        );
                      }),
                    ),
                  )
                ]));
          }),
    );
  }
}
