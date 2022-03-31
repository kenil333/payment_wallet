import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/screens/pages/top_up_page.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/common_cached_network_image.dart';

import '../widgets/tenso_large_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print('Profile Screen');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: size.width * 0.015),
              child: AppLargeText(
                text: 'My Profile',
                colour: Colors.black87.withOpacity(0.7),
                size: size.width * 0.07,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container()),
                Container(
                  height: size.width * 0.32,
                  width: size.width * 0.32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(2, 2),
                          color: Colors.grey.shade400,
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                  ),
                  child: CommonCachedNetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSB8vuaWT6wGaoDz6T0UEilQ8wwcFO-hvserEgijbpPulSLBBpgbkxZBjwhUsU3ULuPazM&usqp=CAU',
                    fit: BoxFit.cover,
                    height: 120,
                    width: 120,
                  ).cornerRadiusWithClipRRect(60),
                ),
                Expanded(child: Container()),
              ],
            ),
            20.height,
            Text('Rose', style: boldTextStyle(color: Colors.black, size: 18)),
            Text('rose@test.com', style: secondaryTextStyle(color: Colors.black87, size: 16)),
            16.height,
            SettingItemWidget(
                title: 'Edit Profile',
                padding: EdgeInsets.symmetric(vertical: size.width * 0.025, horizontal: size.width * 0.05),
                decoration: boxDecorationRoundedWithShadow(12,backgroundColor: const Color(0xFFEBF4F8)),
                trailing: Icon(Icons.arrow_right,
                    color: AppColours.mainColour.withOpacity(0.5)),
                onTap: () {
                  BlocProvider.of<AppCubit>(context).goToEdiProfile(true);
                }),
            16.height,
            SettingItemWidget(
                title: 'Manage Wallet',
                decoration: boxDecorationRoundedWithShadow(12,backgroundColor: const Color(0xFFEBF4F8)),
                trailing:
                    Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                onTap: () {
                  // BlocProvider.of<AppCubit>(context).
                },
            ),
            16.height,
            SettingItemWidget(
                title: 'Transaction History',
                decoration: boxDecorationRoundedWithShadow(12,backgroundColor: const Color(0xFFEBF4F8)),
                trailing:
                    Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                onTap: () {
                  //
                }),
            16.height,
            SettingItemWidget(
                title: 'Settings',
                decoration: boxDecorationRoundedWithShadow(12,backgroundColor: const Color(0xFFEBF4F8)),
                trailing:
                    Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                onTap: () {
                  //
                }),
          ],
        ).paddingAll(16),
      ),
    );
  }
}
