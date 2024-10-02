import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/view_models/me_vm.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> items = [
    { 
      'category': "water",
      'title': 'Watering Reminder',
      'content': 'Time to water Snaky today!',
      'date': '2024/6/25',
    },
    { 
      'category': "fertilize",
      'title': 'Fertilizing Reminder',
      'content': 'Don\'t forget to fertilize Snaky today!',
      'date': '2024/6/24',
    },
    { 
      'category': "prune",
      'title': 'Pruning Reminder',
      'content': 'It\'s time to prune Snaky today!',
      'date': '2024/6/21'
    },
    {
      'category': "app update",
      'title': 'App Update Notification',
      'content': 'New update available! Enjoy the latest features and improvements in your app.',
      'date': '2024/4/13'
    },
    { 
      'category': "fertilize",
      'title': 'Being a gardener',
      'content': 'A hands-on experience that involves nurturing plants from seed to maturity ...',
      'date': '2024/3/23'
    },
    { 
      'category': "app update",
      'title': 'Manual for this app',
      'content': 'A comprehensive guide that can be adapted to practically any app, helping users ...',
      'date': '2024/1/21'
    },
    { 
      'category': "water",
      'title': 'Hydration Hero',
      'content': 'Achieve the title of Hydration Hero by watering your plants a total of 1000 times.',
      'date': '2024/1/21'
    },
  ];

  void _addItem(String title, String content) {
    setState(() {
      items.add({
        'title': title,
        'content': content,
        'date': DateTime.now().toString().split(' ')[0],
      });
    });
    Navigator.of(context).pop();
  }

  void _showAddItemDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新增事項'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '標題'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: '內容'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _addItem(titleController.text, contentController.text);
              },
              child: Text('增加'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final meViewModel = Provider.of<MeViewModel>(context);

    if(meViewModel.isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final me = meViewModel.me;

    Icon _getIconByCategory(String category) {
    switch (category) {
      case 'water':
        return Icon(Icons.water_drop, color: Colors.blue);
      case 'fertilize':
        return Icon(Icons.compost, color: Colors.brown);
      case 'prune':
        return Icon(Icons.eco, color: Colors.green);
      case 'app update':
        return Icon(Icons.app_settings_alt, color: Colors.orange);
      default:
        return Icon(Icons.notification_important, color: Colors.grey);
    }
  }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 28, color: Colors.white, 
            fontWeight: FontWeight.bold,)),
        backgroundColor: const Color.fromARGB(255, 93, 176, 117),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              /*Provider.of<PushMessagingService>(context, listen: false)
                  .unsubscribeFromAllTopics();*/
              Provider.of<AuthenticationService>(context, listen: false)
                .logOut();
              context.go('/cover'); // 使用 GoRouter 進行導航
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 120,
                        color: const Color.fromARGB(255, 93, 176, 117),
                      ),
                      Container(
                        height: 40, 
                        decoration: BoxDecoration(color: Colors.white),),
                    ],
                  ),
                  Positioned(
                    top: 20,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: me?.avatarUrl != null && me!.avatarUrl!.isNotEmpty
                                    ? NetworkImage(me.avatarUrl!)
                                    : const AssetImage('assets/placeholder.png') as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Container(height: 10, decoration: BoxDecoration(color: Colors.white),),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(children: [
                  Text('${me?.userName}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  Text('LVL. 5', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],)
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 16, left: 48, right: 48),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: _getIconByCategory(items[index]['category']!),
                        title: Text(items[index]['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(items[index]['content']!),
                        trailing: Text(items[index]['date']!, style: TextStyle(color: Colors.grey)),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.grey);
                    },
                  ),
                ),
              ),
            ],
          ),
          /*Positioned(
            bottom: 25.0, 
            right: 16.0,
            child: FloatingActionButton(
              shape: CircleBorder(eccentricity: 1.0),
              elevation: 5,
              onPressed: _showAddItemDialog,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 93, 176, 117),
            ),
          ),*/
        ],
      ),
    );
  }
}
