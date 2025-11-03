---
---

# Advanced Testing Techniques

Now that you've mastered the basics, let's explore TapTest's advanced features for testing complex real-world scenarios. This section covers forms, navigation, HTTP mocking, scrolling, and responsive design testing.

## Testing Forms and Input Fields

Forms are a crucial part of most applications. TapTest provides powerful methods for testing various input types.

### Basic Text Input Testing

```dart
testWidgets('should handle text input correctly', (WidgetTester tester) async {
  await tester.pumpWidget(MyFormApp());
  final tt = TapTester(tester);
  
  // Enter text in a text field
  await tt.enterText('username-field', 'john_doe');
  
  // Verify the text was entered
  await tt.expectText('john_doe');
  
  // Clear and enter new text
  await tt.clearText('username-field');
  await tt.enterText('username-field', 'jane_smith');
  await tt.expectText('jane_smith');
});
```

### Complex Form Testing

```dart
testWidgets('should handle complete form submission', (WidgetTester tester) async {
  await tester.pumpWidget(ContactFormApp());
  final tt = TapTester(tester);
  
  // Fill out a multi-field form
  await tt.enterText('first-name', 'John');
  await tt.enterText('last-name', 'Doe');
  await tt.enterText('email', 'john.doe@example.com');
  await tt.enterText('phone', '+1234567890');
  
  // Select from dropdown
  await tt.tap('country-dropdown');
  await tt.tap('United States');
  
  // Check checkbox
  await tt.tap('newsletter-checkbox');
  
  // Take a snapshot of the filled form
  await tt.snapshot('form_filled');
  
  // Submit form
  await tt.tap('submit-button');
  
  // Verify success message
  await tt.expectText('Form submitted successfully!');
});
```

### Form Validation Testing

```dart
testWidgets('should show validation errors for invalid input', (WidgetTester tester) async {
  await tester.pumpWidget(ContactFormApp());
  final tt = TapTester(tester);
  
  // Try to submit empty form
  await tt.tap('submit-button');
  
  // Verify error messages appear
  await tt.expectText('First name is required');
  await tt.expectText('Email is required');
  
  // Enter invalid email
  await tt.enterText('email', 'invalid-email');
  await tt.tap('submit-button');
  await tt.expectText('Please enter a valid email');
  
  // Take snapshot of error state
  await tt.snapshot('form_validation_errors');
});
```

## Navigation Testing

TapTest excels at testing complex navigation flows, including deep links and route transitions.

### Basic Navigation

```dart
testWidgets('should navigate between screens', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  final tt = TapTester(tester);
  
  // Start on home screen
  await tt.expectText('Welcome to Home');
  
  // Navigate to profile
  await tt.tap('profile-tab');
  await tt.expectText('User Profile');
  
  // Navigate to settings
  await tt.tap('settings-button');
  await tt.expectText('App Settings');
  
  // Use back navigation
  await tt.goBack();
  await tt.expectText('User Profile');
});
```

### Deep Link Testing with GoRouter

```dart
testWidgets('should handle deep links correctly', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  final tt = TapTester(tester);
  
  // Navigate directly to a deep route
  await tt.go('/products/123/reviews');
  
  // Verify we're on the correct screen
  await tt.expectText('Product Reviews');
  await tt.expectText('Product #123');
  
  // Test navigation with parameters
  await tt.go('/user/456/profile');
  await tt.expectText('User Profile: 456');
});
```

### Tab Navigation Testing

```dart
testWidgets('should maintain state across tab navigation', (WidgetTester tester) async {
  await tester.pumpWidget(TabApp());
  final tt = TapTester(tester);
  
  // Enter data in first tab
  await tt.tap('home-tab');
  await tt.enterText('search-field', 'flutter testing');
  
  // Switch to another tab
  await tt.tap('favorites-tab');
  await tt.expectText('Your Favorites');
  
  // Return to first tab - data should persist
  await tt.tap('home-tab');
  await tt.expectText('flutter testing');
});
```

## HTTP Mocking and API Testing

TapTest's HTTP mocking capabilities allow you to test your app's network interactions reliably.

### Basic HTTP Mocking

