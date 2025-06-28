import 'package:flutter/material.dart';
import 'package:user_list/features/user_list/domain/model/user_model.dart';
import 'package:user_list/features/user_list/presentation/view/user_detail_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserDetailPage(user: user)),
          );
        },
      ),
    );
  }
}
