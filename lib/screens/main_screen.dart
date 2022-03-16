import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/src/extensions/widget_extensions.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/screens/cards_screen.dart';
import 'package:tensopay_wallet_prototype/screens/pages/home_page.dart';
import 'package:tensopay_wallet_prototype/screens/offers_screen.dart';
import 'package:tensopay_wallet_prototype/screens/profile_screen.dart';
import 'package:tensopay_wallet_prototype/screens/pages/qr_scan_page.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  static List<Widget> _screens = <Widget>[
    HomePage(),
    CardsScreen(),
    OffersScreen(),
    ProfileScreen()
  ];

  void _onIconTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Widget _buildBottomNavigationBar() {
    return BlocBuilder<AppCubit, CubitState>(
      builder: (context, state){
        if(state is MainScreenState){
          _currentIndex = state.index;
          print('Current index ' + '$_currentIndex');
          return CustomNavigationBar(
              iconSize: 20,
              selectedColor: Colors.blue,
              strokeColor: Colors.blueAccent,
              backgroundColor: Colors.white,
              borderRadius: Radius.circular(20),
              currentIndex: _currentIndex,
              onTap: _onIconTapped,
              items: [
                CustomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text(
                      'Home',
                      style: TextStyle(fontSize: 8),
                    )),
                CustomNavigationBarItem(
                    icon: Icon(Icons.card_membership),
                    title: Text(
                      'Cards',
                      style: TextStyle(fontSize: 8),
                    )),
                CustomNavigationBarItem(
                    icon: Icon(Icons.wallet_travel),
                    title: Text('Discover', style: TextStyle(fontSize: 8))),
                CustomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text('Profile', style: TextStyle(fontSize: 8)))
              ]);
        }else{
          return Container(child: AppLargeText(text: '[Error] Unknown state'+ '$state',),);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens.elementAt(_currentIndex)),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(6.0),
        child: FloatingActionButton(
          backgroundColor: AppColours.mainColour,
          child: ImageIcon(AssetImage('assets/images/scan-QR.png')),
          onPressed: () {
            BlocProvider.of<AppCubit>(context).goToScanQr();
          },
        ),
      ),
      //bottomNavigationBar: _buildBottomNavigationBar(),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColours.buttonBackground,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card), label: 'Cards'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer_rounded), label: 'Discover'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          )),
    );
  }
}
