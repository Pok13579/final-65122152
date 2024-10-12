import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AddPlantPage extends StatefulWidget {
  final Database database;

  AddPlantPage({required this.database});

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  String _plantName = '';
  String _plantScientific = '';
  String _plantImage = '';

  Future<void> _addPlant() async {
    if (_formKey.currentState!.validate()) {
      await widget.database.insert('plant', {
        'plantName': _plantName,
        'plantScientific': _plantScientific,
        'plantImage': _plantImage,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Plant Name'),
                validator: (value) => value!.isEmpty ? 'Please enter plant name' : null,
                onChanged: (value) {
                  _plantName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Scientific Name'),
                validator: (value) => value!.isEmpty ? 'Please enter scientific name' : null,
                onChanged: (value) {
                  _plantScientific = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image File Name (e.g. mango.jpg)'),
                validator: (value) => value!.isEmpty ? 'Please enter image file name' : null,
                onChanged: (value) {
                  setState(() {
                    _plantImage = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _plantImage.isNotEmpty
                  ? Image.asset(
                      'assets/$_plantImage',
                      height: 150,
                      width: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Image not found');
                      },
                    )
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPlant,
                child: Text('Add Plant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
