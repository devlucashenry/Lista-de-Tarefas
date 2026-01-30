import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: TaskList()));
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final controller = TextEditingController();


  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Nova tarefa...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      // O Front apenas "pede" para salvar
                      _taskService.addTask(controller.text);
                      controller.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(

              stream: _taskService.getTasksStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('Erro ao carregar');
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                return ListView(
                  children: snapshot.data!.docs.map((doc) {

                    String docId = doc.id;

                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['titulo']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {

                          _taskService.deleteTask(docId);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}