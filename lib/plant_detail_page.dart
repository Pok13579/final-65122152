import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, dynamic> plant;
  final Database database;

  PlantDetailPage({required this.plant, required this.database});

  Future<void> _deletePlant(BuildContext context) async {
    await database.delete('plant', where: 'plantID = ?', whereArgs: [plant['plantID']]);
    Navigator.pop(context); // กลับไปยังหน้าหลักหลังลบข้อมูล
  }

  Future<void> _editPlant(BuildContext context) async {
    // สร้างหน้าต่างใหม่สำหรับการแก้ไขข้อมูลพืช
    final editedPlant = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController(text: plant['plantName']);
        final TextEditingController scientificController = TextEditingController(text: plant['plantScientific']);
        final TextEditingController imageController = TextEditingController(text: plant['plantImage']);

        return AlertDialog(
          title: Text('Edit Plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Plant Name'),
              ),
              TextField(
                controller: scientificController,
                decoration: InputDecoration(labelText: 'Scientific Name'),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image File Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'plantID': plant['plantID'],
                  'plantName': nameController.text,
                  'plantScientific': scientificController.text,
                  'plantImage': imageController.text,
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (editedPlant != null) {
      await database.update('plant', editedPlant, where: 'plantID = ?', whereArgs: [plant['plantID']]);
      Navigator.pop(context); // กลับไปยังหน้าหลัก
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant['plantName']),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deletePlant(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/${plant['plantImage']}', width: 300, height: 300), // Update to include 'assets/' prefix
            SizedBox(height: 16),
            Text(
              'Scientific Name: ${plant['plantScientific']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Plant ID: ${plant['plantID']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editPlant(context),
        child: Icon(Icons.edit),
      ),
    );
  }
}
