import 'dart:io';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kids_story/auth/auth_service.dart';
import 'package:kids_story/customs/custom_text_field.dart';
import 'package:kids_story/screens/login_page.dart';
import 'package:kids_story/screens/read.dart';
import 'package:kids_story/screens/subscription_plan.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classess/language.dart';
import '../classess/language_constants.dart';
import '../main.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import '../providers/chat_gpt_provider.dart';
import '../utils/glass_box.dart';
import '../utils/snackbar.dart';

class StoryCreateAndList extends StatefulWidget {
  static const String routeName = 'story_create_and_list';
  const StoryCreateAndList({super.key});

  @override
  State<StoryCreateAndList> createState() => _StoryCreateAndListState();
}

class _StoryCreateAndListState extends State<StoryCreateAndList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController storyController = TextEditingController();
  late ChaGptProvider chaGptProvider;
  late UserModel userData;
  bool isFreeTrialExceeded = false;
  bool isSubscriptionExpire = false;
  String? currentlanguage;
  bool isLoaded = false;
  @override
  void dispose() {
    titleController.dispose();
    storyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    chaGptProvider = Provider.of<ChaGptProvider>(context, listen: false);
    fetchAllData();
    super.initState();
  }

  fetchAllData() async {
    if (chaGptProvider.userStoryList.isEmpty) {
      await fetchStory();
    }
    await fetchUserData();

    await userCheck();
    isLoaded = true;
    setState(() {});
    showDialog();
  }

  userCheck() {
    if (userData.subscriptionPlan == 'free') {
      int difference = getDayDifference(userData.createdAt!);
      if (difference >= 3) {
        isFreeTrialExceeded = true;
      }
    } else {
      int difference = getDayDifference(userData.subscriptionDate!);
      if (difference >= 30) {
        isSubscriptionExpire = true;
      }
    }
  }

  showDialog() {
    if (isFreeTrialExceeded) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Free Trial Exceeded',
        desc: 'Please Subscribe to continue',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.pushNamed(context, SubscriptionPage.routeName);
        },
      ).show();
    }
    if (isSubscriptionExpire) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Subscription Expired',
        desc: 'Please Renew Subscription',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.pushNamed(context, SubscriptionPage.routeName);
        },
      ).show();
    }
  }

  showDeleteDialog(StoryModel storyModel) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Story Delete',
      desc: 'Are You Sure to Delete Story ?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        isLoaded = false;
        await chaGptProvider.updateStoryData(storyModel);
        isLoaded = true;
      },
    ).show();
  }

  int getDayDifference(String creationDate) {
    DateTime userCreateData = DateFormat('yyyy-MM-dd').parse(creationDate);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    DateTime currentDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
    final difference = currentDate.difference(userCreateData).inDays;
    return difference;
  }

  _onPressGenerateStory() async {
    String title = titleController.text;
    String storyLine = storyController.text;
    if (isFreeTrialExceeded) {
      showDialog();
      return;
    } else if (isSubscriptionExpire) {
      showDialog();
      return;
    } else {
      if (titleController.text.isEmpty) {
        CustomSnackbar(
                context: context, title: 'Error', message: 'Enter Story title')
            .showSnackbar();
        return;
      }

      chaGptProvider.getStory(
        title: title,
        language: currentlanguage!,
        storyLine: storyLine,
        context: context,
        isDeleted: false,
      );
      clearTextField();
      Navigator.pushReplacementNamed(context, StoryCreateAndList.routeName);
    }
  }

  _onPressDelete(StoryModel storyModel) async {
    showDeleteDialog(storyModel);
  }

  clearTextField() {
    titleController.text = '';
    storyController.text = '';
  }

  fetchStory() async {
    await chaGptProvider.getStoryByUser();
  }

  fetchUserData() async {
    await chaGptProvider.getUserData();
    userData = chaGptProvider.userData;
  }

  int activeindex = 0;
  List<String> covers = [
    "images/cvr1.jpg",
    "images/cvr2.jpg",
    "images/cvr3.jpg",
    "images/cvr4.jpg",
    "images/cvr5.jpg"
  ];

  List<Map> cover = [
    {'title': 'titlefff 1', 'image': 'images/cvr1.jpg'},
    {'title': 'title 2', 'image': 'images/cvr1.jpg'},
    {'title': 'title 3', 'image': 'images/cvr1.jpg'},
    {'title': 'title 4', 'image': 'images/cvr1.jpg'},
    {'title': 'title 5', 'image': 'images/cvr1.jpg'},
  ];

  Future<void> _onRefresh() async {
    isLoaded = false;
    fetchAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getlanguage();
    return Consumer<ChaGptProvider>(
      builder: (context, provider, child) {
        var isCreated = provider.storycreated;
        if (isCreated) {
          return SafeArea(
            child: DefaultTabController(
              length: 2,
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 40,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showFlexibleBottomSheet(
                              minHeight: 0,
                              initHeight: 0.2,
                              maxHeight: 1,
                              context: context,
                              builder: buildBottomSheet,
                              anchors: [0, 0.5, 1],
                              isSafeArea: Platform.isAndroid ? true : false,
                            );
                          },
                          child: SizedBox(
                              height: 25.h,
                              width: 25.h,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset("images/settings.png"),
                              )),
                        ),
                        SizedBox(
                            height: 25.h,
                            width: 25.h,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SubscriptionPage()));
                                },
                                child: Image.asset("images/premium.png"),
                              ),
                            )),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: AssetImage(
                                'images/bg-6.jpeg',
                              ),
                              fit: BoxFit.cover),
                        ),
                        child: GlassBox(),
                      ),
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: TabBar(
                              tabs: [
                                Tab(
                                  icon: Image.asset(
                                    'images/open_book.png',
                                    height: 30,
                                    width: 40,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.previousStory,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                Tab(
                                  icon: Image.asset(
                                    'images/add_story.png',
                                    height: 30,
                                    width: 40,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .createnewStory,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isLoaded
                              ? Expanded(
                                  child: TabBarView(
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Consumer<ChaGptProvider>(
                                              builder:
                                                  (context, provider, child) {
                                                List<StoryModel> storyList =
                                                    provider.userStoryList;
                                                if (storyList.isNotEmpty) {
                                                  return SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            160,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(
                                                                parent:
                                                                    AlwaysScrollableScrollPhysics()),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            storyList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ReadingPage(
                                                                    title: storyList[storyList.length -
                                                                            index -
                                                                            1]
                                                                        .title!,
                                                                    story: storyList[storyList.length -
                                                                            index -
                                                                            1]
                                                                        .story!,
                                                                    heroTag:
                                                                        "photo-${index}",
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 12,
                                                                  horizontal:
                                                                      10),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    12,
                                                                height: 100.h,
                                                                decoration: BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.3),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            3,
                                                                        offset: const Offset(
                                                                            0,
                                                                            0), // Shadow position
                                                                      ),
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(
                                                                                0.7)),
                                                                    color: Colors
                                                                        .transparent),
                                                                child: Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width -
                                                                            12,
                                                                        height:
                                                                            100.h,
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            BackdropFilter(
                                                                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 30),
                                                                                child: BackdropFilter(
                                                                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      // border: Border.all(color: Colors.white, width: 10),
                                                                                      gradient: LinearGradient(
                                                                                        begin: Alignment.topCenter,
                                                                                        end: Alignment.bottomCenter,
                                                                                        colors: [
                                                                                          Colors.white.withOpacity(0.3),
                                                                                          Colors.white.withOpacity(0),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          100.h,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          12,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                20.h,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 50.h,
                                                                              child: Text(
                                                                                "${storyList[storyList.length - index - 1].title}",
                                                                                textAlign: TextAlign.center,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontSize: 20.sp, fontFamily: 'Acherus', color: Colors.black, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      right: 5,
                                                                      top: 45,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _onPressDelete(
                                                                                StoryModel(
                                                                                  sid: storyList[storyList.length - index - 1].sid,
                                                                                  uid: AuthService.user!.uid,
                                                                                  image: '',
                                                                                  isDeleted: true,
                                                                                  story: storyList[storyList.length - index - 1].story,
                                                                                  title: storyList[storyList.length - index - 1].title,
                                                                                ),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red,
                                                                              size: 25.sp,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .youHavent,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontFamily: 'Acherus',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: double.infinity,
                                            width: double.infinity,
                                            child: RefreshIndicator(
                                              onRefresh: _onRefresh,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(
                                                        parent:
                                                            AlwaysScrollableScrollPhysics()),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(
                                                      height: 50,
                                                    ),
                                                    Image.asset(
                                                      'images/add_story_1.png',
                                                      height: 250,
                                                      width: 250,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    CustomFormField(
                                                      labelText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .stTitle,
                                                      textEditingController:
                                                          titleController,
                                                      inputType:
                                                          TextInputType.text,
                                                      prefixIcon: const Icon(
                                                        Icons.keyboard,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    CustomFormField(
                                                      fieldHeight: 120,
                                                      maxline: 6,
                                                      minLine: 6,
                                                      labelText: "",
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .stStarting,
                                                      textEditingController:
                                                          storyController,
                                                      inputType:
                                                          TextInputType.text,
                                                      prefixIcon: const Icon(
                                                        Icons.keyboard,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 40,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              120,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10))),
                                                        onPressed: () {
                                                          _onPressGenerateStory();
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .createSt
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                  ],
                                ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  child: Image.asset(
                    "images/chatgpt_load.gif",
                    // fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                )),
          );
        }
      },
    );
  }

  Widget buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.sp, 0.sp, 14.sp, 0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(140.w, 0, 140.w, 0),
              child: const Divider(
                thickness: 4,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentlanguage!),
                SizedBox(
                  child: DropdownButton<Language>(
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.language,
                      color: Colors.black,
                      size: 30.sp,
                    ),
                    onChanged: (Language? language) async {
                      if (language != null) {
                        Locale _locale = await setLocale(language.languageCode);
                        MyApp.setLocale(context, _locale);
                      }
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, StoryCreateAndList.routeName);
                    },
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>(
                          (e) => DropdownMenuItem<Language>(
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  e.flag,
                                  style: const TextStyle(fontSize: 30),
                                ),
                                Text(
                                  e.name,
                                  style: const TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0.5,
                  backgroundColor: const Color(0xFFF44236),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              child: Text(
                AppLocalizations.of(context)!.signOut,
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getlanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String langcode = _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
    for (int i = 0; i < 9; i++) {
      if (langcode == "fr") {
        currentlanguage = "Français";
      } else if (langcode == "ar") {
        currentlanguage = "اَلْعَرَبِيَّةُ";
      } else if (langcode == "bn") {
        currentlanguage = "বাংলা";
      } else if (langcode == "de") {
        currentlanguage = "Deutsch";
      } else if (langcode == "es") {
        currentlanguage = "Español";
      } else if (langcode == "hi") {
        currentlanguage = "हिंदी";
      } else if (langcode == "pt") {
        currentlanguage = "Português";
      } else if (langcode == "zh") {
        currentlanguage = "中国人";
      } else
        currentlanguage = "English";
    }
  }
}
