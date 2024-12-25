import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nom_du_projet/app/data/constant.dart';
import 'dart:convert';

import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/widgets/message/chat_screen.dart';

import '../../data/models/conversation_model.dart';
import '../../services/chat_service.dart';

class NewConversationScreen extends StatefulWidget {
  @override
  _NewConversationScreenState createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _users = [Env.userOther];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchUsers(_searchController.text);
      } else {
        setState(() => _users = []);
      }
    });
  }

  Future<void> _searchUsers(String query) async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/users/search?q=$query'),
        headers: {'Authorization': 'Bearer ${box.read("token")}'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _users = data.map((json) => UserModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Erreur lors de la recherche');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de recherche')),
      );
    }
  }

  Future<void> _startConversation(UserModel user) async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${startconversationUrl}'),
        headers: {
          'Authorization': 'Bearer ${box.read("token")}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'user_id': user.id}),
      );

      if (response.statusCode == 200) {
         print("SUCCESS ${response.body}");
        final conversation = Conversation.fromJson(json.decode(response.body));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(conversation: conversation),
          ),
        );
      } else {
        print("ERROR ${response.body}");
        throw Exception('Erreur lors de la création de la conversation ${response.body}');
      }
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de création de la conversation $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle conversation'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Recherchez un utilisateur pour démarrer une conversation'
                            : 'Aucun utilisateur trouvé',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: _users.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child: user.profileImage == null
                            ? Text(user.nom??""[0])
                            : null,
                      ),
                      title: Text(user.nom??""),
                      onTap: () => _startConversation(user),
                    );
                  },
                ),
    );
  }
}

// Ajoutez ce widget pour une meilleure expérience utilisateur
class UserSearchDelegate extends SearchDelegate<UserModel?> {
  final Future<List<UserModel>> Function(String) searchUsers;

  UserSearchDelegate({required this.searchUsers});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur de recherche'),
          );
        }

        final users = snapshot.data ?? [];
        
        if (users.isEmpty) {
          return Center(
            child: Text('Aucun utilisateur trouvé'),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: user.profileImage == null ? Text(user.nom??""[0]) : null,
              ),
              title: Text(user.nom??""),
              onTap: () {
                close(context, user);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}