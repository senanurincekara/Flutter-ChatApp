class userProfile {
  String? uid;
  String? name;
  String? profilePicUrl;

  userProfile(
      {required this.uid, required this.name, required this.profilePicUrl});

  userProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    profilePicUrl = json['pfpURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['pfpURL'] = profilePicUrl;
    data['uid'] = uid;
    return data;
  }
}