```dart
testWidgets('should handle API responses correctly', (WidgetTester tester) async {
  await tester.pumpWidget(ApiApp());
  final tt = TapTester(tester);
  
  // Set up HTTP mock
  await tt.mockHttpRequest(
    uri: '/api/users',
    method: HttpMethod.get,
    response: MockHttpResponse(
      statusCode: 200,
      body: '''[
        {"id": 1, "name": "John Doe", "email": "john@example.com"},
        {"id": 2, "name": "Jane Smith", "email": "jane@example.com"}
      ]''',
    ),
  );
  
  // Trigger API call
  await tt.tap('load-users-button');
  
  // Wait for data to load
  await tt.waitForText('John Doe');
  await tt.expectText('Jane Smith');
  
  // Verify UI reflects the data
  await tt.snapshot('users_loaded');
});
```

### Testing Error Scenarios

```dart
testWidgets('should handle API errors gracefully', (WidgetTester tester) async {
  await tester.pumpWidget(ApiApp());
  final tt = TapTester(tester);
  
  // Mock a server error
  await tt.mockHttpRequest(
    uri: '/api/users',
    method: HttpMethod.get,
    response: MockHttpResponse(
      statusCode: 500,
      body: '{"error": "Internal server error"}',
    ),
  );
  
  await tt.tap('load-users-button');
  
  // Verify error handling
  await tt.expectText('Failed to load users');
  await tt.expectVisible('retry-button');
  
  // Test retry functionality
  await tt.mockHttpRequest(
    uri: '/api/users',
    method: HttpMethod.get,
    response: MockHttpResponse(
      statusCode: 200,
      body: '[{"id": 1, "name": "John Doe"}]',
    ),
  );
  
  await tt.tap('retry-button');
  await tt.waitForText('John Doe');
});
```

### Testing File Uploads

```dart
testWidgets('should handle file upload with progress', (WidgetTester tester) async {
  await tester.pumpWidget(UploadApp());
  final tt = TapTester(tester);
  
  // Mock file upload endpoint
  await tt.mockHttpRequest(
    uri: '/api/upload',
    method: HttpMethod.post,
    response: MockHttpResponse(
      statusCode: 200,
      body: '{"success": true, "fileId": "abc123"}',
    ),
  );
  
  // Simulate file selection and upload
  await tt.tap('select-file-button');
  await tt.tap('upload-button');
  
  // Verify upload progress UI
  await tt.expectVisible('upload-progress');
  
  // Wait for completion
  await tt.waitForText('Upload completed successfully');
  await tt.expectText('File ID: abc123');
});
```

## Scrolling and List Testing

Testing scrollable content and lists requires special handling for viewport management.

### Basic Scrolling

```dart
testWidgets('should scroll to reveal content', (WidgetTester tester) async {
  await tester.pumpWidget(LongListApp());
  final tt = TapTester(tester);
  
  // Verify initial visible items
  await tt.expectText('Item 1');
  await tt.expectNotVisible('Item 50'); // Not visible initially
  
  // Scroll down to find an item
  await tt.scrollUntilVisible('Item 50', 'item-list');
  await tt.expectText('Item 50');
  
  // Scroll to top
  await tt.scrollToTop('item-list');
  await tt.expectText('Item 1');
});
```

### Infinite Scroll Testing

```dart
testWidgets('should load more items on infinite scroll', (WidgetTester tester) async {
  await tester.pumpWidget(InfiniteScrollApp());
  final tt = TapTester(tester);
  
  // Mock initial data
  await tt.mockHttpRequest(
    uri: '/api/items?page=1',
    method: HttpMethod.get,
    response: MockHttpResponse(
      statusCode: 200,
      body: '{"items": [{"id": 1, "title": "Item 1"}], "hasMore": true}',
    ),
  );
  
  // Mock next page
  await tt.mockHttpRequest(
    uri: '/api/items?page=2',
    method: HttpMethod.get,
    response: MockHttpResponse(
      statusCode: 200,
      body: '{"items": [{"id": 2, "title": "Item 2"}], "hasMore": false}',
    ),
  );
  
  // Initial load
  await tt.expectText('Item 1');
  
  // Scroll to trigger infinite scroll
  await tt.scrollToBottom('item-list');
  
  // Wait for new items to load
  await tt.waitForText('Item 2');
  await tt.expectNotVisible('loading-indicator');
});
```

## Responsive Design Testing

Test your app across different screen sizes and orientations.

### Screen Size Testing

