import 'package:vagabond/notifiers/home_notifier.dart';
import 'package:vagabond/utils/provider.dart';
import 'package:vagabond/utils/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<HomeNotifier>(
      notifier: HomeNotifier(),
      child: Consumer<HomeNotifier>(
        builder: (_, notifier, child) => Scaffold(
          appBar: AppBar(
            title: Text('Vagabond'),
            actions: [
              IconButton(icon: Icon(Icons.refresh), onPressed: () => notifier.refreshShelters()),
            ],
          ),
          body: notifier.loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: notifier.shelters.length,
                  itemBuilder: (_, index) {
                    final shelter = notifier.shelters[index];
                    return ListTile(
                      title: Text(shelter.name),
                      onTap: () => Navigator.pushNamed(context, Routes.shelter, arguments: shelter.id),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, Routes.editShelter),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
