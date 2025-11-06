---
sidebar_position: 1
---

# Welcome to TapTest Documentation

**TapTest** is a powerful Flutter testing framework designed to make UI testing intuitive, reliable, and maintainable. Whether you're testing simple widgets or complex application flows, TapTest provides the tools you need to ensure your Flutter apps work perfectly.

## 🚀 Quick Start

Ready to start testing? Jump right into our comprehensive tutorial:

👉 **[Start the Tutorial →](./tutorial/getting-started)**

The tutorial will guide you through:
- Installing and setting up TapTest
- Writing your first test
- Advanced testing techniques
- Configuration and customization
- Best practices and troubleshooting

## 📚 What You'll Learn

Our tutorial covers everything you need to become proficient with TapTest:

### **1. [Getting Started](./tutorial/getting-started)**
- What TapTest is and why you should use it
- Installation and project setup
- Your first look at TapTest syntax

### **2. [Writing Your First Test](./tutorial/first-test)**
- Basic test structure and patterns
- Core TapTest actions and assertions
- Snapshot testing fundamentals

### **3. [Advanced Testing Techniques](./tutorial/advanced-techniques)**
- Form testing and validation
- Navigation and routing tests
- HTTP mocking and API testing
- Scrolling and responsive design

### **4. [Configuration and Customization](./tutorial/configuration)**
- Global configuration options
- Custom loggers and analytics
- Environment-specific setups
- Performance optimization

### **5. [Best Practices and Next Steps](./tutorial/best-practices)**
- Testing patterns and organization
- Troubleshooting common issues
- CI/CD integration
- Advanced topics and resources

## 🎯 Key Features

TapTest provides everything you need for comprehensive Flutter UI testing:

- **🎪 Intuitive API** - Tests read like natural language
- **📸 Visual Testing** - Built-in snapshot testing for regression detection
- **🌐 HTTP Mocking** - Reliable API testing with comprehensive mocking
- **📱 Multi-Device** - Test across different screen sizes and platforms
- **⚡ Performance** - Optimized for fast, reliable test execution
- **🔧 Configurable** - Extensive customization options
- **🤝 Integration** - Works seamlessly with existing Flutter testing tools

## 🛠 Quick Example

Here's a taste of what TapTest looks like:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:taptest/taptest.dart';
import 'package:your_app/main.dart' as app;

void main() {
  testWidgets('User can complete shopping flow', (WidgetTester tester) async {
    await tt.pumpWidget(app.MyApp());
    final tt = TapTester(tester);
    
    // Navigate to product
    await tt.tap('Shop Now');
    await tt.tap('Add to Cart');
    
    // Complete checkout
    await tt.tap('Checkout');
    await tt.enterText('email', 'user@example.com');
    await tt.tap('Place Order');
    
    // Verify success
    await tt.expectText('Order confirmed!');
    await tt.snapshot('order_success');
  });
}
```

## 📖 Documentation Structure

- **Tutorial** - Step-by-step learning path (you are here!)
- **Actions Reference** - Detailed documentation of all TapTest actions
- **API Reference** - Complete technical documentation
- **Examples** - Real-world testing scenarios

## 🤝 Community and Support

- **GitHub Repository**: [chris-rutkowski/taptest](https://github.com/chris-rutkowski/taptest)
- **Issues and Bugs**: [GitHub Issues](https://github.com/chris-rutkowski/taptest/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chris-rutkowski/taptest/discussions)

---

## Ready to Get Started?

Whether you're new to Flutter testing or looking to improve your testing workflow, our tutorial will get you up and running quickly.

👉 **[Begin Your TapTest Journey →](./tutorial/getting-started)**
