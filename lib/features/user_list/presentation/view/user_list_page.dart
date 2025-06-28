import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user_list_cubit.dart';
import '../widgets/user_card.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<UserListCubit>().fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                context.read<UserListCubit>().search(searchQuery);
              },
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<UserListCubit>().fetchUsers(isRefresh: true);
              },
              child: BlocBuilder<UserListCubit, UserListState>(
                builder: (context, state) {
                  if (state is UserListLoading && state.isRefresh) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserListError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    context.read<UserListCubit>().fetchUsers(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is UserListEmpty) {
                    return const Center(child: Text('No users found.'));
                  } else if (state is UserListLoaded) {
                    if (state.users.isEmpty) {
                      return const Center(
                        child: Text('No users match the search.'),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        return UserCard(user: state.users[index]);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
