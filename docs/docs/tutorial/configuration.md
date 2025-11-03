---
---

# Configuration and Customization

TapTest offers extensive configuration options to tailor the testing experience to your project's specific needs. This section covers global configuration, custom loggers, snapshot settings, and advanced customization techniques.

## Global Configuration

### Basic Configuration Setup

Create a configuration file for your TapTest setup:

```dart
// test/test_config.dart
import 'package:taptest/taptest.dart';

class TestConfig {
  static Config get defaultConfig => Config(
    // Timeout settings
    defaultTimeout: Duration(seconds: 30),
    tapTimeout: Duration(seconds: 5),
    
    // Snapshot configuration
    snapshotConfig: SnapshotConfig(
      threshold: 0.1, // 10% pixel difference tolerance
      devicePixelRatio: 2.0,
      customFonts: [
        CustomFont(
          name: 'Roboto',
          path: 'fonts/Roboto-Regular.ttf',
        ),
      ],
    ),
    
    // Logging configuration
    logger: ConsoleTapTesterLogger(
      logLevel: TapTesterLogType.info,
      showTimestamps: true,
      colorOutput: true,
    ),
    
    // Synchronization settings
    syncType: SyncType.waitForAnimations,
    
    // Custom finders
    customFinders: {
      'semantic-label': (String label) => find.bySemanticsLabel(label),
      'test-id': (String id) => find.byKey(Key('test-$id')),
    },
  );
}
```

### Using Configuration in Tests

```dart
// test/integration/configured_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';
import '../test_config.dart';

void main() {
  group('Configured Tests', () {
    late TapTester tt;
    
    setUp(() {
      // Apply global configuration
      TapTester.setGlobalConfig(TestConfig.defaultConfig);
    });
    
    testWidgets('should use custom configuration', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      tt = TapTester(tester);
      
      // Configuration is automatically applied
      await tt.tap('test-id:submit-button'); // Uses custom finder
      await tt.snapshot('configured_test'); // Uses custom snapshot settings
    });
  });
}
```

## Snapshot Configuration

### Advanced Snapshot Settings

```dart
// Custom snapshot configuration for different scenarios
class SnapshotConfigs {
  static SnapshotConfig get highPrecision => SnapshotConfig(
    threshold: 0.01, // 1% tolerance for critical UI components
    devicePixelRatio: 3.0,
    matchAlgorithm: MatchAlgorithm.pixelPerfect,
    ignoreRegions: [
      Rect.fromLTWH(0, 0, 50, 50), // Ignore dynamic timestamp area
    ],
  );
  
  static SnapshotConfig get lowPrecision => SnapshotConfig(
    threshold: 0.2, // 20% tolerance for less critical tests
    devicePixelRatio: 1.0,
    ignoreColors: true, // Only compare structure, not colors
  );
  
  static SnapshotConfig get crossPlatform => SnapshotConfig(
    threshold: 0.15,
    devicePixelRatio: 2.0,
    customFonts: [
      CustomFont(name: 'Inter', path: 'fonts/Inter-Regular.ttf'),
      CustomFont(name: 'Inter-Bold', path: 'fonts/Inter-Bold.ttf'),
    ],
    renderShadows: false, // Consistent across platforms
  );
}
```

### Using Different Snapshot Configs

```dart
testWidgets('should use appropriate snapshot configuration', (WidgetTester tester) async {
  await tester.pumpWidget(CriticalUIComponent());
  final tt = TapTester(tester);
  
  // Use high precision for critical components
  await tt.snapshot('critical_component', 
                   config: SnapshotConfigs.highPrecision);
  
  // Use low precision for less important areas
  await tt.snapshot('background_element', 
                   config: SnapshotConfigs.lowPrecision);
});
```

## Custom Loggers

### Creating a Custom Logger

