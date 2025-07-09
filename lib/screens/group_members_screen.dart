import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../services/mock_data_service.dart';

class GroupMembersScreen extends StatefulWidget {
  final GroupModel group;

  const GroupMembersScreen({super.key, required this.group});

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  List<UserModel> allUsers = [];
  List<UserModel> groupUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final users = await MockDataService.loadUsers();
    setState(() {
      allUsers = users;
      groupUsers = users
          .where((u) => widget.group.members.contains(u.id))
          .toList();
    });
  }

  void _showAddMemberDialog() {
    String phone = '';
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Enter phone number'),
            keyboardType: TextInputType.phone,
            onChanged: (val) => phone = val.trim(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final existingUser = allUsers.firstWhere(
                  (u) => u.phone == phone,
                  orElse: () => UserModel(id: '', name: '', phone: '', password: ''),
                );

                if (existingUser.id.isNotEmpty &&
                    !widget.group.members.contains(existingUser.id)) {
                  setState(() {
                    widget.group.members.add(existingUser.id);
                    groupUsers.add(existingUser);
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = groupUsers.where((u) {
      return u.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
             u.phone.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.group.name} Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Member',
            onPressed: _showAddMemberDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name or phone',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No members found.'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(user.name),
                        subtitle: Text(user.phone),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
