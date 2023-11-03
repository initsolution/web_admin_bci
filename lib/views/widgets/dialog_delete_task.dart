import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';

class DialogDeleteTask extends ConsumerWidget {
  final Task task;
  const DialogDeleteTask({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              ref.read(taskNotifierProvider.notifier).deleteTask(task.id!);
              Navigator.pop(context);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.green),
            ))
      ],
      title: Text('Hapus Task ${task.site!.name!}'),
      content: Text(
          'Yakin menghapus task ${task.site!.name!}? Akan menghapus semua'),
    );
  }
}
