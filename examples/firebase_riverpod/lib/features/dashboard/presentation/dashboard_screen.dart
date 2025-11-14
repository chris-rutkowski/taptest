import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data_domain/auth_repository_provider.dart';
import '../../memos/data_domain/memo.dart';
import '../../memos/data_domain/memos_list_provider.dart';
import '../../memos/data_domain/memos_repository_provider.dart';
import 'dashboard_keys.dart';

final class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

final class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final newMemoController = TextEditingController();

  @override
  void dispose() {
    newMemoController.dispose();
    super.dispose();
  }

  void onLogoutPressed() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.logout();

    // No need for any navigator/router call
    // Router is responsible to redirect user out of member area
  }

  void onDeleteMemoPressed(Memo memo) {
    ref.read(memosRepositoryProvider).delete(memo);
  }

  void onNewMemoSubmitted() async {
    final newMemo = newMemoController.text.trim();
    if (newMemo.isEmpty) {
      return;
    }

    newMemoController.clear();

    await ref.read(memosRepositoryProvider).add(newMemo);
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.read(authRepositoryProvider);
    final memosAsync = ref.watch(memosListProvider);

    return Scaffold(
      key: DashboardKeys.screen,
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Welcome'),
            subtitle: Text(
              authRepository.user?.email ?? '',
              key: DashboardKeys.email,
            ),
            trailing: IconButton(
              key: DashboardKeys.logoutButton,
              onPressed: () => onLogoutPressed(),
              icon: const Icon(Icons.logout),
            ),
          ),
          ListTile(
            title: TextField(
              key: DashboardKeys.newMemoField,
              controller: newMemoController,
              decoration: const InputDecoration(
                labelText: 'New Memo',
              ),
              onSubmitted: (_) => onNewMemoSubmitted(),
            ),
          ),
          ...memosAsync.when(
            data: (memos) {
              if (memos.isEmpty) {
                return [
                  const ListTile(
                    key: DashboardKeys.noMemosTile,
                    title: Text('No memos yet.'),
                  ),
                ];
              }

              return memos
                  .mapIndexed(
                    (index, memo) => ListTile(
                      key: DashboardKeys.memoTile(index),
                      title: Text(memo.text, key: DashboardKeys.memoText),
                      trailing: IconButton(
                        key: DashboardKeys.deleteMemoButton,
                        onPressed: () => onDeleteMemoPressed(memo),
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  )
                  .toList();
            },
            loading: () => [],
            error: (_, _) => [],
          ),
        ],
      ),
    );
  }
}
