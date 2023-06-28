# Flutter Summarizer with PalmAI and Firebase

This code demonstrates how to use Flutter with Firebase, and Firebase extensions to build an AI driven summarizer in literally a few lines of code. 

```dart
// Access Firebase
final doc = FirebaseFirestore.instance.collection('text_documents').doc('example');
…
// Write the long text
onPressed: () {
   doc.set({"text": txtController.text});
},
…
// Read the summary in Text Widget
stream: doc.snapshots()
…
Text(snapshot.data!['summary'])

```