```dart
// lib/test_utils/custom_logger.dart
import 'package:taptest/taptest.dart';

class CustomTapTesterLogger implements TapTesterLogger {
  final List<String> _logs = [];
  final bool saveToFile;
  final String logFilePath;
  
  CustomTapTesterLogger({
    this.saveToFile = false,
    this.logFilePath = 'test_logs.txt',
  });
  
  @override
  void log(TapTesterLogType type, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final formattedMessage = '[$timestamp] ${type.name.toUpperCase()}: $message';
    
    // Console output with colors
    final colorCode = _getColorCode(type);
    print('$colorCode$formattedMessage\u001b[0m');
    
    // Store in memory
    _logs.add(formattedMessage);
    
    // Save to file if enabled
    if (saveToFile) {
      _saveToFile(formattedMessage);
    }
    
    // Include error details
    if (error != null) {
      final errorMessage = 'Error: $error';
      print('\u001b[31m$errorMessage\u001b[0m');
      _logs.add(errorMessage);
      
      if (saveToFile) _saveToFile(errorMessage);
    }
    
    if (stackTrace != null) {
      final stackMessage = 'Stack trace:\n$stackTrace';
      print('\u001b[90m$stackMessage\u001b[0m');
      _logs.add(stackMessage);
      
      if (saveToFile) _saveToFile(stackMessage);
    }
  }
  
  String _getColorCode(TapTesterLogType type) {
    switch (type) {
      case TapTesterLogType.debug:
        return '\u001b[90m'; // Gray
      case TapTesterLogType.info:
        return '\u001b[36m'; // Cyan
      case TapTesterLogType.warning:
        return '\u001b[33m'; // Yellow
      case TapTesterLogType.error:
        return '\u001b[31m'; // Red
    }
  }
  
  void _saveToFile(String message) {
    // Implementation for saving to file
    // This could write to a file system or send to external logging service
  }
  
  List<String> get logs => List.unmodifiable(_logs);
  
  void clearLogs() => _logs.clear();
  
  List<String> getLogsByType(TapTesterLogType type) {
    return _logs.where((log) => log.contains(type.name.toUpperCase())).toList();
  }
}
```

### Analytics Logger

```dart
class AnalyticsTapTesterLogger implements TapTesterLogger {
  final Map<String, int> _actionCounts = {};
  final List<Duration> _testDurations = [];
  DateTime? _testStartTime;
  
  @override
  void log(TapTesterLogType type, String message, [Object? error, StackTrace? stackTrace]) {
    // Track test start/end
    if (message.contains('Starting test:')) {
      _testStartTime = DateTime.now();
    } else if (message.contains('Test completed:')) {
      if (_testStartTime != null) {
        _testDurations.add(DateTime.now().difference(_testStartTime!));
      }
    }
    
    // Track action usage
    if (message.startsWith('Action:')) {
      final action = message.split(':')[1].trim();
      _actionCounts[action] = (_actionCounts[action] ?? 0) + 1;
    }
    
    // Standard console output
    print('[$type] $message');
  }
  
  void printAnalytics() {
    print('\n=== Test Analytics ===');
    print('Most used actions:');
    final sortedActions = _actionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedActions.take(5)) {
      print('  ${entry.key}: ${entry.value} times');
    }
    
    if (_testDurations.isNotEmpty) {
      final avgDuration = _testDurations.reduce((a, b) => a + b) / _testDurations.length;
      print('Average test duration: ${avgDuration.inMilliseconds}ms');
      print('Slowest test: ${_testDurations.reduce((a, b) => a > b ? a : b).inMilliseconds}ms');
    }
  }
}
```

## Environment-Specific Configuration

### Development vs CI Configuration

