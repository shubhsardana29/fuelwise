import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuelwise/models/vehicle.dart';
import 'package:fuelwise/services/firestore_service.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late String make;
  late String model;
  late int year;
  late double mileage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Vehicle'),
      ),
      body: Center(
        // Center the form
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Make'),
                  onSaved: (value) => make = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the make';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Model'),
                  onSaved: (value) => model = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => year = int.parse(value!),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the year';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mileage (km/l)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => mileage = double.parse(value!),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the mileage';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Create a new Vehicle instance with the form data
                      final newVehicle = Vehicle(
                        id: FirebaseFirestore.instance
                            .collection('vehicles')
                            .doc()
                            .id,
                        make: make,
                        model: model,
                        year: year,
                        mileage: mileage,
                      );

                      // Save the new vehicle to Firestore
                      _saveNewVehicle(newVehicle);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text('Save',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveNewVehicle(Vehicle vehicle) async {
    try {
      await FirestoreService().addVehicleToFirestore(vehicle);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add vehicle. Please try again.')),
      );
    }
  }
}
