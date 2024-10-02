import 'package:flutter/material.dart';
import 'package:flutter_app/repositories/wiki_repo.dart';
import 'package:flutter_app/views/wiki/wiki_detail_page.dart';
import 'package:flutter_app/views/wiki/search_bar_wiki.dart';
import 'package:flutter_app/models/wiki.dart';

class WikiListPage extends StatefulWidget {
  @override
  State<WikiListPage> createState() => _WikiListPageState();
}

class _WikiListPageState extends State<WikiListPage> {
  final WikiRepository wikiRepository = WikiRepository();

  String searchVal = '';

  List<Wiki> searchResults = [];

  void _searchWikis(String query) {
    setState(() {
      searchVal = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Plant Wiki',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 93, 176, 117),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
            child: SearchAppBarWiki(
              hintLabel: "Search",
              onSubmitted: (value) {
                setState(() {
                  searchVal = value;
                });
                _searchWikis(value);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Wiki>>(
              stream: wikiRepository.streamAllWiki(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  final allWikis = snapshot.data!;
                  List<Wiki> filteredWikis = searchVal.isEmpty
                      ? allWikis
                      : allWikis
                          .where((Wiki) => Wiki.name!
                              .toLowerCase()
                              .startsWith(searchVal.toLowerCase()))
                          .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredWikis.length,
                    itemBuilder: (context, index) {
                      final wiki = filteredWikis[index];
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 500),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      wiki.imageUrl,
                                      height: 220,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  wiki.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              wiki.description.length > 120
                                  ? '${wiki.description.substring(0, 120)}...'
                                  : wiki.description,
                              style: TextStyle(
                                color: Color.fromARGB(
                                              255, 129, 129, 129),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WikiDetailPage(wiki: wiki),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
