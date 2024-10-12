import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SearchLandUsePage extends StatefulWidget {
  final Database database;

  SearchLandUsePage({required this.database});

  @override
  _SearchLandUsePageState createState() => _SearchLandUsePageState();
}

class _SearchLandUsePageState extends State<SearchLandUsePage> {
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _searchedPlant;

  Future<void> _searchPlant() async {
    String searchName = _searchController.text;
    final List<Map<String, dynamic>> result = await widget.database.query(
      'plant',
      where: 'plantName LIKE ?',
      whereArgs: ['%$searchName%'],
    );

    if (result.isNotEmpty) {
      setState(() {
        _searchedPlant = result.first; 
      });
    } else {
      setState(() {
        _searchedPlant = null; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Land Use'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter Plant Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPlant,
                ),
              ),
            ),
            SizedBox(height: 20),
            _searchedPlant == null
                ? Text('No plant found.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${_searchedPlant!['plantName']}',
                          style: TextStyle(fontSize: 20)),
                      Text('Scientific Name: ${_searchedPlant!['plantScientific']}'),
                      Image.asset('assets/${_searchedPlant!['plantImage']}', height: 100),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
