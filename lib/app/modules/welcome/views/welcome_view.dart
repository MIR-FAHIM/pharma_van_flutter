import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  @override
  Widget build(BuildContext context) {
    final _size = Get.size;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        width: _size.width,
        height: _size.height*.1,
        // color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Login / Registration'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF652981),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.find<AuthService>().setFirstUseOrNot();

                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 35, maxWidth: 35, minHeight: 25, minWidth: 25),
                  child: Container(
                    // width: 35,
                    // height: 35,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF652981).withOpacity(0.4), blurRadius: 6, spreadRadius: 1, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/arrow_for.png",
                      height: 15,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        backgroundColor: AppColors.primaryDarkGreen,
        body: SingleChildScrollView(

          child: Container(
            height: Get.height *.9,
            child: ListView(
              children: [
                Container(
                  color: AppColors.primaryLightColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: Get.size.width * .6,
                        width: Get.size.width,
                        // color: AppColors.redTextColor,
                        child: const Image(
                          image: AssetImage('assets/PP_Splash_Screen.png'),
                          // color: Color(0xFF652981),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: _size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(height: _size.height * 0.03),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "আপনার NID দিয়ে পে প্লাসে",
                          style: TextStyle(color: AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "একাউন্ট খুলুন",
                          style: TextStyle(color: AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Stepper(
                        physics: NeverScrollableScrollPhysics(),
                        currentStep: 2,
                        controlsBuilder: (BuildContext context, ControlsDetails details
                            // {VoidCallback?
                            //     onStepContinue,
                            // VoidCallback?
                            //     onStepCancel}
                            ) {
                          return Row(
                            children: <Widget>[
                              Container(
                                child: null,
                              ),
                              Container(
                                child: null,
                              ),
                            ],
                          );
                        },
                        steps: <Step>[
                          Step(
                            title: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "মোবাইল নাম্বার দিয়ে রেজিস্ট্রেশন করুন",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            content: SizedBox(
                              width: 0.0,
                              height: MediaQuery.of(context).size.height - 250,
                            ),
                            isActive: true,
                          ),
                          const Step(
                            title: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              child: Text(
                                "আপনার মোবাইলে পাঠানো OTP দিয়ে ভেরিফিকেশন করুন",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                            ),
                            content: SizedBox(
                              width: 0.0,
                              height: 0.0,
                            ),
                            isActive: true,
                          ),

                          const Step(
                            title: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                              child: Text(
                                "আপনার তথ্যগুলি লিপিভুক্ত করুন",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                            ),
                            content: SizedBox(
                              width: 0.0,
                              height: 0.0,
                            ),
                            isActive: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


                // Container(
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //     image: AssetImage('assets/welcome.png'),
                //     fit: BoxFit.fill,
                //   )),
                // ),
                // Align(
                //     alignment: Alignment.center,
                //     child: Padding(
                //       padding: const EdgeInsets.only(top: 100.0),
                //       child: Text(
                //         'Create Pay Plus account with your NID'.tr,
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 25,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     )),
                // Align(
                //     alignment: Alignment.bottomCenter,
                //     child: GestureDetector(
                //       onTap: () {
                //         Get.find<AuthService>().setFirstUseOrNot();
                //         Get.offAllNamed(Routes.CHECK_PHONE_NUMBER);
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.only(
                //             left: 20.0, right: 20, bottom: 120),
                //         child: Container(
                //           width: Get.size.width,
                //           decoration: BoxDecoration(
                //               color: Color(0xFF652981),
                //               borderRadius: BorderRadius.circular(8)),
                //           child: Padding(
                //             padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                //             child: Text(
                //               'Login / Registration'.tr,
                //               style: TextStyle(
                //                   fontWeight: FontWeight.normal,
                //                   fontSize: 25,
                //                   color: Colors.white),
                //               textAlign: TextAlign.center,
                //             ),
                //           ),
                //         ),
                //       ),
                //     )),
              ],
            ),
          ),
        ));
  }
}
