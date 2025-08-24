import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/common/common.dart';
import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/presentation/settings_dialog.dart';
import 'package:task_app/provider/provider.dart';

class Appbar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountNotifierProvider);

    return accountAsync.when(
      data:
          (account) => Container(
            height: 120,

            // color: Common.primaryColor,
            color: account.themeColor,
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return SettingsView();
                        },
                      );
                    },
                    icon: Icon(Icons.more_vert, size: 32),
                  ),
                ),

                //必要なウィジェットがあればここから追加
              ],
            ),
          ),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