```dart
testWidgets('should adapt to different screen sizes', (WidgetTester tester) async {
  // Test on mobile size
  await tester.binding.setSurfaceSize(Size(375, 667)); // iPhone SE
  await tester.pumpWidget(ResponsiveApp());
  final tt = TapTester(tester);
  
  await tt.expectVisible('mobile-menu-button');
  await tt.expectNotVisible('desktop-sidebar');
  await tt.snapshot('mobile_layout');
  
  // Test on tablet size
  await tester.binding.setSurfaceSize(Size(768, 1024)); // iPad
  await tester.pumpAndSettle();
  
  await tt.expectVisible('tablet-navigation');
  await tt.snapshot('tablet_layout');
  
  // Test on desktop size
  await tester.binding.setSurfaceSize(Size(1200, 800));
  await tester.pumpAndSettle();
  
  await tt.expectVisible('desktop-sidebar');
  await tt.expectNotVisible('mobile-menu-button');
  await tt.snapshot('desktop_layout');
  
  // Reset to default size
  await tester.binding.setSurfaceSize(null);
});
```

### Orientation Testing

```dart
testWidgets('should handle orientation changes', (WidgetTester tester) async {
  await tester.pumpWidget(OrientationApp());
  final tt = TapTester(tester);
  
  // Test portrait mode
  await tester.binding.setSurfaceSize(Size(375, 667));
  await tester.pumpAndSettle();
  
  await tt.expectVisible('portrait-layout');
  await tt.snapshot('portrait_mode');
  
  // Test landscape mode
  await tester.binding.setSurfaceSize(Size(667, 375));
  await tester.pumpAndSettle();
  
  await tt.expectVisible('landscape-layout');
  await tt.snapshot('landscape_mode');
});
```

## Advanced Waiting Strategies

Handle complex async scenarios with TapTest's waiting methods.

### Waiting for Network Requests

```dart
testWidgets('should wait for multiple network requests', (WidgetTester tester) async {
  await tester.pumpWidget(ComplexApp());
  final tt = TapTester(tester);
  
  // Mock multiple endpoints
  await tt.mockHttpRequest(uri: '/api/user', method: HttpMethod.get, /* ... */);
  await tt.mockHttpRequest(uri: '/api/settings', method: HttpMethod.get, /* ... */);
  
  await tt.tap('refresh-button');
  
  // Wait for all requests to complete
  await tt.waitForCondition(
    () => tt.isVisible('user-data') && tt.isVisible('settings-data'),
    timeout: Duration(seconds: 10),
  );
  
  await tt.snapshot('all_data_loaded');
});
```

### Waiting for Animations

```dart
testWidgets('should wait for animations to complete', (WidgetTester tester) async {
  await tester.pumpWidget(AnimatedApp());
  final tt = TapTester(tester);
  
  await tt.tap('animate-button');
  
  // Wait for animation to complete
  await tt.waitForAnimationToComplete();
  
  await tt.snapshot('animation_completed');
});
```

## Performance Testing

Test your app's performance characteristics.

### Frame Rate Testing

```dart
testWidgets('should maintain smooth frame rate during heavy operations', (WidgetTester tester) async {
  await tester.pumpWidget(PerformanceApp());
  final tt = TapTester(tester);
  
  // Start performance monitoring
  await tt.startPerformanceMonitoring();
  
  // Perform heavy operations
  await tt.tap('heavy-computation-button');
  await tt.waitForText('Computation complete');
  
  // Check performance metrics
  final metrics = await tt.getPerformanceMetrics();
  expect(metrics.droppedFrames, lessThan(5));
  expect(metrics.averageFrameTime, lessThan(Duration(milliseconds: 16)));
});
```

## What You've Learned

You now have advanced TapTest skills for testing:

- ✅ Complex forms with validation
- ✅ Multi-screen navigation flows
- ✅ HTTP requests and error handling
- ✅ Scrollable content and infinite scroll
- ✅ Responsive designs across screen sizes
- ✅ Advanced waiting strategies
- ✅ Performance monitoring

These techniques will help you test even the most complex Flutter applications with confidence.

---

## Where to Go Next

Ready to customize TapTest for your specific needs? The next section covers configuration options, custom loggers, and advanced setup techniques.

👉 **[Configuration and Customization →](./configuration)**