import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubit_states.dart';
import 'package:tensopay_wallet_prototype/cubit/app_cubits.dart';
import 'package:tensopay_wallet_prototype/utils/data_generator.dart';
import 'package:tensopay_wallet_prototype/utils/tenso_colours.dart';
import 'package:tensopay_wallet_prototype/widgets/tenso_input_decoration.dart';

import '../../widgets/common_cached_network_image.dart';

class EditProfilePage extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  //final isEditProfile;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var fullNameController = TextEditingController();
  var contactNumberController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode contactNumberFocusNode = FocusNode();

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // BlocProvider.of<AppCubit>(context).gotoProfilePage(0);
                      BlocProvider.of<AppCubit>(context).goToMainPage(0);
                    },
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                        color: AppColours.buttoncolor,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            width: 0.5, color: AppColours.buttoncolor),
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Edit Profile',
                    style: boldTextStyle(
                        color: Colors.black87.withOpacity(0.7),
                        size: 20,
                        weight: FontWeight.w600),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              SizedBox(height: size.width * 0.03),
              Row(
                children: [
                  Expanded(child: Container()),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Container(
                        height: size.width * 0.3,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
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
                          height: 100,
                          width: 100,
                        ).cornerRadiusWithClipRRect(60),
                      ),
                      Positioned(
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 20),
                          decoration: const BoxDecoration(
                              color: AppColours.buttoncolor,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                ],
              ),
              16.height,
              Text('Personal Information', style: boldTextStyle(size: 18)),
              16.height,
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColours.mainColour, width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name', style: boldTextStyle(size: 14)),
                    8.height,
                    AppTextField(
                      decoration: TensoInputDecoration(
                        hint: 'Enter your full name here',
                        bgColor: AppColours.backcolor,
                      ),
                      textFieldType: TextFieldType.NAME,
                      keyboardType: TextInputType.name,
                      controller: fullNameController,
                      focus: fullNameFocusNode,
                    ),
                    16.height,
                    Text('Contact Number', style: boldTextStyle(size: 14)),
                    8.height,
                    AppTextField(
                      decoration: TensoInputDecoration(
                        hint: 'Enter your contact number here',
                        bgColor: AppColours.backcolor,
                      ),
                      textFieldType: TextFieldType.PHONE,
                      keyboardType: TextInputType.phone,
                      controller: contactNumberController,
                      focus: contactNumberFocusNode,
                    ),
                    16.height,
                    Text('Date of birth', style: boldTextStyle(size: 14)),
                    8.height,
                    Row(
                      children: [
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: TensoInputDecoration(
                            hint: "Date",
                            bgColor: AppColours.backcolor,
                          ),
                          items: List.generate(31, (index) {
                            return DropdownMenuItem(
                                child: Text('${index + 1}',
                                    style: secondaryTextStyle()),
                                value: index + 1);
                          }),
                          onChanged: (value) {},
                        ).expand(),
                        16.width,
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: TensoInputDecoration(
                            hint: "Month",
                            bgColor: AppColours.backcolor,
                          ),
                          items: MonthList.map((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value!, style: secondaryTextStyle()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            //
                          },
                        ).expand(),
                        16.width,
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: TensoInputDecoration(
                            hint: "Year",
                            bgColor: AppColours.backcolor,
                          ),
                          items: YearList.map((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value!, style: secondaryTextStyle()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            //
                          },
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Text('Gender', style: boldTextStyle()),
                    8.height,
                    DropdownButtonFormField(
                      isExpanded: true,
                      decoration: TensoInputDecoration(
                        hint: "Select your gender",
                        bgColor: AppColours.backcolor,
                      ),
                      items: <String>['Female', 'Male'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: secondaryTextStyle()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        //
                      },
                    ),
                  ],
                ),
              ),
              16.height,
              AppButton(
                color: AppColours.buttoncolor,
                width: size.width,
                child:
                    Text('Continue', style: boldTextStyle(color: Colors.white)),
                onTap: () {
                  BlocBuilder<AppCubit, CubitState>(builder: (context, state) {
                    if (state is EditProfileState) {
                      bool isEditProfile = state.isEditProfile;
                      if (isEditProfile) {
                        BlocProvider.of<AppCubit>(context).goToMainPage(0);
                      } else {
                        BlocProvider.of<AppCubit>(context).goToAddCredential();
                      }
                    } else {
                      return Container();
                    }
                    return Container();
                  });
                },
              ).cornerRadiusWithClipRRect(12).paddingOnly(
                  left: size.width * 0.05, right: size.width * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

/*
BlocBuilder<AppCubit, CubitState>(
builder: (context, state) {

   if (widget.isEditProfile) {
                            finish(context);
                          } else {
                            BlocProvider.of<AppCubit>(context).goToAddCredential();
                          }
 */
