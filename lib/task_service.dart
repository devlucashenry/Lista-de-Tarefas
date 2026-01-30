import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {

  final CollectionReference _tasksCollection =
  FirebaseFirestore.instance.collection('tarefas');


  Stream<QuerySnapshot> getTasksStream() {
    return _tasksCollection
        .orderBy('criado Em', descending: true)
        .snapshots();
  }

  // INSERT: Adicionar tarefa
  Future<void> addTask(String title) async {
    await _tasksCollection.add({
      'titulo': title,
      'criado Em': DateTime.now(),
    });
  }

  // DELETE: Apagar tarefa pelo ID
  Future<void> deleteTask(String docId) async {
    await _tasksCollection.doc(docId).delete();
  }
}