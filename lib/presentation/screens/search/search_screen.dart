import 'package:flutter/material.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/presentation/screens/search/user_search_card.dart';
import 'package:user_repository/data.dart'; // Import User class

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.userRepository})
      : super(key: key);
  final UserRepository userRepository;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _repository = SearchRepository();
  List<User> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _repository.userStream.listen((users) {
      setState(() {
        _searchResults =
            users.where((user) => user != null).cast<User>().toList();
        _isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error here (e.g., show a toast or a dialog)
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Search',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      _repository.searchUser(query);
                    } else {
                      setState(() {
                        _searchResults = [];
                      });
                    }
                  },
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        fontSize: 21, color: Colors.black.withOpacity(0.7)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: tPrimaryColor,
                      ))
                    : ListView.separated(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              // go to profile

                              // save recent search
                              _repository.saveRecentSearch(user);
                            },
                            child: UserSearchCard(
                              user: user,
                              userRepository: widget.userRepository,
                            ),
                          );
                        },
                        separatorBuilder: (ctx, i) =>
                            const Divider(thickness: 0.2),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _repository.dispose();
    super.dispose();
  }
}
