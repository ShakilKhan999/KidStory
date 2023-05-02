import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:kids_story/models/user_model.dart';
import 'package:kids_story/screens/story_create_and_list.dart';
import 'package:kids_story/utils/constant.dart';
import 'package:kids_story/utils/snackbar.dart';

import '../auth/auth_service.dart';
import '../database/database_helper.dart';
import '../models/story_model.dart';
import '../models/story_response_model.dart';

class ChaGptProvider extends ChangeNotifier {
  String story = '';
  String imageUrl = '';
  List<StoryModel> storyList = [];
  List<StoryModel> userStoryList = [];
  bool storycreated = true;
  final _random = new Random();
  late UserModel userData;

  List<String> coverImage = [
    "images/cvr1.jpg",
    "images/cvr2.jpg",
    "images/cvr3.jpg",
    "images/cvr4.jpg",
    "images/cvr5.jpg"
  ];

  getStory({
    required String title,
    required String storyLine,
    required BuildContext context,
    required String language,
    required bool isDeleted,
  }) async {
    String story = '';
    storycreated = false;
    // EasyLoading.show();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $TOKEN'
    };
    var request = http.Request('POST', Uri.parse('$BASE_URL/completions'));
    request.body = json.encode({
      "model": STORY_MODEL,
      "prompt":
          "$STORY_PREFIX $title in $language language easy to read and understand children's story of about 300 words that begins with  ${AppLocalizations.of(context)!.onceUpon} $storyLine",
      "max_tokens": 4000,
      "temperature": 0
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      StoryResponse storyResponse =
          storyResponseFromJson(await response.stream.bytesToString());
      story = storyResponse.choices![0].text!;
      print(story);
      final storyModel = StoryModel(
        sid: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: AuthService.user!.uid,
        title: title,
        story: story,
        image: imageUrl,
        isDeleted: isDeleted,
      );

      await DatabaseHelper.insertStoryData(storyModel);
      await getStoryByUser();
      storycreated = true;
      notifyListeners();
    } else {
      CustomSnackbar(
              context: context, title: 'Failed', message: 'Story saved fail')
          .showSnackbar();
    }
  }

  // getStoryImage() async {
  //   String imageUrl = '';
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $TOKEN'
  //   };
  //   var request =
  //       http.Request('POST', Uri.parse('$BASE_URL/images/generations'));
  //   request.body = json.encode({
  //     "prompt": "cover photo of a hunter and a bird story",
  //     "n": 1,
  //     "size": "256x256"
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     StoryImageResponse storyImageResponse =
  //         storyImageResponseFromJson(await response.stream.bytesToString());
  //     imageUrl = storyImageResponse.data![0].url!;
  //     notifyListeners();
  //   } else {
  //     log(response.reasonPhrase.toString());
  //   }
  // }

  getStoryByUser() async {
    storyList.clear();
    userStoryList.clear();
    DatabaseHelper.getStoryList(uid: AuthService.user!.uid).listen((event) {
      storyList = List.generate(event.docs.length,
          (index) => StoryModel.fromMap(event.docs[index].data()));

      if (storyList.isNotEmpty) {
        for (int i = 0; i < storyList.length; i++) {
          userStoryList.add(StoryModel(
            sid: storyList[i].sid,
            uid: storyList[i].uid,
            title: storyList[i].title,
            image: storyList[i].image,
            story: storyList[i].story,
            isDeleted: storyList[i].isDeleted,
          ));
        }
      }
      notifyListeners();
    });
  }

  getUserData() async {
    UserModel? userModel =
        await DatabaseHelper().getUserData(AuthService.user!.uid);
    if (userModel != null) {
      userData = userModel;
      notifyListeners();
    }
  }

  updateUserData(BuildContext context, String subscriptionDate) {
    DatabaseHelper()
        .updateUserData(UserModel(
      uid: AuthService.user!.uid,
      createdAt: userData.createdAt,
      email: userData.email,
      subscriptionPlan: 'paid',
      subscriptionDate: subscriptionDate,
    ))
        .then(
      (value) {
        AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Congratulations',
          desc: 'Subscription Successfull',
          btnOkOnPress: () {
            Navigator.pushReplacementNamed(
                context, StoryCreateAndList.routeName);
          },
        ).show();
      },
    );
  }

  updateStoryData(StoryModel storyModel) async {
    await DatabaseHelper().updateStoryData(storyModel).then(
      (value) {
        userStoryList.clear();
        storyList.clear();
        getStoryByUser();
      },
    );
  }
}
