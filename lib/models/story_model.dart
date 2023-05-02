class StoryModel {
  String? sid;
  String? uid;
  String? title;
  String? story;
  String? image;
  bool isDeleted;

  StoryModel(
      {this.sid,
      this.uid,
      this.title,
      this.story,
      this.image,
      this.isDeleted = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sid': sid,
      'uid': uid,
      'title': title,
      'story': story,
      'image': image,
      'is_deleted': isDeleted,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) => StoryModel(
        sid: map['sid'],
        uid: map['uid'],
        title: map['title'],
        story: map['story'],
        image: map['image'],
        isDeleted: map['is_deleted'],
      );
}
