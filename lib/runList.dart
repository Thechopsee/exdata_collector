import 'package:flutter/material.dart';

import 'Models/Run.dart';

class RunList extends StatelessWidget {
  final List<Run> items;

  const RunList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run List'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index].rid.toString()+" "+items[index].hit.toString()+""+items[index].directionHit.toString()),
          );
        },
      ),
    );
  }
}
