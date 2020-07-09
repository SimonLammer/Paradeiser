import 'dart:async';

import 'package:flutter/material.dart';

class StreamListenableAdapter<T> extends StatefulWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext, ValueNotifier<T> notifier) builder;
  final T initialData;

  StreamListenableAdapter({
    @required this.stream,
    @required this.builder,
    this.initialData,
  });

  @override
  State<StatefulWidget> createState() => _StreamListenableAdapterState<T>();
}

class _StreamListenableAdapterState<T> extends State<StreamListenableAdapter<T>> {
  ValueNotifier<T> notifier;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.initialData);
    streamSubscription = widget.stream.listen((T data) {
      notifier.value = data; // TODO: is not notifying on equal value a problem?
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, notifier);
}