```dart
// test/configs/environment_config.dart
class EnvironmentConfig {
  static Config getConfig() {
    if (_isRunningInCI()) {
      return _getCIConfig();
    } else {
      return _getDevelopmentConfig();
    }
  }
  
  static bool _isRunningInCI() {
    return Platform.environment['CI'] == 'true' ||
           Platform.environment['GITHUB_ACTIONS'] == 'true';
  }
  
  static Config _getCIConfig() {
    return Config(
      defaultTimeout: Duration(seconds: 60), // Longer timeouts for CI
      snapshotConfig: SnapshotConfig(
        threshold: 0.05, // Stricter in CI
        devicePixelRatio: 2.0,
        renderShadows: false, // Consistent across CI environments
      ),
      logger: CustomTapTesterLogger(
        saveToFile: true,
        logFilePath: 'ci_test_logs.txt',
      ),
      syncType: SyncType.waitForAnimations,
      retryFailedTests: true,
      maxRetries: 3,
    );
  }
  
  static Config _getDevelopmentConfig() {
    return Config(
      defaultTimeout: Duration(seconds: 30),
      snapshotConfig: SnapshotConfig(
        threshold: 0.1, // More lenient for development
        devicePixelRatio: 2.0,
      ),
      logger: ConsoleTapTesterLogger(
        logLevel: TapTesterLogType.debug,
        colorOutput: true,
      ),
      syncType: SyncType.automatic,
    );
  }
}
```

## Custom Actions and Extensions

### Creating Custom Actions

```dart
// lib/test_utils/custom_actions.dart
extension CustomTapTesterActions on TapTester {
  /// Custom action for complex login flow
  Future<void> performLogin(String username, String password) async {
    await enterText('username-field', username);
    await enterText('password-field', password);
    await tap('login-button');
    await waitForText('Welcome');
    
    // Log the custom action
    logger.log(TapTesterLogType.info, 'Custom action: performLogin completed');
  }
  
  /// Custom action for shopping cart operations
  Future<void> addToCartAndVerify(String productId, {int quantity = 1}) async {
    await tap('product-$productId');
    
    if (quantity > 1) {
      for (int i = 1; i < quantity; i++) {
        await tap('increase-quantity');
      }
    }
    
    await tap('add-to-cart');
    await expectText('Added to cart');
    
    // Verify cart badge updates
    await expectText(quantity.toString(), finder: find.byKey(Key('cart-badge')));
  }
  
  /// Custom action for form validation testing
  Future<Map<String, bool>> validateFormFields(Map<String, String> fieldData) async {
    final results = <String, bool>{};
    
    for (final entry in fieldData.entries) {
      await clearText(entry.key);
      await enterText(entry.key, entry.value);
      
      // Check if validation error appears
      await tap('validate-button');
      final hasError = await isVisible('${entry.key}-error');
      results[entry.key] = !hasError;
    }
    
    return results;
  }
}
```

### Using Custom Actions

```dart
testWidgets('should use custom actions', (WidgetTester tester) async {
  await tester.pumpWidget(ECommerceApp());
  final tt = TapTester(tester);
  
  // Use custom login action
  await tt.performLogin('test@example.com', 'password123');
  
  // Use custom shopping cart action
  await tt.addToCartAndVerify('product-123', quantity: 2);
  
  // Use custom form validation action
  final validationResults = await tt.validateFormFields({
    'email': 'invalid-email',
    'phone': '123', // Too short
    'name': 'Valid Name',
  });
  
  expect(validationResults['email'], false);
  expect(validationResults['phone'], false);
  expect(validationResults['name'], true);
});
```

## Device and Platform Configuration

### Multi-Device Testing

