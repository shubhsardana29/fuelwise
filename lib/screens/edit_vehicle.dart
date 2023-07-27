import 'package:flutter/material.dart';
import 'package:fuelwise/models/vehicle.dart';
import 'package:fuelwise/services/firestore_service.dart';

class EditVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  EditVehicleScreen({required this.vehicle});

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the existing vehicle data
    _makeController = TextEditingController(text: widget.vehicle.make);
    _modelController = TextEditingController(text: widget.vehicle.model);
    _yearController = TextEditingController(text: widget.vehicle.year.toString());
    _mileageController = TextEditingController(text: widget.vehicle.mileage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Vehicle'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _makeController,
                decoration: InputDecoration(labelText: 'Make'),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model'),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage (km/l)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 80.0),
              ElevatedButton(
              onPressed: () {
                _updateVehicle(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: Size(
                    double.infinity, 48), 
              ),
              child: Text('Save Changes',
                  style: TextStyle(color: Colors.black, fontSize: 18.0)),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateVehicle(BuildContext context) async {
    // Get the updated data from the text controllers
    String make = _makeController.text.trim();
    String model = _modelController.text.trim();
    int year = int.tryParse(_yearController.text) ?? 0;
    double mileage = double.tryParse(_mileageController.text) ?? 0.0;

    if (make.isNotEmpty && model.isNotEmpty && year > 0 && mileage > 0) {
      // Create a new vehicle object with the updated data and the original ID
      Vehicle updatedVehicle = Vehicle(
        id: widget.vehicle.id,
        make: make,
        model: model,
        year: year,
        mileage: mileage,
      );

      // Call the updateVehicleInFirestore method from FirestoreService
      try {
        await FirestoreService().updateVehicleInFirestore(updatedVehicle);

        // Return true to indicate that the vehicle was successfully updated
        Navigator.pop(context, true);
      } catch (e) {
        print('Error updating vehicle: $e');
        // Show an error message if the update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update vehicle. Please try again.')),
        );
      }
    }
  }
}
