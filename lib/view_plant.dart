import 'package:final65122152/plant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ViewPlantPage extends StatelessWidget {
  final List<Map<String, dynamic>> plants;
  final Database database;

  ViewPlantPage({required this.plants, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant List'),
      ),
      body: plants.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return ListTile(
                  leading: Image.asset('assets/${plant['plantImage']}', width: 50, height: 50),
                  title: Text(plant['plantName']),
                  subtitle: Text(plant['plantScientific']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailPage(plant: plant, database: database),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
