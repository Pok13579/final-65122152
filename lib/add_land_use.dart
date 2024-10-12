import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AddLandUsePage extends StatefulWidget {
  final Database database;
  final List<Map<String, dynamic>> plants;

  AddLandUsePage({required this.database, required this.plants});

  @override
  _AddLandUsePageState createState() => _AddLandUsePageState();
}

class _AddLandUsePageState extends State<AddLandUsePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPlant;
  String? _selectedPart;
  String? _selectedUse; 
  String? _landUseDescription;

  final List<String> _parts = ['Fruit', 'Leaves', 'Stems', 'Rhizome']; 
  final List<String> _descriptions = ['Medicinal', 'Culinary', 'Construction', 'Crafts']; 
  
  void _saveLandUse() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await widget.database.insert('land_use', {
        'plant_name': _selectedPlant,
        'part': _selectedPart,
        'description': _landUseDescription,
      });

      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Land Use'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Plant'),
                value: _selectedPlant,
                items: widget.plants.map((plant) {
                  return DropdownMenuItem<String>(
                    value: plant['plantName'],
                    child: Text(plant['plantName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPlant = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a plant' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Part'),
                value: _selectedPart,
                items: _parts.map((part) {
                  return DropdownMenuItem<String>(
                    value: part,
                    child: Text(part),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPart = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a part' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select descriptione'),
                value: _selectedUse,
                items: _descriptions.map((description) {
                  return DropdownMenuItem<String>(
                    value: description,
                    child: Text(description),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUse = value; 
                  });
                },
                validator: (value) => value == null ? 'Please select a use' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLandUse,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
