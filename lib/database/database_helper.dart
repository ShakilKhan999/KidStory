import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/story_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static const String collectionUser = 'user';
  static const String collectionStory = 'story';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> insertUserData(UserModel userModel) async {
    return await _db
        .collection(collectionUser)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  static Future<void> insertStoryData(StoryModel storyModel) async {
    return await _db
        .collection(collectionStory)
        .doc(storyModel.sid)
        .set(storyModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getStoryList(
      {required String uid}) {
    return _db
        .collection(collectionStory)
        .where('uid', isEqualTo: uid)
        .where('is_deleted', isEqualTo: false)
        .snapshots();
  }

  Future<UserModel?> getUserData(String uid) async {
    UserModel? userModel;
    await _db.collection(collectionUser).doc(uid).get().then(
      (value) {
        userModel = UserModel(
          uid: value.data()!['uid'].toString(),
          email: value.data()!['email'].toString(),
          createdAt: value.data()!['created_at'].toString(),
          subscriptionPlan: value.data()!['subscription_plan'].toString(),
          subscriptionDate: value.data()!['subscription_date'].toString(),
        );
      },
    );
    return userModel;
  }

  Future<void> updateUserData(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  Future<void> updateStoryData(StoryModel storyModel) {
    return _db
        .collection(collectionStory)
        .doc(storyModel.sid)
        .set(storyModel.toMap());
  }
}
