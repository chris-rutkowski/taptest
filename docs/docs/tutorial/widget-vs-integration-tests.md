# 🤔 Widget vs Integration tests

Don't let the name fool you! **Widget tests** might sound small, but they can actually test your **entire app** - multiple screens, complete user flows, and complex scenarios. The name is misleading!

Widget tests are incredibly fast as they execute pure Dart code in memory without needing actual devices (Android or iPhone). The tradeoff is they don't have access to device capabilities, resources, and networking. However, with good dependency injection, you can mock this infrastructure and enjoy unparalleled testing speed and reliability.

|                   | Widget Tests ⚡             | Integration Tests 📱       |
| ----------------- | -------------------------- | ------------------------- |
| **Speed**         | 🚀 Hundreds taps per second | 👍 Acceptable              |
| **Environment**   | Simulated canvas           | Real device (or emulator) |
| **Network**       | ❌ Has to be mocked         | ✅ Full access, mockable   |
| **Platform APIs** | ❌ Has to be mocked         | ✅ Full access, mockable   |

> 💡 **Golden Rule:** Focus heavily on Widget tests due to their incredible efficiency - they can test complete user journeys at lightning speed. Use Integration tests sparingly for final confirmation on actual deployment devices.

## 🎯 Our Tutorial Strategy

Due to Widget tests' incredible efficiency, **this tutorial will prioritize Widget tests** extensively. You'll learn to build comprehensive test suites that cover your entire app with blazing-fast execution.

Integration tests will be covered as the final step - perfect for confirming everything works as expected on the actual devices where you'll deploy your app.

**Widget tests** are your primary testing workhorses due to their speed and reliability. **Integration tests** serve as your final safety net, validating everything works perfectly on real devices before shipping to users.

## 📚 Next steps

👉 **[Continue to next page →](./first-test.md)**
