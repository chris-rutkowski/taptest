import 'package:flutter/material.dart';
import 'package:taptest/taptest.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

void main() {
  final config = Config(
    variants: Variant.lightAndDarkVariants,
    builder: (params, _) {
      return _MyApp();
    },
  );

  tapTest('Tutorial', config, (tt) async {
    await tt.exists(_AppKeys.homeScreen);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 0');
    await tt.snapshot('HomeScreen_initial');

    await tt.tap(_AppKeys.incrementButton);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 1');
    await tt.tap(_AppKeys.incrementButton, count: 2);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 3');
    await tt.snapshot('HomeScreen_counter3');

    await tt.type(_AppKeys.nameField, 'John Doe');
    await tt.tap(_AppKeys.submitButton);
    await tt.info('On Details screen');
    await tt.exists(_AppKeys.detailsScreen);
    await tt.expectText(_AppKeys.welcomeMessage, 'Welcome John Doe!');
    await tt.snapshot('DetailsScreen_JohnDoe');

    await tt.pop();
    await tt.info('On Home screen');
    await tt.exists(_AppKeys.homeScreen);

    await tt.type(_AppKeys.nameField, '');
    await tt.tap(_AppKeys.submitButton);
    await tt.exists(_AppKeys.errorDialog);
    await tt.tap(_AppKeys.errorDialogOKButton);
    await tt.absent(_AppKeys.errorDialog);

    // Whitespace-only input should trigger validation
    await tt.type(_AppKeys.nameField, ' ');
    await tt.tap(_AppKeys.submitButton);
    await tt.exists(_AppKeys.errorDialog);
    await tt.tap(_AppKeys.errorDialogOKButton);
    await tt.absent(_AppKeys.errorDialog);

    // Input trimming - messy spacing should be cleaned up
    await tt.type(_AppKeys.nameField, '  Alice   ');
    await tt.tap(_AppKeys.submitButton);
    await tt.info('On Details screen');
    await tt.exists(_AppKeys.detailsScreen);
    await tt.expectText(_AppKeys.welcomeMessage, 'Welcome Alice!');
  });

  tapTest('Tutorial (PageObject)', config, (tt) async {
    await tt
        .onHomeScreen()
        .expectCounterLabel('Click counter: 0')
        .snapshot('HomeScreen_initial')
        .tapIncrementButton()
        .expectCounterLabel('Click counter: 1')
        .tapIncrementButton(count: 2)
        .expectCounterLabel('Click counter: 3')
        .snapshot('HomeScreen_counter3')
        .typeName('John Doe')
        .tapSubmit();

    await tt // dummy comment to force dart format to do one dot syntax per line
        .onDetailsScreen()
        .expectWelcomeMessage('Welcome John Doe!')
        .snapshot('DetailsScreen_JohnDoe')
        .pop();

    await tt
        .onHomeScreen()
        .typeName('')
        .tapSubmit()
        .expectErrorDialog()
        .closeErrorDialog()
        // Whitespace-only input should trigger validation
        .typeName(' ')
        .tapSubmit()
        .expectErrorDialog()
        .closeErrorDialog()
        // Input trimming - messy spacing should be cleaned up
        .typeName('  Alice   ')
        .tapSubmit();

    await tt // dummy comment to force dart format to do one dot syntax per line
        .onDetailsScreen()
        .expectWelcomeMessage('Welcome Alice!');
  });

  tapTest('100-taps challenge', config, (tt) async {
    await tt.exists(_AppKeys.homeScreen);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 0');
    await tt.tap(_AppKeys.incrementButton);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 1');
    await tt.tap(_AppKeys.incrementButton);
    await tt.tap(_AppKeys.incrementButton);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 3');
    await tt.tap(_AppKeys.incrementButton, count: 7);
    await tt.expectText(_AppKeys.counterLabel, 'Click counter: 10');

    for (var i = 11; i <= 100; i++) {
      await tt.tap(_AppKeys.incrementButton);
      await tt.expectText(_AppKeys.counterLabel, 'Click counter: $i');
    }
  });
}

// --- Below is the app being tested with the test(s) above ---

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

  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _HomeScreen(),
      themeMode: TapTestRuntime.of(context)?.themeMode,
      debugShowCheckedModeBanner: TapTestRuntime.of(context) == null,
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

// --- Below is the Page Object syntax ---

extension on TapTester {
  Future<_HomeScreenPageObject> onHomeScreen() async {
    await info('On Home screen');
    await exists(_AppKeys.homeScreen);
    return _HomeScreenPageObject(this);
  }

  Future<_DetailsScreenPageObject> onDetailsScreen() async {
    await info('On Details screen');
    await exists(_AppKeys.detailsScreen);
    return _DetailsScreenPageObject(this);
  }
}

final class _HomeScreenPageObject extends PageObject<_HomeScreenPageObject> {
  const _HomeScreenPageObject(super.tt);

  Future<_HomeScreenPageObject> tapIncrementButton({int count = 1}) async {
    await tt.tap(_AppKeys.incrementButton, count: count);
    return this;
  }

  Future<_HomeScreenPageObject> expectCounterLabel(String text) async {
    await tt.expectText(_AppKeys.counterLabel, text);
    return this;
  }

  Future<_HomeScreenPageObject> typeName(String name) async {
    await tt.type(_AppKeys.nameField, name);
    return this;
  }

  Future<_HomeScreenPageObject> tapSubmit() async {
    await tt.tap(_AppKeys.submitButton);
    return this;
  }

  Future<_HomeScreenPageObject> expectErrorDialog() async {
    await tt.exists(_AppKeys.errorDialog);
    return this;
  }

  Future<_HomeScreenPageObject> closeErrorDialog() async {
    await tt.tap(_AppKeys.errorDialogOKButton);
    await tt.absent(_AppKeys.errorDialog);
    return this;
  }
}

extension on Future<_HomeScreenPageObject> {
  Future<_HomeScreenPageObject> tapIncrementButton({int count = 1}) => then((r) => r.tapIncrementButton(count: count));
  Future<_HomeScreenPageObject> expectCounterLabel(String text) => then((r) => r.expectCounterLabel(text));
  Future<_HomeScreenPageObject> typeName(String name) => then((r) => r.typeName(name));
  Future<_HomeScreenPageObject> tapSubmit() => then((r) => r.tapSubmit());
  Future<_HomeScreenPageObject> expectErrorDialog() => then((r) => r.expectErrorDialog());
  Future<_HomeScreenPageObject> closeErrorDialog() => then((r) => r.closeErrorDialog());
}

final class _DetailsScreenPageObject extends PageObject<_DetailsScreenPageObject> {
  const _DetailsScreenPageObject(super.tt);

  Future<_DetailsScreenPageObject> expectWelcomeMessage(String message) async {
    await tt.expectText(_AppKeys.welcomeMessage, message);
    return this;
  }

  Future<_DetailsScreenPageObject> pop() async {
    await tt.pop();
    return this;
  }
}

extension on Future<_DetailsScreenPageObject> {
  Future<_DetailsScreenPageObject> expectWelcomeMessage(String message) => then((r) => r.expectWelcomeMessage(message));
  Future<_DetailsScreenPageObject> pop() => then((r) => r.pop());
}
