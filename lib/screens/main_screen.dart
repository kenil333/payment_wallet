import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/src/extensions/widget_extensions.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/data/stream/stream.dart';
import 'package:tensopay_wallet_prototype/screens/cards_screen.dart';
import 'package:tensopay_wallet_prototype/screens/pages/home_page.dart';
import 'package:tensopay_wallet_prototype/screens/offers_screen.dart';
import 'package:tensopay_wallet_prototype/screens/profile_screen.dart';
import 'package:tensopay_wallet_prototype/screens/pages/qr_scan_page.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_large_text.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key,}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _string = StringStream();
  static final List<Widget> _screens = <Widget>[
    const HomePage(),
    const CardsScreen(),
    Container(),
    const OffersScreen(),
    const ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _string.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          StreamBuilder<int>(
            stream: _string.intstream,
            initialData: 0,
            builder: (context, screenshot) {
              return _screens.elementAt(screenshot.data!);
            }
          ),
          Positioned(
            bottom: -10,
              left: -5,
              right: 0,
              child: ClipPath(
                clipper: DolDurmaClipper(
                    right: (size.width - 70) / 2, holeRadius: 70),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 5,
                              color: Colors.grey.shade400,
                              blurRadius: 5,
                              offset: const Offset(3, 3)
                          )
                        ]
                    ),
                    width: size.width ,
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _string.intsink.add(0);
                              },
                              child: StreamBuilder<int>(
                                stream: _string.intstream,
                                initialData: 0,
                                builder: (context, intshot) {
                                  return Icon(Icons.home, color: (intshot.data! == 0) ? AppColours.buttoncolor : Colors.grey,);
                                }
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _string.intsink.add(1);
                              },
                              child: StreamBuilder<int>(
                                  stream: _string.intstream,
                                  initialData: 0,
                                  builder: (context, intshot) {
                                  return Icon(Icons.credit_card, color: (intshot.data! == 1) ? AppColours.buttoncolor : Colors.grey,);
                                }
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Icon(Icons.qr_code_scanner, color: Colors.transparent)
                              ),
                            GestureDetector(
                              onTap: () {
                                _string.intsink.add(3);
                              },
                              child: StreamBuilder<int>(
                                  stream: _string.intstream,
                                  initialData: 0,
                                  builder: (context, intshot) {
                                  return Icon(Icons.local_offer_rounded, color: (intshot.data! == 3) ? AppColours.buttoncolor : Colors.grey,);
                                }
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _string.intsink.add(4);
                              },
                              child: StreamBuilder<int>(
                                  stream: _string.intstream,
                                  initialData: 0,
                                  builder: (context, intshot) {
                                  return Icon(Icons.person, color: (intshot.data! == 4) ? AppColours.buttoncolor : Colors.grey,);
                                }
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
          ),
          Positioned(
            bottom: 40,
            right: size.width * 0.428,
            child: FloatingActionButton(
              backgroundColor: AppColours.buttoncolor,
              elevation: 5,
              child: const ImageIcon(AssetImage('assets/images/scan-QR.png')),
              onPressed: () {
                BlocProvider.of<AppCubit>(context).goToScanQr();
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.transparent,
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.credit_card), label: 'Cards'),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.qr_code_scanner,
      //           color: Colors.transparent,
      //         ),
      //         label: 'Scanner'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.local_offer_rounded),
      //         label: 'Discover'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }
}
class DolDurmaClipper extends CustomClipper<Path> {
  DolDurmaClipper({required this.right, required this.holeRadius});

  final double right;
  final double holeRadius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: false,
        radius: const Radius.circular(4),
      )
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height);

    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}
