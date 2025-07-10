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
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();

                if (name.isEmpty || phone.isEmpty) return;

                UserModel? existingUser = allUsers.firstWhere(
                  (u) => u.phone == phone,
                  orElse: () => UserModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    phone: phone,
                    password: 'default123', // or prompt user to set
                  ),
                );

                // Add to global list if it's a new user
                if (!allUsers.any((u) => u.phone == phone)) {
                  setState(() {
                    allUsers.add(existingUser);
                  });
                }

                if (!widget.group.members.contains(existingUser.id)) {
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
