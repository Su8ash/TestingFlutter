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
                onPressed: () => context.push('/onboarding'),
                child: const Text('Go to the Onboarding screen'),
              ),

              ElevatedButton(
                onPressed: () => context.push('/bookmark'),
                child: const Text('Go to the Bookmark screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/cuisine_detail'),
                child: const Text('Go to the Cuisine Detail screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/notification'),
                child: const Text('Go to the Notification screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/discover'),
                child: const Text('Go to the Discover screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/details'),
                child: const Text('Go to the Details screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/splash'),
                child: const Text('Go to the Splash screen'),
              ),
              ElevatedButton(
                onPressed: () => context.push('/login'),
                child: const Text('Go to the Login screen'),
              ),
              // ElevatedButton(
              //   onPressed: () => context.push('/country'),
              //   child: const Text('Go to the Country screen'),
              // ),
              // ElevatedButton(
              //   onPressed: () => context.push('/cooking_level'),
              //   child: const Text('Go to the Cooking Level screen'),
              // ),
              // ElevatedButton(
              //   onPressed: () => context.push('/cuisines_pref'),
              //   child: const Text('Go to the Cuisine Pref screen'),
              // ),
              // ElevatedButton(
              //   onPressed: () => context.push('/dietary_pref'),
              //   child: const Text('Go to the Dietary Pref screen'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
