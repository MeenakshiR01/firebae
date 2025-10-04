import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key}); 
  @override 
  Widget build(BuildContext context) { 
    return const MaterialApp( 
      debugShowCheckedModeBanner: false, 
      home: StudentInputPage(), 
    ); 
  } 
} 
class StudentInputPage extends StatefulWidget { 
  const StudentInputPage({super.key}); 
  @override 
  State<StudentInputPage> createState() => _StudentInputPageState(); 
} 
class _StudentInputPageState extends State<StudentInputPage> { 
  final TextEditingController nameController = TextEditingController(); 
  final TextEditingController rollNoController = TextEditingController(); 
  final CollectionReference students = FirebaseFirestore.instance.collection( 
    'students', 
 
  ); 
  Future<void> addStudent() async { 
    String name = nameController.text.trim(); 
    String rollNo = rollNoController.text.trim(); 
    if (name.isNotEmpty && rollNo.isNotEmpty) { 
      await students.add({ 
        'name': name, 
        'rollNo': rollNo, 
        'createdAt': FieldValue.serverTimestamp(), 
      }); 
      // Clear textfields after saving 
      nameController.clear(); 
      rollNoController.clear(); 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar(content: Text("Student added successfully!")), 
      ); 
    } else { 
      ScaffoldMessenger.of( 
        context, 
      ).showSnackBar(const SnackBar(content: Text("Please fill both fields."))); 
    } 
  } 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text("Add Student"), 
        backgroundColor: Colors.blue, 
      ), 
      body: Padding( 

 
        padding: const EdgeInsets.all(16.0), 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            TextField( 
              controller: nameController, 
              decoration: const InputDecoration( 
                labelText: "Name", 
                border: OutlineInputBorder(), 
              ), 
            ), 
            const SizedBox(height: 16), 
            TextField( 
              controller: rollNoController, 
              decoration: const InputDecoration( 
                labelText: "Roll No", 
                border: OutlineInputBorder(), 
              ), 
              keyboardType: TextInputType.number, 
            ), 
            const SizedBox(height: 20), 
            ElevatedButton(onPressed: addStudent, child: const Text("Save")), 
          ], 
        ), 
      ), 
    ); 
  } 
}