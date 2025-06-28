class UserModel {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: '${json['first_name']} ${json['last_name']}',
      email: json['email'],
      avatar: json['avatar'],
      phone: '000-000-0000', // Dummy phone, API doesn't provide it
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': name.split(' ')[0],
      'last_name': name.split(' ').length > 1 ? name.split(' ')[1] : '',
      'email': email,
      'avatar': avatar,
    };
  }
}
