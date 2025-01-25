import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final List<String> _todoItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Todos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(tabs: [
                Tab(text: "To Do"),
                Tab(text: "In Progress"),
                Tab(text: "Done")
              ]),
              Expanded(
                  child: TabBarView(children: [
                _kanbanBuilder(_todoItems, "To Do"),
                _kanbanBuilder(_todoItems, "In Progress"),
                _kanbanBuilder(_todoItems, "Done"),
              ])),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _kanbanBuilder(List<String> items, String title) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(title: Text(items[index])));
  }
}
