import 'dart:math'; // Import for random number generation
import 'package:final65122152/add_land_use.dart';
import 'package:final65122152/search_land_use.dart';
import 'package:final65122152/view_plant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'add_plant_page.dart'; // Import the add plant page
import 'plant_detail_page.dart'; // Import the plant detail page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Database',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database? _database;
  List<Map<String, dynamic>> _plants = []; // List to store plant data
  List<int> _displayedPlantIDs = []; // List to track displayed plant IDs

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
  _database = await openDatabase(
    join(await getDatabasesPath(), 'database_of_plant.db'),
    onCreate: (db, version) async {
      await db.execute(''' 
        CREATE TABLE plant (
          plantID INTEGER PRIMARY KEY,
          plantName TEXT,
          plantScientific TEXT,
          plantImage TEXT
        )
      ''');

      await db.execute(''' 
        CREATE TABLE land_use (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          plant_name TEXT,
          part TEXT,
          description TEXT
        )
      ''');

      await _insertInitialData(db);
    },
    version: 2,
  );
  _loadPlants();
}

  Future<void> _insertInitialData(Database db) async {
    await db.insert('plant', {
      'plantID': 101001,
      'plantName': 'Mango',
      'plantScientific': 'Mangifera indica',
      'plantImage': 'mango.jpg',
    });

    await db.insert('plant', {
      'plantID': 101002,
      'plantName': 'Neem',
      'plantScientific': 'Azadirachta indica',
      'plantImage': 'neem.jpg',
    });

    await db.insert('plant', {
      'plantID': 101003,
      'plantName': 'Bamboo',
      'plantScientific': 'Bambusa vulgaris',
      'plantImage': 'bamboo.jpg',
    });

    await db.insert('plant', {
      'plantID': 101004,
      'plantName': 'Ginger',
      'plantScientific': 'Zingiber officinale',
      'plantImage': 'ginger.jpg',
    });
  }

  Future<void> _loadPlants() async {
    final List<Map<String, dynamic>> plants = await _database!.query('plant');
    setState(() {
      _plants = List<Map<String, dynamic>>.from(plants); // Ensure we create a mutable copy
      _displayedPlantIDs.clear(); // Clear the displayed IDs when loading new data
    });
  }

  List<Map<String, dynamic>> _getRandomPlants() {
    final random = Random();
    List<Map<String, dynamic>> availablePlants = _plants.where((plant) => !_displayedPlantIDs.contains(plant['plantID'])).toList();

    List<Map<String, dynamic>> randomPlants = [];

    if (availablePlants.isNotEmpty) {
      availablePlants.shuffle(random);
      // Select the first three plants
      randomPlants = availablePlants.take(3).toList();
      
      // Add selected plants' IDs to the displayed list
      _displayedPlantIDs.addAll(randomPlants.map((plant) => plant['plantID']));
    }

    return randomPlants;
  }

@override
Widget build(BuildContext context) {
  final randomPlants = _getRandomPlants(); // Store the random plants in a variable

  return Scaffold(
    appBar: AppBar(
      title: Text('Plant Database'),
    ),
    body: _plants.isEmpty
        ? Center(child: CircularProgressIndicator())
        : randomPlants.isEmpty // Check if randomPlants is empty
            ? Center(child: Text('No more plants to display.')) // Display message when no plants are available
            : ListView.builder(
                itemCount: randomPlants.length,
                itemBuilder: (context, index) {
                  final plant = randomPlants[index]; // Get random plant
                  return ListTile(
                    leading: Image.asset('assets/${plant['plantImage']}', width: 50, height: 50),
                    title: Text(plant['plantName']),
                    subtitle: Text(plant['plantScientific']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailPage(plant: plant, database: _database!),
                        ),
                      ).then((_) => _loadPlants());
                    },
                  );
                },
              ),
    bottomNavigationBar: BottomAppBar(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      IconButton(
        icon: Icon(Icons.add),
        tooltip: 'Add Plant',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPlantPage(database: _database!),
            ),
          ).then((_) => _loadPlants());
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        tooltip: 'Search Land Use',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchLandUsePage(database: _database!),
            ),
          );
        },
      ),
      IconButton(
        icon: Icon(Icons.list),
        tooltip: 'View Plants',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewPlantPage(plants: _plants, database: _database!),
            ),
          );
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.leaf), // Corrected line
        tooltip: 'Land Use',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLandUsePage(database: _database!, plants: _plants),
            ),
          );
        },
      ),
    ],
  ),
),

  );
}

}
