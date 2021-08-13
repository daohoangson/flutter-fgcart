import 'package:flutter/material.dart';

import 'add_outfit.dart';

class TestCases extends StatelessWidget {
  const TestCases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test cases'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Add outfit'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddOutfit())),
          ),
        ],
      ),
    );
  }
}
