import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';

class TensoCard extends StatelessWidget {
  final TensoAccount? tensoAccount;

  TensoCard({Key? key, required this.tensoAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MM/yyyy');
    return Card(
      elevation: 4.0,
      color: Color(tensoAccount!.colour),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 150,
        width: 250,
        color: Color(tensoAccount!.colour),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLogosBlock('${tensoAccount!.bankName}'),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '${tensoAccount!.cardNumber}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'CourrierPrime'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(
                  label: 'CARDHOLDER',
                  value: '${tensoAccount!.nickname}',
                ),
                _buildDetailsBlock(
                    label: 'VALID THRU', value: dateFormat.format(tensoAccount!.validTill)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Build the top row containing logos
Row _buildLogosBlock(String bankName) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Image.asset(
        "assets/images/contact_less.png",
        height: 20,
        width: 18,
      ),
      _buildDetailsBlock(
        label: 'Bank',
        value: bankName,
      ),
    ],
  );
}

// Build Column containing the cardholder and expiration information
Column _buildDetailsBlock({required String label, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        '$label',
        style: TextStyle(
            color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
      ),
      Text(
        '$value',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      )
    ],
  );
}
