import 'package:bloc/bloc.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';
import 'package:tensopay_wallet_prototype/models/tenso_bank_account.dart';
import 'package:tensopay_wallet_prototype/models/tenso_payment_data.dart';

/*
This is the class where you can create the emit() functions to tell the app
where to go.
 */


class AppCubit extends Cubit<CubitState>{
  AppCubit() : super(InitialState()){
    emit(WelcomeState());
  }

  void goToMainPage(int index){
    emit(MainScreenState(index: index));
  }

  void goToCardDetailPage(TensoAccount mainAccount,TensoAccount account, int index){
    emit(CardDetailState(account: account, index: index, mainAccount: mainAccount));
  }

  void goToCreateCard(){
    emit(CreateCardState());
  }

  void goToTopUp(TensoAccount mainAccount, TensoAccount account, int index){
    emit(TopUpState(account: account, index: index, mainAccount: mainAccount));
  }

  void goToOfferDetail(Offer offer, int index, bool fromOfferPage){
    emit(OfferDetailState(offer: offer, index: index, fromOfferPage: fromOfferPage));
  }
  
  void goToShoppingOfferDetail(ShoppingOffer offer, int index, bool fromOfferPage){
    emit(ShoppingOfferDetailState(offer: offer, index: index, fromOfferPage: fromOfferPage));
  }

  void goToVerification(){
    emit(VerificationState());
  }

  void goToAddCredential(){
    emit(AddCredentialState());
  }

  void goToEdiProfile(bool isEditProfile){
    emit(EditProfileState(isEditProfile: isEditProfile));
  }

  void goToConfirmPayment(TensoAccount mainAccount, TensoPayment tensoPayment){
    emit(ConfirmPaymentState(tensoPayment: tensoPayment, mainAccount: mainAccount));
  }

  void goToScanQr(){
    emit(ScanQRState());
  }
}