import 'package:flutter/material.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/views/wiki/wiki_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/models/todo.dart';
import 'package:flutter_app/repositories/todo_repo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/view_models/me_vm.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_app/repositories/message_repo.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoRepository _todoRepository = TodoRepository();
  final MessageRepository repo = MessageRepository();

  // hard code for heat map
  Map<DateTime, int> heatMapDatasets = {
    DateTime(2024, 5, 6): 8,
    DateTime(2024, 5, 7): 7,
    DateTime(2024, 6, 8): 10,
    DateTime(2024, 6, 22): 12,
    DateTime(2024, 6, 12): 10,
    DateTime(2024, 5, 20): 10,
  };

  @override
  void initState() {
    super.initState();
    updateHeatMapWithTodayActivity();
  }

  void updateHeatMapWithTodayActivity() async {
    int todayMessageCount = await repo.countTodayMessages();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    setState(() {
      heatMapDatasets[today] = todayMessageCount; // Update the map
    });

    print("todayMessageCount: $todayMessageCount");
    print("today: $today");
    print("$heatMapDatasets");
  }

  void _updateTodoItem(Todo item) async {
    try {
      await _todoRepository
          .updateTodoItem(item.id, {'isCompleted': !item.isCompleted});
    } catch (e) {
      print('Error updating todo item: $e');
    }
  }

  void _addTodoItem(String item) async {
    try {
      Todo newItem = Todo(
        id: '',
        title: item,
        isCompleted: false,
      );
      await _todoRepository.addTodoItem(newItem);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to-do item: $e')),
      );
    }
  }

  void _showAddTodoDialog() {
    final TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add to-do'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "content:"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                if (_textFieldController.text.isNotEmpty) {
                  _addTodoItem(_textFieldController.text);
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Please enter some text')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final meViewModel = Provider.of<MeViewModel>(context);
    final me = meViewModel.me;

    if (meViewModel.isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 93, 176, 117),
            padding: EdgeInsets.only(left: 20, bottom: 20, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'v0.0.1',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Column(
                      children: [
                        Text(
                          'GARDEN',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'JuliusSansOne',
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'GUARDIAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'JuliusSansOne',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        context.go('/profile');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Good morning, ${me?.userName}.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Pumpkin is usually considered a vegetable, it contains many seeds inside and is actually a member of the fruit family!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WikiListPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: Row(
                        children: [
                          const SizedBox(width: 80),
                          Text(
                            '${me?.userName!}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 35),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Lv.5',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () {
                              context.go('/profile');
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 300,
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 12,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '28°C  ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Icon(
                                        Icons.wb_sunny,
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('MMMM d, yyyy')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 129, 129, 129),
                                        ),
                                      ),
                                      Text(
                                        ' | Hsinchu',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 129, 129, 129),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: HeatMap(
                                        scrollable: true,
                                        datasets: heatMapDatasets,
                                        colorsets: const {
                                          1: Colors.red,
                                          3: Colors.orange,
                                          5: Colors.yellow,
                                          7: Colors.green,
                                          9: Colors.blue,
                                          11: Colors.indigo,
                                          13: Colors.purple,
                                        },
                                        startDate: DateTime.now()
                                            .subtract(Duration(days: 60)),
                                        endDate: DateTime.now(),
                                        showColorTip: true,
                                        onClick: (value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text(value.toString())),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'To-do list',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(144, 0, 0, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder<List<Todo>>(
                                      stream: _todoRepository.streamAllTodos(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                              child:
                                                  Text('No to-dos available'));
                                        } else {
                                          final _todoList = snapshot.data!;
                                          return ListView.builder(
                                            padding: EdgeInsets.all(0),
                                            itemCount: _todoList.length,
                                            itemBuilder: (context, index) {
                                              final todo = _todoList[index];
                                              return ListTileTheme(
                                                dense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 3,
                                                        vertical: 2),
                                                minVerticalPadding: 2,
                                                child: ListTile(
                                                  visualDensity: VisualDensity(
                                                      vertical: 0.5),
                                                  leading: Checkbox(
                                                    side: BorderSide(
                                                      color: Color.fromARGB(
                                                          144, 0, 0, 0),
                                                    ),
                                                    shape: CircleBorder(),
                                                    value: todo.isCompleted,
                                                    onChanged: (bool? value) {
                                                      _updateTodoItem(todo);
                                                    },
                                                  ),
                                                  title: Text(
                                                    todo.title,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          144, 0, 0, 0),
                                                      fontSize: 20,
                                                      decoration: todo
                                                              .isCompleted
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_rounded,
                                        color: Color.fromARGB(96, 0, 0, 0),
                                        size: 20,
                                      ),
                                      onPressed: _showAddTodoDialog,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: CircleAvatar(
                  backgroundImage:
                      me?.avatarUrl != null && me!.avatarUrl!.isNotEmpty
                          ? NetworkImage(me.avatarUrl!)
                          : const AssetImage('assets/placeholder.png')
                              as ImageProvider,
                  radius: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            'Water intake record',
                            const Color.fromARGB(255, 196, 228, 244),
                            const Color.fromARGB(255, 49, 163, 254),
                            Icons.local_drink,
                            'Goal 2000ml\nachieved for 6 days',
                            'Click to view record',
                            0,
                            () {
                              Provider.of<NavigationService>(context,
                                      listen: false)
                                  .goDrinkWater();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildButton(
                            'Planting challenge',
                            const Color.fromARGB(255, 216, 243, 224),
                            const Color.fromARGB(255, 112, 187, 134),
                            Icons.hotel_class_rounded,
                            'Planted 8 plants\nhighest difficulty 3★',
                            'Click to view record',
                            0,
                            () {
                              context.go('/goal');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildButton(
                            'Profile',
                            const Color.fromARGB(255, 255, 225, 197),
                            const Color.fromARGB(255, 255, 149, 52),
                            Icons.account_circle,
                            'Edit user information\nset preferences',
                            '',
                            0,
                            () {
                              context.go('/profile');
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: _buildButton(
                                  'Plant encyclopedia',
                                  const Color.fromARGB(255, 148, 223, 170),
                                  Colors.white,
                                  Icons.book,
                                  'Science encyclopedia\nplant care guide',
                                  '',
                                  0,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WikiListPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color color,
    Color iconColor,
    IconData icon,
    String description,
    String linkText,
    int type,
    VoidCallback onPressed,
  ) {
    double iconSize = type == 0 ? 40 : 24;
    double topPadding = type == 0 ? 12 : 7;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(left: 20, top: topPadding),
      ),
      onPressed: onPressed,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 10,
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 10.0, bottom: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 120, 120, 120),
                    ),
                  ),
                ],
                if (linkText.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Text(
                          linkText,
                          style: TextStyle(fontSize: 20, color: iconColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
