import 'package:flutter/material.dart';

extension ProviderExtension on BuildContext {
  T watch<T extends Listenable>() => dependOnInheritedWidgetOfExactType<Provider<T>>()!.notifier!;
  T read<T extends Listenable>() => findAncestorWidgetOfExactType<Provider<T>>()!.notifier!;
}

class Provider<T extends Listenable> extends InheritedNotifier<T> {
  const Provider({
    Key? key,
    T? notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);
}

class Consumer<T extends Listenable> extends StatelessWidget {
  const Consumer({Key? key, required this.builder, this.child}) : super(key: key);

  final Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<T>();
    return builder(context, notifier, child);
  }
}
