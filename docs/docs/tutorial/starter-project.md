# 🚀 Starter project

Let's start fresh! Create a brand new Flutter project, ideally using the **Empty Application** template - this gives us a clean slate without any boilerplate code. Once your project is created, navigate to `lib/main.dart` and replace the entire contents with the following source code. This creates a simple two-screen app with a counter, text input field, form validation, and navigation - perfect for demonstrating TapTest's capabilities!

```dart title="lib/main.dart"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  var counter = 0;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void showNoNameErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No name'),
        content: Text('Please enter a name.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK')
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Enter name'),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final trimmedName = nameController.text.trim();
                    if (trimmedName.isEmpty) {
                      showNoNameErrorDialog();
                      return;
                    }

                    final navigator = Navigator.of(context);
                    navigator.push(
                      MaterialPageRoute(builder: (context) => DetailScreen(name: trimmedName)),
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text('Click counter: $counter'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            counter++;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

final class DetailScreen extends StatelessWidget {
  final String name;

  const DetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Screen')),
      body: Center(child: Text('Welcome $name!')),
    );
  }
}
```

## 🚀 Run and Explore

Don't forget to:

```bash
flutter pub get
```

Run this project and get familiar with the app before we dive into testing.

- ✅ Tap the counter button multiple times - see how it increments
- ✅ Try entering a name in the text field and submitting it
- ✅ Test the validation by submitting an empty form
- ✅ Navigate between screens and see how everything works

Understanding your app's behavior is crucial before writing tests. Play around with it, break it if you can, and notice the user flows - this hands-on exploration will make the testing tutorial much more meaningful!

## 📚 Next Steps

👉 **[Continue to next  page →](../tutorial-basics/tt-tutorial.md)**
