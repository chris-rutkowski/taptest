cd taptest
flutter test --coverage test
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
