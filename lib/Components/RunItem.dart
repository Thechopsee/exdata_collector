import 'package:exdata_collector/Services/LocalSaver.dart';
import 'package:flutter/material.dart';
import '../Models/Boat.dart';
import '../Models/Run.dart';
class RunItem extends StatelessWidget {
  final Run run;

  const RunItem({Key? key, required this.run}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Boat>(
      future: LocalSaver.loadBoatData(run.boatID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Chyba při načítání lodi: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('Loď nenalezena');
        }

        final boat = snapshot.data!;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Run ID: ${run.rid}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.directions_boat, size: 16),
                    const SizedBox(width: 4),
                    Text('Boat: ${boat.name}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.track_changes, size: 16),
                    const SizedBox(width: 4),
                    Text('Scope To: ${run.scopeTo}'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward, size: 16),
                    const SizedBox(width: 4),
                    Text('Direction To: ${run.directionTo ?? '-'}'),
                    const SizedBox(width: 20),
                    Icon(Icons.check, size: 16, color: run.hit > 0 ? Colors.green : Colors.red),
                    const SizedBox(width: 4),
                    Text('Hit: ${run.hit}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.arrow_right_alt, size: 16),
                    const SizedBox(width: 4),
                    Text('Direction Hit: ${run.directionHit ?? '-'}'),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Intended Gate Part: ${run.intentedPartOfGate ?? '-'}'),
                const SizedBox(height: 6),
                Text('Date: ${run.dateTime.toLocal()}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
