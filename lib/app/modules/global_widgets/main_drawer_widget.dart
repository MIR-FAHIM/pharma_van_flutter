import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecom_user_flutter/app/modules/settings/controllers/language_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:ecom_user_flutter/service/shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  final _size = Get.size;
  final userdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAllNamed(Routes.ROOT);
        return Future.value(false);
      },
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //         Center(
                //   child: Text(
                //         'Pay Plus'.tr,
                //         style: const TextStyle(
                //           fontSize: 35,
                //           color: Color(0xFF652981),
                //         ),
                //   ),
                // ),
                const Image(
                  image: AssetImage('assets/Logo.png'),
                  height: 40,
                  width: 100,
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ExpandablePanel(
                collapsed: const SizedBox(
                  height: 10,
                ),
                header: DrawerLinkWidget(
                  icon: 'assets/drawer/6.png',
                  text: "Privacy Policy".tr,
                  id: 0,
                  onTap: (e) async {},
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DrawerLinkWidget(
                        icon: 'assets/drawer/2.png',
                        text: "Hotline".tr,
                        onTap: (e) {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DrawerLinkWidget(
                        icon: 'assets/drawer/terms.png',
                        text: "Terms & Conditions".tr,
                        onTap: (e) async {
                          Uri url = Uri.parse(
                              'https://shl.com.bd/terms-and-conditions.php');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print("can not load this url");
                          }
                        },
                      ),
                      // DrawerLinkWidget(
                      //   icon: 'assets/drawer/terms.png',
                      //   text: "Test Module".tr,
                      //   onTap: (e) async {
                      //  Get.toNamed(Routes.COLLECTORHOMEPAGE);
                      //   },
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      DrawerLinkWidget(
                        icon: 'assets/drawer/terms.png',
                        text: "Privacy Policy".tr,
                        onTap: (e) async {
                          final String urlString =
                              "https://raw.githubusercontent.com/musabbir-mamun/app-privacy-policy/master/paystation/paystation.html";

                          Uri url = Uri.parse(urlString);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print("can not load this url");
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ExpandablePanel(
                collapsed: const SizedBox(
                  height: 10,
                ),
                header: DrawerLinkWidget(
                  icon: 'assets/drawer/7.png',
                  text: "Settings".tr,
                  id: 0,
                  onTap: (e) async {},
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          print(Get.find<LanguageController>().locale.value ==
                              'en_US');
                          if (GetStorage().read<String>('language') ==
                              'en_US') {
                            Get.find<LanguageController>()
                                .updateLocale('bn_BD');
                          } else {
                            Get.find<LanguageController>()
                                .updateLocale('en_US');
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 10),
                            child: Container(
                              width: _size.width,
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Image(
                                          image: AssetImage(
                                              'assets/drawer/language.png'),
                                          height: 25,
                                          width: 25,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          width: 1,
                                          height: 28,
                                          color: Get.theme.dividerColor
                                              .withOpacity(0.2),
                                        ),
                                        Expanded(
                                          child: Text('Language Change'.tr,
                                              style: Get.textTheme.bodyMedium!
                                                  .merge(const TextStyle(
                                                      fontSize: 16))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xFF652981),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        GetStorage().read<String>('language') ==
                                                'en_US'
                                            ? 'বাংলা'
                                            : 'English',
                                        style: const TextStyle(
                                          color: const Color(0xFF652981),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DrawerLinkWidget(
                        icon: 'assets/drawer/6.png',
                        text: "Change Pin".tr,
                        onTap: (e) {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DrawerLinkWidget(
                        icon: 'assets/drawer/deactivate_account.png',
                        text: "Account Deactivate".tr,
                        onTap: (e) {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DrawerLinkWidget(
                        icon: 'assets/drawer/1.png',
                        text: "Sign Out".tr,
                        id: 1,
                        onTap: (e) async {
                          Get.find<AuthService>().removeCurrentUser();
                          SharedPreff.to.prefss.remove("logindate");

                          Get.offAndToNamed(
                            Routes.SPLASHSCREEN,
                          );
                        },
                      ),
                      DrawerLinkWidget(
                        icon: 'assets/drawer/deactivate_account.png',
                        text: "App Version: 8".tr,
                        onTap: (e) {
                          //  Get.toNamed(Routes.DEACTIVATE_ACCCOUNT);
                          // Get.toNamed(Routes.Test);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
