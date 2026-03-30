import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:flutter/material.dart';
import 'package:exdata_collector/l10n/app_localizations.dart';
import '../Models/Boat.dart';
import '../Models/Run.dart';
class RunItem extends StatelessWidget {
  final Run run;

  const RunItem({Key? key, required this.run}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<Boat>(
      future: LocalDataManager.shared.load<Boat>(Boat,run.boatID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('${l10n.errorLoadingBoat}: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text(l10n.boatNotFound);
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
                  '${l10n.runId}: ${run.rid}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.directions_boat, size: 16),
                    const SizedBox(width: 4),
                    Text('${l10n.boat} ${boat.name}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.track_changes, size: 16),
                    const SizedBox(width: 4),
                    Text('${l10n.scopeTo}: ${run.scopeTo}'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward, size: 16),
                    const SizedBox(width: 4),
                    Text('${l10n.directionTo}: ${run.directionTo ?? '-'}'),
                    const SizedBox(width: 20),
                    Icon(Icons.check, size: 16, color: run.hit > 0 ? Colors.green : Colors.red),
                    const SizedBox(width: 4),
                    Text('${l10n.hit}: ${run.hit}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.arrow_right_alt, size: 16),
                    const SizedBox(width: 4),
                    Text('${l10n.directionHit}: ${run.directionHit ?? '-'}'),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${l10n.intendedGatePart}: ${run.intendedPartOfGate ?? '-'}'),
                const SizedBox(height: 6),
                Text('${l10n.date}: ${run.dateTime.toLocal()}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
