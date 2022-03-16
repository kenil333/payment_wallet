import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tensopay_wallet_prototype/models/account_balance.dart';
import 'package:tensopay_wallet_prototype/models/account_creation.dart';
import 'package:tensopay_wallet_prototype/models/nab_account_balance.dart';
import 'package:http/http.dart' as http;
import 'package:tensopay_wallet_prototype/models/rate.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/models/tenso_transaction.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_constants.dart';

//Gets the balance of the NAB from the API
Future<NABAccountBalance> getNABData() async {
  String apiUrl =
      'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getNABAccountBalance';
  final response = await http.get(Uri.parse(apiUrl), headers: {"Access-Control-Allow-Origin":"*"});
  if (response.statusCode == 200) {
    return NABAccountBalance.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('[Error] getNABData Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString());
  }
}

//Gets the balance of CIBC, NatWest, or ITAU from the API
Future<AccountBalance> getAccountBalance(String bankName, String identification) async {
  String apiUrl= '';
  if(bankName == 'CIBC'){
    apiUrl ='http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getCIBCAccountBalance?account='+identification;
  }else if(bankName == 'ITAU'){
    apiUrl= 'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getITAUAccountBalance?account='+identification;
  }else if(bankName == 'NatWest'){
    apiUrl ='http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getNatWestAccountBalance?account='+identification;
  }else{
    throw Exception('[Error] unknown bank name : ' +bankName);
  }

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return AccountBalance.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('[Error] getAccountBalance Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString());
  }
}

//Returns the index of the NAB account stored in the local db
int? findMainAccountIndex(){
  var myAccounts = Hive.box<TensoAccount>(tenso_db_box);
  for(int i = 0; i< myAccounts.length;i++){
    TensoAccount? _account = myAccounts.getAt(i);
    if(_account!.bankName == 'NAB'){

      return i;
    }
  }
  return null;
}

//Returns the currency symbol given the ISO code
String getCurrency(BuildContext context, String currency) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString(), name:currency);
  String currSym = format.currencySymbol;
  //print(currSym);
  return currSym ;

}

//Returns the formatted amount given the ISO code and the amount
String getCurrencyAmount(BuildContext context, String currency, double amount) {
  Locale locale = Localizations.localeOf(context);
  NumberFormat decimalFormat = new NumberFormat("#,##0.00");
  var format = NumberFormat.simpleCurrency(locale: locale.toString(), name:currency);
  String currSym = format.currencySymbol;
  //print(currSym);
  String formattedAmount = decimalFormat.format(amount);
  //print(formattedAmount);
  return currSym+' '+formattedAmount ;

}

//Returns the NAB account stored in the local db
TensoAccount? findMainAccount(){
  var myAccounts = Hive.box<TensoAccount>(tenso_db_box);
  for(int i = 0; i< myAccounts.length;i++){
    TensoAccount? _account = myAccounts.getAt(i);
    if(_account!.bankName == 'NAB'){
      return _account;
    }
  }
  return null;
}

//Returns the accounts stored in the db
List<TensoAccount?> generateCards() {
  //Hive box is open, no need to use future..
  var myAccounts = Hive.box<TensoAccount>(tenso_db_box);
  List<TensoAccount?> cardList = [];
  for(int i = 0 ; i < myAccounts.length; i++){
    cardList.add(myAccounts.getAt(i));
  }
  return cardList;
}

//Returns the transactions of NAB,CIBC, NatWest or ITAU from the API
Future<List<TensoTransaction>> getTransactions(String bankName, String identification) async {
  String apiUrl= '';
  if(bankName == 'NAB'){
    apiUrl = 'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getTransactionsNAB';
  }else if(bankName == 'CIBC'){
  apiUrl ='http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getTransactionsCIBC?account='+identification;
  }else if(bankName == 'ITAU'){
    apiUrl= 'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getTransactionsITAU?account='+identification;
  }else if(bankName == 'NatWest'){
    apiUrl ='http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getTransactionsNatWest?account='+identification;
  }else{
    throw Exception('[Error] unknown bank name : ' +bankName);
  }

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((data) => TensoTransaction.fromJson(data))
        .toList();
  } else {
    throw Exception('[Error] getTransactions Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString());
  }
}

Future<AccountCreation> postCreateAccount(String apiUrl, String name) async {
  //String body = '{\"name\":\"name",}';
  final response = await http.post(Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: JsonEncoder().convert({"name": name}));
  //print('posted:' + body);
  print('response ' + response.statusCode.toString());
  if (response.statusCode == 200) {
    print('Body:' + response.body);
    return AccountCreation.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('[Error] Account Creation Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString());
  }
}

Future<Rate> getRate(String currency) async {
  String apiUrl =
      'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/getRate?fromCurrency=AUD&toCurrency='+currency;
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return Rate.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('[Error] Rate Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString());
  }
}

Future<String> postTransfer(String bankName, String identification, String amount, String description) async {
  String apiUrl = '';
  if(bankName == 'NatWest'){
    apiUrl = 'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/transferNatWest';
  }else if(bankName == 'ITAU'){
    apiUrl= 'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/transferITAU';
  }
  //String apiUrl =
  //    'http://open-banking-challenge-spring-boot-marcuskhlim231346.codeanyapp.com:8080/api/transfer';
  //String body = '{\"accountId\":\"50000087654302\",\"amount\":' + amount + '}';
  final response = await http.post(Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: JsonEncoder().convert({"accountId" : identification, "amount": amount, "description" :description }));
  //print('posted:' + body);
  print('response ' +response.statusCode.toString());
  if (response.statusCode == 200) {
    return 'Successful';
  } else {
    return '[Error] '+bankName+' Transfer Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString();
    /*
    throw Exception('[Error] Transfer Status code: ' +
        response.statusCode.toString() +
        'message: ' +
        response.body.toString());

     */
  }
}