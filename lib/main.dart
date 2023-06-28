import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // used to access user input
    final txtController = TextEditingController();

    // defines location of the firestore document
    final db = FirebaseFirestore.instance;
    final col = db.collection('text_documents');
    final doc = col.doc('example');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InputSection(txtController: txtController, doc: doc),
            // Watches for updates and builds
            StreamBuilder(
              stream: doc.snapshots(),
              builder: (context, snapshot) {
                String txt = "";

                if (snapshot.data.isDefinedAndNotNull &&
                    snapshot.data!.data()!.containsKey("summary")) {
                  // retrieves summary text from firestore when available
                  txt = snapshot.data!['summary'];
                }

                return SelectableText(txt);
              },
            )
          ],
        ),
      ),
    );
  }
}

class InputSection extends StatelessWidget {
  const InputSection({
    super.key,
    required this.txtController,
    required this.doc,
  });

  final TextEditingController txtController;
  final DocumentReference<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: 5,
          controller: txtController,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        ElevatedButton(
            onPressed: () {
              doc.set({"text": txtController.text});
            },
            child: Text("Submit")),
      ],
    );
  }
}
