import 'package:flutter/material.dart';
import 'timer-fragment.dart';
import 'todo_list-fragment.dart';

class MyApp extends StatelessWidget {
  final mainFragments = {
    '/': TimerFragment(),
    '/todo_list': TodoListFragment()
  };

  @override
  Widget build(BuildContext context) {
    final fragmentNavigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      title: 'Paradeiser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: fragmentNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        builder: (_) => mainFragments[settings.name],
        settings: settings,
      ),
      builder: (BuildContext context, Widget fragment) => Scaffold(
        appBar: AppBar(
          title: Text("Paradeiser"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text("Paradeiser"),
              ),
              ListTile(
                title: Text("Pomodoro timer"),
                onTap: () {
                  fragmentNavigatorKey.currentState.popUntil((route) => 
                    !fragmentNavigatorKey.currentState.canPop());
                },
              ),
              ListTile(
                title: Text("Todo list"),
                onTap: () {
                  fragmentNavigatorKey.currentState.popAndPushNamed('/todo_list');
                }
              )
            ],
          ),
        ),
        body: fragment,
      ),
    );
  }
}
