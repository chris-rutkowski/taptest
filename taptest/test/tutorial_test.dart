import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

void main() {
  final config = Config(
    screenSize: const Size(350, 600),
    builder: (params) {
      return ListenableBuilder(
        listenable: Listenable.merge([params.themeMode, params.locale]),
        builder: (context, _) {
          return MyApp(params: params);
        },
      );
    },
  );

  tapTest('Tutorial', config, (tester) async {
    await tester.exists(AppKeys.homeScreen);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
    await tester.snapshot('HomeScreen_initial');

    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
    await tester.tap(AppKeys.incrementButton, count: 2);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 3');
    await tester.snapshot('HomeScreen_counter3');

    await tester.type(AppKeys.nameField, 'John Doe');
    await tester.tap(AppKeys.submitButton);
    await tester.info('On Details screen');
    await tester.exists(AppKeys.detailsScreen);
    await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
    await tester.snapshot('DetailsScreen_JohnDoe');

    await tester.pop();
    await tester.info('On Home screen');
    await tester.exists(AppKeys.homeScreen);

    await tester.type(AppKeys.nameField, '');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton, sync: SyncType.settled);
    await tester.absent(AppKeys.errorDialog);

    // Whitespace-only input should trigger validation
    await tester.type(AppKeys.nameField, ' ');
    await tester.tap(AppKeys.submitButton);
    await tester.exists(AppKeys.errorDialog);
    await tester.tap(AppKeys.errorDialogOKButton);
    await tester.absent(AppKeys.errorDialog);

    // Input trimming - messy spacing should be cleaned up
    await tester.type(AppKeys.nameField, '  Alice   ');
    await tester.tap(AppKeys.submitButton, sync: SyncType.settled);
    await tester.info('On Details screen');
    await tester.exists(AppKeys.detailsScreen);
    await tester.expectText(AppKeys.welcomeMessage, 'Welcome Alice!');
  });

  tapTest('1000-taps challenge', config, (tester) async {
    await tester.exists(AppKeys.homeScreen);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 0');
    await tester.tap(AppKeys.incrementButton);
    await tester.expectText(AppKeys.counterLabel, 'Click counter: 1');
  });
}

abstract class AppKeys {
  static const homeScreen = ValueKey('HomeScreen');
  static const counterLabel = ValueKey('CounterLabel');
  static const incrementButton = ValueKey('IncrementButton');
  static const nameField = ValueKey('NameField');
  static const submitButton = ValueKey('SubmitButton');
  static const detailsScreen = ValueKey('DetailsScreen');
  static const welcomeMessage = ValueKey('WelcomeMessage');
  static const errorDialog = ValueKey('ErrorDialog');
  static const errorDialogOKButton = ValueKey('ErrorDialogOKButton');
}

final class MyApp extends StatelessWidget {
  final RuntimeParams? params;

  const MyApp({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      themeMode: params?.themeMode.value,
      debugShowCheckedModeBanner: params == null,
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
        key: AppKeys.errorDialog,
        title: Text('No name'),
        content: Text('Please enter a name.'),
        actions: [
          TextButton(
            key: AppKeys.errorDialogOKButton,
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.homeScreen,
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
                    key: AppKeys.nameField,
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Enter name'),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  key: AppKeys.submitButton,
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
            Text(
              'Click counter: $counter',
              key: AppKeys.counterLabel,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: AppKeys.incrementButton,
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
      key: AppKeys.detailsScreen,
      appBar: AppBar(title: Text('Detail Screen')),
      body: Center(
        child: Text(
          'Welcome $name!',
          key: AppKeys.welcomeMessage,
        ),
      ),
    );
  }
}
