import 'package:vagabond/notifiers/edit_shelter_notifier.dart';
import 'package:vagabond/utils/provider.dart';
import 'package:flutter/material.dart';

class EditShelterPage extends StatelessWidget {
  EditShelterPage({Key? key, required this.shelterId}) : super(key: key);

  final String? shelterId;

  @override
  Widget build(BuildContext context) {
    return Provider<EditShelterNotifier>(
      notifier: EditShelterNotifier(shelterId: shelterId),
      child: Consumer<EditShelterNotifier>(
        builder: (_, notifier, __) => Scaffold(
          appBar: AppBar(
            title: Text('Edit Shelter'),
            actions: [
              ElevatedButton(
                onPressed: () => notifier.save(),
                child: Text('Save'),
              ),
            ],
          ),
          body: notifier.loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: notifier.nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: notifier.descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: notifier.latitudeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Latitude'),
                    ),
                    TextField(
                      controller: notifier.longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Longitude'),
                    ),
                    ElevatedButton(onPressed: () => notifier.delete(), child: Text('Delete'))
                  ],
                ),
        ),
      ),
    );
  }
}
