// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todos)
const todosProvider = TodosProvider._();

final class TodosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TodoDto>>,
          List<TodoDto>,
          FutureOr<List<TodoDto>>
        >
    with $FutureModifier<List<TodoDto>>, $FutureProvider<List<TodoDto>> {
  const TodosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todosHash();

  @$internal
  @override
  $FutureProviderElement<List<TodoDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TodoDto>> create(Ref ref) {
    return todos(ref);
  }
}

String _$todosHash() => r'9197e0df1c1d12496c915096e98552177767f913';
