# Change theme mode

Sets `RuntimeParams.themeMode`. The value must be in `config.themeModes`.

```dart
import 'package:material_ui/material_ui.dart';

await tt.changeThemeMode(ThemeMode.dark);
```

The app must listen to `params.themeMode` (see [Config](../config.md)).
