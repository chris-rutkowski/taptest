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
await tt.exists(AppKeys.homeScreen);
await tt.expectText(AppKeys.counterLabel, 'Click counter: 0');
await tt.snapshot('HomeScreen_initial');

await tt.tap(AppKeys.incrementButton);
await tt.expectText(AppKeys.counterLabel, 'Click counter: 1');
await tt.tap(AppKeys.incrementButton, count: 2);
await tt.expectText(AppKeys.counterLabel, 'Click counter: 3');
await tt.snapshot('HomeScreen_counter3');

await tt.type(AppKeys.nameField, 'John Doe');
await tt.tap(AppKeys.submitButton);
await tt.info('🚀 Navigated to Details screen');
await tt.exists(AppKeys.detailsScreen);
await tt.expectText(AppKeys.welcomeMessage, 'Welcome John Doe!');
await tt.snapshot('DetailsScreen_JohnDoe');
```

## 🎬 Record current snapshots

Run the test with `--update-goldens` flag to record the current snapshots:

```bash
flutter test test --update-goldens
```

TapTest creates the matching directory structure containing your reference images:

```
Your project
 ┣ 📂 lib
 ┣ 📂 test
 ┃ ┣ 📂 snapshots
 ┃ ┃ ┣ 📂 my_e2e_widget_test
 ┃ ┃ ┃ ┗ 📂 light
 ┃ ┃ ┃   ┣ 🌇 homescreen_initial.png
 ┃ ┃ ┃   ┣ 🌁 homescreen_counter3.png
 ┃ ┃ ┃   ┗ 🌅 detailsscreen_johndoe.png
 ┃ ┗ 📄 e2e_test.dart
 ┗ 📂 integration_test
```

Subsequent runs (without `--update-goldens`) will compare current UI against prerecorded images **pixel by pixel**. Any visual changes - different fonts, colors, spacing, or layout - will cause the test to fail and show you exactly what changed!

## 🎉 Achievement Unlocked!

You've mastered visual regression testing! Your test suite now combines functional testing with pixel-perfect visual validation. You're protecting against both logic bugs and design regressions.

## 🧑‍💻 Debugging with snapshots

Snapshots help with more than just visual regression - they're fantastic debugging tools! Add them temporarily to see your test's progress step-by-step and quickly identify where issues occur.

## 📚 Next steps

- **[Continue to next page →](./dark-theme)**
- **[Learn more about `snapshot` →](../actions/snapshot)**
