import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kids_story/providers/chat_gpt_provider.dart';
import 'package:provider/provider.dart';

import '../customs/glass.dart';
import '../models/user_model.dart';

class SubscriptionPage extends StatefulWidget {
  static const String routeName = 'subscription';

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  Map<String, dynamic>? paymentIntent;
  late ChaGptProvider chaGptProvider;
  late UserModel userData;
  bool isFreeTrialExceeded = false;
  bool isSubscriptionExpired = false;
  late int dayDifference;
  int finalFreeDayDifference = 0;
  int finalPaidDayDifference = 0;
  bool isLoaded = false;

  @override
  void initState() {
    chaGptProvider = Provider.of<ChaGptProvider>(context, listen: false);
    fetchAllData();
    setState(() {});
    super.initState();
  }

  fetchAllData() async {
    await getUserData();
    await userCheck();
    setState(() {});
  }

  userCheck() {
    if (userData.subscriptionPlan == 'free') {
      int freeDayDifference = getDayDifference(userData.createdAt!);
      finalFreeDayDifference = 3 - freeDayDifference;
      if (freeDayDifference >= 3) {
        isFreeTrialExceeded = true;
        isSubscriptionExpired = true;
        setState(() {});
      }
    } else if (userData.subscriptionPlan == 'paid') {
      int paidDayDifference = getDayDifference(userData.subscriptionDate!);
      finalPaidDayDifference = 30 - paidDayDifference;
      if (paidDayDifference >= 30) {
        isSubscriptionExpired = true;
        isFreeTrialExceeded = true;
        setState(() {});
      }
    }
    isLoaded = true;
    setState(() {});
  }

  int getDayDifference(String creationDate) {
    DateTime userCreateData = DateFormat('yyyy-MM-dd').parse(creationDate);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    DateTime currentDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
    dayDifference = currentDate.difference(userCreateData).inDays;
    return dayDifference;
  }

  getUserData() {
    userData = chaGptProvider.userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'images/bg-6.jpeg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.zero),
            child: GlassBox(),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
          isLoaded == true
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        'images/payment.png',
                        height: 200,
                        width: 200,
                      ),
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(.6),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.buyYour,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 25),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              AppLocalizations.of(context)!.subScription,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              '2.99 €/${AppLocalizations.of(context)!.monTh}',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: 200,
                        height: 45,
                        child: LayoutBuilder(
                          builder: (p0, p1) {
                            if (isFreeTrialExceeded == false &&
                                userData.subscriptionPlan == 'free') {
                              return ElevatedButton(
                                onPressed: null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent[400]),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Free $finalFreeDayDifference days left',
                                  style: TextStyle(fontSize: 20.0.sp),
                                ),
                              );
                            }
                            if (isSubscriptionExpired == false &&
                                userData.subscriptionPlan == 'paid') {
                              return SizedBox(
                                height: 45,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.redAccent[400]),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 10.0,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '$finalPaidDayDifference days left',
                                    style: TextStyle(fontSize: 20.0.sp),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 45,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await makePayment();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.redAccent[400]),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 10.0,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Buy Now',
                                    style: TextStyle(fontSize: 20.0.sp),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('299', 'EUR');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Abhi',
                  googlePay: gpay))
          .then((value) {});

      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        onPaymentSuccessfull();
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  onPaymentSuccessfull() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String subscriptionDate = formatter.format(now);
    chaGptProvider.updateUserData(context, subscriptionDate);
  }

  // Widget _buildPlanCard(
  //   String title,
  //   String description,
  //   bool isDescriptionEnabled,
  //   String description1,
  //   bool isDescription1Enabled,
  //   String price,
  // ) {
  //   bool isSelected = _selectedPlan == title;
  //   return GestureDetector(
  //     onTap: () => _selectPlan(title),
  //     child: Padding(
  //       padding: const EdgeInsets.all(3.0),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: isSelected ? Colors.redAccent[400] : Colors.white,
  //           borderRadius: BorderRadius.circular(5),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.5),
  //               spreadRadius: 5,
  //               blurRadius: 7,
  //               offset: const Offset(0, 3), // changes position of shadow
  //             ),
  //           ],
  //         ),
  //         width: MediaQuery.of(context).size.width,
  //         child: Card(
  //           margin: isSelected ? const EdgeInsets.all(3) : EdgeInsets.zero,
  //           // elevation: 10,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //           // color: isSelected ? Color(0xffF197FF) : Colors.white,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 10.0),
  //               Container(
  //                 decoration: const BoxDecoration(
  //                     border: Border(
  //                         bottom: BorderSide(color: Colors.red, width: 3))),
  //                 child: Text(
  //                   title,
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 22,
  //                     fontFamily: 'Acherus',
  //                     color: isSelected ? Colors.red : Colors.black,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 20.0),
  //               Text(
  //                 description,
  //                 style: TextStyle(
  //                   fontSize: 19.0,
  //                   // fontFamily: 'Acherus',
  //                   // fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                   decoration: isDescriptionEnabled
  //                       ? TextDecoration.lineThrough
  //                       : TextDecoration.none,
  //                 ),
  //                 textAlign: TextAlign.justify,
  //               ),
  //               const SizedBox(height: 10.0),
  //               Text(
  //                 description1,
  //                 style: TextStyle(
  //                   fontSize: 19.0,
  //                   // fontFamily: 'Acherus',
  //                   // fontWeight: FontWeight.bold,
  //                   decoration: isDescription1Enabled
  //                       ? TextDecoration.lineThrough
  //                       : TextDecoration.none,
  //                 ),
  //                 textAlign: TextAlign.justify,
  //               ),
  //               const SizedBox(height: 20.0),
  //               Center(
  //                 child: Text(
  //                   '\$$price/month',
  //                   style: TextStyle(
  //                     fontSize: 17.0,
  //                     fontFamily: 'Acherus',
  //                     fontWeight: FontWeight.bold,
  //                     color: isSelected ? Colors.red : Colors.black,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
