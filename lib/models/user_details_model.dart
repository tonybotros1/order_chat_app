class UserDetailsModel {
  String? name;
  String? profilePicture;
  String? phoneNumber;
  List<dynamic>? userRole;
  String? user_id;
  String? location;
  String? userToken;

  UserDetailsModel({
    this.location,
    this.name,
    this.phoneNumber,
    this.profilePicture,
    this.userRole,
    this.user_id,
    this.userToken,
  });

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    userRole = json['user_role'];
    user_id = json['user_id'];
    userToken = json['user_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['profile_picture'] = this.profilePicture;
    data['user_role'] = this.userRole;
    data['user_id'] = this.user_id;
    data['user_token'] = this.userToken;
    return data;
  }
}
