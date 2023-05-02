class UserModel {
  String? uid;
  String? email;
  String? createdAt;
  String? subscriptionPlan;
  String? subscriptionDate;

  UserModel({
    this.uid,
    this.email,
    this.createdAt,
    this.subscriptionPlan,
    this.subscriptionDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'created_at': createdAt,
      'subscription_plan': subscriptionPlan,
      'subscription_date': subscriptionDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'],
        email: map['email'],
        createdAt: map['created_at'],
        subscriptionPlan: map['subscription_plan'],
        subscriptionDate: map['subscription_date'],
      );
}
