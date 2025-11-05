# 🌒 Dark theme

Testing **light theme only** leaves your app vulnerable to dark mode bugs! Let's test **both themes** with TapTest. Additionally, we'll clean up those debug banners for professional-looking snapshots!

## 🔧 Runtime parameters

We need to provide our app with the ability to be customised at runtime by TapTest. Remember? This is why we added the `taptest_runtime` dependency earlier.

Update the app as follows:

```dart title="lib/main.dart" {1,5,9,16,17}
import 'package:taptest_runtime/taptest_runtime.dart';
// ... other imports

final class MyApp extends StatelessWidget {
  final RuntimeParams? params; // 🎯 Provided by TapTest during testing
  
  const MyApp({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      themeMode: params?.themeMode.value, // 🌓 Theme overwrite
      debugShowCheckedModeBanner: params == null, // 🎨 Hide debug ribbon
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
```

And actually pass the `params`:

```dart title="test/e2e_test.dart" {3}
final config = Config(
  builder: (params) {
    return MyApp(params: params); // 🎯 Pass runtime params
  },
);
```

## 🔄 Variants

Now we will introduce **variants** to our tests. Variants repeat the same test steps under different conditions, such as light and dark `ThemeMode`.

```dart title="test/e2e_test.dart" {2}
final config = Config(
  variants: Variant.lightAndDarkVariants,
  builder: (params) {
    return MyApp(params: params); // 🎯 Pass runtime params
  },
);
```

> 💡 `Variant.lightAndDarkVariants` is a convenience method provided by TapTest that creates two `Variant` instances. You could also create variants for different locales, screen sizes, etc.
> 
## 🎬 (Re)-record snapshots

Run the test with the `--update-goldens` flag to update snapshots for both variants - this removes the debug ribbon and records the dark theme:

```bash
flutter test test --update-goldens
```

Once complete, your project structure will look like this. Notice that each variant gets its own folder - `light` and `dark` are the variant names.

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 snapshots
 ┃ ┃ ┣ 📂 my_e2e_widget_test
 ┃ ┃ ┃ ┗ 📂 light
 ┃ ┃ ┃ ┃ ┗ 🌇 🌁 🌅 updated light theme snapshots
 ┃ ┃ ┃ ┗ 📂 dark 👈 here
 ┃ ┃ ┃   ┣ 🌇 homescreen_initial.png
 ┃ ┃ ┃   ┣ 🌁 homescreen_counter3.png
 ┃ ┃ ┃   ┗ 🌅 detailsscreen_johndoe.png
 ┃ ┗ 📄 e2e_test.dart
 ┗ 📂 integration_test
```

## 🎉 Achievement Unlocked!

You've mastered **multi-theme testing with variants**! Your test suite now validates both light and dark themes automatically, generates clean snapshots without debug banners, uses runtime parameters for dynamic app configuration, and scales to test multiple scenarios with minimal code.

## 📚 Next steps

- **[Continue to next page →](../tutorial-extras/invisible-testing)**  
- **[Learn about `changeTheme` →](../actions/change-theme)**

