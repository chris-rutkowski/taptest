/// A key or a list of keys used to locate a widget within the widget tree.
///
/// When a list is provided, it is treated as a hierarchy of keys, each subsequent
/// key is searched within the widget found by the previous one.
///
/// Example: `[MyScreen, ListKey, CellKey[0], TitleKey]`
/// locates title widget inside cell at index 0, which is inside a list widget on `MyScreen`.
typedef TapKey = dynamic;
