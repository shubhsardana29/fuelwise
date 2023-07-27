import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuelwise/models/vehicle.dart';

class FirestoreService {
  final CollectionReference _vehiclesCollection = FirebaseFirestore.instance.collection('vehicles');

  // Fetch all vehicles from Firestore
  Future<List<Vehicle>> fetchVehiclesFromFirestore() async {
    final QuerySnapshot snapshot = await _vehiclesCollection.get();
    return snapshot.docs.map((doc) => Vehicle.fromFirestore(doc)).toList();
  }

  // Stream all vehicles from Firestore for real-time updates
  Stream<List<Vehicle>> streamVehiclesFromFirestore() {
    return _vehiclesCollection.snapshots().map(
      (snapshot) => snapshot.docs.map(
        (doc) => Vehicle.fromFirestore(doc),
      ).toList(),
    );
  }

  // Add a new vehicle to Firestore
  Future<void> addVehicleToFirestore(Vehicle vehicle) async {
    await _vehiclesCollection.add(vehicle.toFirestore());
  }

  // Update an existing vehicle in Firestore
  Future<void> updateVehicleInFirestore(Vehicle vehicle) async {
    await _vehiclesCollection.doc(vehicle.id).update(vehicle.toFirestore());
  }

  // Delete a vehicle from Firestore
  Future<void> deleteVehicleFromFirestore(String vehicleId) async {
    await _vehiclesCollection.doc(vehicleId).delete();
  }
}
