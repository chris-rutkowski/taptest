import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/todos_provider.dart';
import 'http_keys.dart';

final class HttpScreen extends ConsumerWidget {
  const HttpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      key: HttpKeys.screen,
      appBar: AppBar(
        title: const Text('HTTP Screen'),
      ),
      body: todos.when(
        data: (todos) {
          return ListView.builder(
            key: HttpKeys.list,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                key: HttpKeys.cell(index),
                title: Text(todo.text),
                subtitle: Text(todo.completed ? 'Completed' : 'Incomplete'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