```dart
class DeviceConfigs {
  static final Map<String, DeviceConfig> devices = {
    'iphone_se': DeviceConfig(
      size: Size(375, 667),
      pixelRatio: 2.0,
      platform: TargetPlatform.iOS,
    ),
    'iphone_pro': DeviceConfig(
      size: Size(390, 844),
      pixelRatio: 3.0,
      platform: TargetPlatform.iOS,
    ),
    'pixel_4': DeviceConfig(
      size: Size(393, 851),
      pixelRatio: 2.75,
      platform: TargetPlatform.android,
    ),
    'ipad': DeviceConfig(
      size: Size(768, 1024),
      pixelRatio: 2.0,
      platform: TargetPlatform.iOS,
    ),
  };
  
  static Future<void> testOnAllDevices(
    WidgetTester tester,
    Widget app,
    Future<void> Function(TapTester) testFunction,
  ) async {
    for (final entry in devices.entries) {
      final deviceName = entry.key;
      final config = entry.value;
      
      debugPrint('Testing on $deviceName');
      
      // Configure device
      await tester.binding.setSurfaceSize(config.size);
      tester.binding.window.devicePixelRatioTestValue = config.pixelRatio;
      
      await tester.pumpWidget(app);
      final tt = TapTester(tester);
      
      // Run the test
      await testFunction(tt);
      
      // Take device-specific snapshot
      await tt.snapshot('test_on_$deviceName');
    }
    
    // Reset
    await tester.binding.setSurfaceSize(null);
    tester.binding.window.clearDevicePixelRatioTestValue();
  }
}
```

## Performance Configuration

### Memory and Performance Monitoring

```dart
class PerformanceConfig {
  static Config get optimizedConfig => Config(
    // Reduced timeouts for faster test execution
    defaultTimeout: Duration(seconds: 15),
    tapTimeout: Duration(seconds: 3),
    
    // Optimized snapshot settings
    snapshotConfig: SnapshotConfig(
      threshold: 0.1,
      devicePixelRatio: 1.0, // Lower resolution for faster comparison
      skipAnimations: true,
    ),
    
    // Performance monitoring
    enablePerformanceMonitoring: true,
    performanceThresholds: PerformanceThresholds(
      maxFrameTime: Duration(milliseconds: 16),
      maxMemoryUsage: 100 * 1024 * 1024, // 100MB
      maxCPUUsage: 0.8, // 80%
    ),
    
    // Parallel execution settings
    enableParallelExecution: true,
    maxConcurrentTests: 4,
  );
}
```

## Configuration Best Practices

### Project Structure for Configuration

```
test/
├── configs/
│   ├── base_config.dart          # Base configuration
│   ├── development_config.dart   # Development overrides
│   ├── ci_config.dart           # CI/CD overrides
│   └── device_configs.dart      # Device-specific configs
├── utils/
│   ├── custom_actions.dart      # Custom test actions
│   ├── custom_loggers.dart      # Custom loggers
│   └── test_helpers.dart        # Shared test utilities
└── integration/
    ├── setup/
    │   └── test_setup.dart      # Test setup and teardown
    └── ... (test files)
```

### Configuration Loading

```dart
// test/configs/config_loader.dart
class ConfigLoader {
  static Config loadConfig() {
    final environment = Platform.environment['TEST_ENV'] ?? 'development';
    
    switch (environment) {
      case 'ci':
        return CIConfig.config;
      case 'staging':
        return StagingConfig.config;
      case 'production':
        return ProductionConfig.config;
      default:
        return DevelopmentConfig.config;
    }
  }
  
  static void setupGlobalConfig() {
    final config = loadConfig();
    TapTester.setGlobalConfig(config);
    
    // Additional setup based on environment
    if (Platform.environment['TEST_ENV'] == 'ci') {
      _setupCIEnvironment();
    }
  }
  
  static void _setupCIEnvironment() {
    // CI-specific setup like clearing caches, setting up test databases, etc.
  }
}
```

## What You've Learned

You now know how to:

- ✅ Create comprehensive global configurations
- ✅ Customize snapshot settings for different scenarios
- ✅ Implement custom loggers with analytics
- ✅ Set up environment-specific configurations
- ✅ Create custom actions and extensions
- ✅ Configure multi-device testing
- ✅ Optimize performance settings
- ✅ Structure configuration files effectively

These configuration techniques will help you create a robust, scalable testing setup that grows with your project.

---

## Where to Go Next

You're almost at the end of our TapTest journey! The final section covers testing best practices, troubleshooting common issues, and resources for continued learning.

👉 **[Best Practices and Next Steps →](./best-practices)**