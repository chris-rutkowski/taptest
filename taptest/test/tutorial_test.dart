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
          return _MyApp(params: params);
        },
      );
    },
  );

  tapTest('Tutorial', config, (tester) async {
    await tester.exists(_AppKeys.homeScreen);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 0');
    await tester.snapshot('HomeScreen_initial');

    await tester.tap(_AppKeys.incrementButton);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 1');
    await tester.tap(_AppKeys.incrementButton, count: 2);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 3');
    await tester.snapshot('HomeScreen_counter3');

    await tester.type(_AppKeys.nameField, 'John Doe');
    await tester.tap(_AppKeys.submitButton);
    await tester.info('On Details screen');
    await tester.exists(_AppKeys.detailsScreen);
    await tester.expectText(_AppKeys.welcomeMessage, 'Welcome John Doe!');
    await tester.snapshot('DetailsScreen_JohnDoe');

    await tester.pop();
    await tester.info('On Home screen');
    await tester.exists(_AppKeys.homeScreen);

    await tester.type(_AppKeys.nameField, '');
    await tester.tap(_AppKeys.submitButton);
    await tester.exists(_AppKeys.errorDialog);
    await tester.tap(_AppKeys.errorDialogOKButton);
    await tester.absent(_AppKeys.errorDialog);

    // Whitespace-only input should trigger validation
    await tester.type(_AppKeys.nameField, ' ');
    await tester.tap(_AppKeys.submitButton);
    await tester.exists(_AppKeys.errorDialog);
    await tester.tap(_AppKeys.errorDialogOKButton);
    await tester.absent(_AppKeys.errorDialog);

    // Input trimming - messy spacing should be cleaned up
    await tester.type(_AppKeys.nameField, '  Alice   ');
    await tester.tap(_AppKeys.submitButton);
    await tester.info('On Details screen');
    await tester.exists(_AppKeys.detailsScreen);
    await tester.expectText(_AppKeys.welcomeMessage, 'Welcome Alice!');
  });

  tapTest('100-taps challenge', config, (tester) async {
    await tester.exists(_AppKeys.homeScreen);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 0');
    await tester.tap(_AppKeys.incrementButton);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 1');
    await tester.tap(_AppKeys.incrementButton);
    await tester.tap(_AppKeys.incrementButton);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 3');
    await tester.tap(_AppKeys.incrementButton, count: 7);
    await tester.expectText(_AppKeys.counterLabel, 'Click counter: 10');

    for (var i = 11; i <= 100; i++) {
      await tester.tap(_AppKeys.incrementButton);
      await tester.expectText(_AppKeys.counterLabel, 'Click counter: $i');
    }
  });
}

abstract class _AppKeys {
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

final class _MyApp extends StatelessWidget {
  final RuntimeParams? params;

  const _MyApp({
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _HomeScreen(),
      themeMode: params?.themeMode.value,
      debugShowCheckedModeBanner: params == null,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

final class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<_HomeScreen> {
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
        key: _AppKeys.errorDialog,
        title: Text('No name'),
        content: Text('Please enter a name.'),
        actions: [
          TextButton(
            key: _AppKeys.errorDialogOKButton,
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
      key: _AppKeys.homeScreen,
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
                    key: _AppKeys.nameField,
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Enter name'),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  key: _AppKeys.submitButton,
                  onPressed: () {
                    final trimmedName = nameController.text.trim();
                    if (trimmedName.isEmpty) {
                      showNoNameErrorDialog();
                      return;
                    }

                    final navigator = Navigator.of(context);
                    navigator.push(
                      MaterialPageRoute(builder: (context) => _DetailScreen(name: trimmedName)),
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Click counter: $counter',
              key: _AppKeys.counterLabel,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _AppKeys.incrementButton,
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

final class _DetailScreen extends StatelessWidget {
  final String name;

  const _DetailScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _AppKeys.detailsScreen,
      appBar: AppBar(title: Text('Detail Screen')),
      body: Center(
        child: Text(
          'Welcome $name!',
          key: _AppKeys.welcomeMessage,
        ),
      ),
    );
  }
}
