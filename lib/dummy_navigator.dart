import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DummyNavigatorScreen extends StatelessWidget {
  const DummyNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dummy Navigator Screen')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => context.push('/'),
                child: const Text('Go to the Home screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/reoderableListview'),
                child: const Text('Reorder List'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/reorderableListWithSqflite'),
                child: const Text('Reorderable List with SQflite'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/geoLocator'),
                child: const Text('Geo Locator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
