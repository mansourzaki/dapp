import 'package:dapp_f/TodoListModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool? _status = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoListModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await model.addTask('10');
        //  await model.getTask(BigInt.parse('9'));
         await model.getTasks();
        },
        child: Icon(Icons.get_app),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, i) => const ListTile(
                      title: Text('test'),
                      subtitle: Text('completed'),
                    )),
          ),
          Expanded(
              flex: 4,
              child: Row(
                children: [
                  const Expanded(flex: 1, child: TextField()),
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text('add Task'))),
                ],
              ))
        ],
      ),
    );
  }
}
