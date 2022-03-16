import 'package:equatable/equatable.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/models/tenso_payment_data.dart';
import 'package:tensopay_wallet_prototype/screens/pages/edit_profile_page.dart';

abstract class CubitState extends Equatable{}

/*
This is where all the states are declared.
 */
class InitialState extends CubitState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class WelcomeState extends CubitState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class MainScreenState extends CubitState{
  final int index;
  MainScreenState({required this.index});
  @override
  // TODO: implement props
  List<Object> get props => [index];

}

class CardDetailState extends CubitState{
  final TensoAccount mainAccount;
  final TensoAccount account;
  final int index;
  CardDetailState({required this.mainAccount, required this.account, required this.index});
  @override
  // TODO: implement props
  List<Object> get props => [account, index];

}

class CreateCardState extends CubitState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TopUpState extends CubitState{
  final TensoAccount mainAccount;
  final TensoAccount account;
  final int index;
  TopUpState({required this.mainAccount, required this.account, required this.index});
  @override
  // TODO: implement props
  List<Object> get props => [account, index];
}

class OfferDetailState extends CubitState{
  final Offer offer;
  final int index;
  final bool fromOfferPage;
  OfferDetailState({required this.offer, required this.index, required this.fromOfferPage});
  @override
  // TODO: implement props
  List<Object> get props => [offer, index, fromOfferPage];
}

class ShoppingOfferDetailState extends CubitState{
  final ShoppingOffer offer;
  final int index;
  final bool fromOfferPage;
  ShoppingOfferDetailState({required this.offer, required this.index, required this.fromOfferPage});
  @override
  // TODO: implement props
  List<Object> get props => [offer, index, fromOfferPage];
}

class EditProfileState extends CubitState{
  bool isEditProfile;
  EditProfileState({required this.isEditProfile});
  @override
  // TODO: implement props
  List<Object> get props => [isEditProfile];
}

class VerificationState extends CubitState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddCredentialState extends CubitState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ScanQRState extends CubitState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ConfirmPaymentState extends CubitState{
  final TensoPayment tensoPayment;
  final TensoAccount mainAccount;
  ConfirmPaymentState({required this.tensoPayment, required this.mainAccount});
  @override
  // TODO: implement props
  List<Object?> get props => [tensoPayment, mainAccount];
}