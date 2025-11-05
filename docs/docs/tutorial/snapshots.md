# 📸 Snapshots

Our **functional tests are fantastic** - they catch logic bugs and broken workflows. But what about:
- 🎨 **Design regressions** - Wrong colors, fonts, or spacing
- 📱 **Layout issues** - Misaligned elements or broken responsive design  
- 🌓 **Theme problems** - Dark mode rendering incorrectly
- 🔤 **Typography changes** - Unintended font modifications

Snapshots catch these visual bugs automatically!

> 💡 **Pro Strategy:** Combine **functional assertions** with **visual snapshots** for bulletproof testing. Functional tests catch logic issues, snapshots catch design regressions!

## 🎯 Strategic snapshot placement

Add visual checkpoints at key moments in your user journey:

```dart title="test/e2e_test.dart" {3,9,16}
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
await tester.info('🚀 Navigated to Details screen');
await tester.exists(AppKeys.detailsScreen);
await tester.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
await tester.snapshot('DetailsScreen_JohnDoe');
```

## 🎬 Record current snapshots

Run the test with `--update-goldens` flag to record the current snapshots:

```bash
flutter test test --update-goldens
```

TapTest creates the `goldens` folder with your reference images:

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 goldens
 ┃ ┃ ┣ 🌇 🌁 🌅 snapshots are here
 ┃ ┃ ┗ ☀️ 🌙 in light and dark themes
 ┃ ┗ 📄 e2e_test.dart
 ┗ 📂 integration_test
```

Subsequent runs (without `--update-goldens`) will compare current UI against prerecorded images **pixel by pixel**. Any visual changes - different fonts, colors, spacing, or layout - will cause the test to fail and show you exactly what changed!

## 🎉 Achievement Unlocked!

You've mastered visual regression testing! Your test suite now combines functional testing with pixel-perfect visual validation. You're protecting against both logic bugs and design regressions.

## 📚 Next steps

- **[Continue to next page →](./pop-screen)**
- **[Learn more about `snapshot` →](../actions/snapshot)**
