import 'package:flutter/material.dart';
import 'package:fuelwise/models/vehicle.dart';
import 'package:fuelwise/screens/add_vehicle.dart';
import 'package:fuelwise/screens/edit_vehicle.dart'; 
import 'package:fuelwise/screens/login_screen.dart';
import 'package:fuelwise/services/auth_service.dart';
import 'package:fuelwise/services/firestore_service.dart';

class VehicleListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              try {
                // Call the signOut method from the AuthenticationService
                await AuthenticationService().signOut();

                // After successful sign-out, navigate to the login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // This prevents going back to the VehicleListScreen
                );
              } catch (e) {
                print('Error signing out: $e');
                // Show an error message if sign-out fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sign out. Please try again.')),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Vehicle>>(
        stream: _firestoreService.streamVehiclesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            final vehicles = snapshot.data;
            if (vehicles == null || vehicles.isEmpty) {
              return Center(child: Text('No vehicles found.'));
            }
            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                Color color;

                if (vehicle.mileage >= 15 && vehicle.year >= DateTime.now().year - 5) {
                  color = Color.fromARGB(255, 100, 231, 105);
                } else if (vehicle.mileage >= 15 && vehicle.year < DateTime.now().year - 5) {
                  color = Colors.amber;
                } else {
                  color = Colors.red;
                }

                return GestureDetector(
                  onTap: () {
                    // Navigate to the EditVehicleScreen when a vehicle is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditVehicleScreen(vehicle: vehicle)),
                    ).then((value) {
                      // Refresh the vehicle list after returning from the EditVehicleScreen
                      if (value != null && value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vehicle updated successfully!')),
                        );
                      }
                    });
                  },
                  child: Dismissible(
                    key: Key(vehicle.id), // Use a unique key for each Dismissible widget
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart, // Allow swipe from right to left
                    onDismissed: (direction) {
                      // Delete the vehicle from Firestore when dismissed
                      _deleteVehicle(context, vehicle.id);
                    },
                    child: ListTile(
                      title: Text('${vehicle.make} ${vehicle.model}'),
                      subtitle: Text('Year: ${vehicle.year} | Mileage: ${vehicle.mileage} km/l'),
                      leading: CircleAvatar(
                        backgroundColor: color,
                        child: Icon(Icons.directions_car),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // Show a confirmation dialog before dismissing the item
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Vehicle'),
                            content: Text('Are you sure you want to delete this vehicle?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddVehicleScreen when the FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          ).then((value) {
            // Refresh the vehicle list after returning from the AddVehicleScreen
            if (value != null && value) {
              // Value is true if a new vehicle was added, so refresh the list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New vehicle added successfully!')),
              );
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteVehicle(BuildContext context, String vehicleId) async {
    try {
      await _firestoreService.deleteVehicleFromFirestore(vehicleId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehicle deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting vehicle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete vehicle. Please try again.')),
      );
    }
  }
}
