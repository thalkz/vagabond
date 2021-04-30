import 'package:vagabond/models/shelter.dart';
import 'package:vagabond/notifiers/shelter_notifier.dart';
import 'package:vagabond/utils/provider.dart';
import 'package:vagabond/utils/routes.dart';
import 'package:flutter/material.dart';

class ShelterPage extends StatelessWidget {
  const ShelterPage({Key? key, required this.shelterId}) : super(key: key);

  final String shelterId;

  @override
  Widget build(BuildContext context) {
    return Provider<ShelterNotifier>(
      notifier: ShelterNotifier(shelterId: shelterId),
      child: Consumer<ShelterNotifier>(
        builder: (_, notifier, child) {
          final shelter = notifier.shelter;
          return Scaffold(
            appBar: AppBar(
              title: Text('Vagabond'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => notifier.refreshShelter(),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.pushNamed(context, Routes.editShelter, arguments: shelterId),
                ),
              ],
            ),
            body: notifier.loading || shelter == null
                ? Center(child: CircularProgressIndicator())
                : ShelterContent(shelter: shelter),
          );
        },
      ),
    );
  }
}

class ShelterContent extends StatelessWidget {
  const ShelterContent({Key? key, required this.shelter}) : super(key: key);

  final Shelter shelter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(shelter.name),
        Text('${shelter.opened}'),
        Text(shelter.location.toString()),
        Text(shelter.description ?? ''),
        Text('Created at: ${shelter.createdAt.toIso8601String()}')
      ],
    );
  }
}
