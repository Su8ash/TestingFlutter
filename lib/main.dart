import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_flutter/dummy_navigator.dart';
import 'package:test_flutter/pages/old/geo_locator.dart';
import 'package:test_flutter/pages/old/reoderable_list_with_namelist.dart';
import 'package:test_flutter/pages/old/reorder_list.dart';
import 'package:test_flutter/pages/old/reorderable_list_with_sqflite.dart';
import 'package:test_flutter/pages/old/reoderable_list.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DummyNavigatorScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'reoderableListview',
          builder: (BuildContext context, GoRouterState state) {
            return const ReorderableListExample();
          },
        ),
        GoRoute(
          path: 'reoderableWithNameList',
          builder: (BuildContext context, GoRouterState state) {
            return const ReorderableWithNameList();
          },
        ),
        GoRoute(
          path: 'reorderableListWithSqflite',
          builder: (BuildContext context, GoRouterState state) {
            return ReorderableListWithSqflite();
          },
        ),
        GoRoute(
          path: 'geoLocator',
          builder: (BuildContext context, GoRouterState state) {
            return const GeoLocator();
          },
        ),
        GoRoute(
          path: 'MMVReoderableList',
          builder: (BuildContext context, GoRouterState state) {
            return const MyReorderableList();
          },
        ),
        GoRoute(
          path: 'MMVReoderableListWithSQLLite',
          builder: (BuildContext context, GoRouterState state) {
            return const GeoLocator();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: _router,
    );
  }
}
