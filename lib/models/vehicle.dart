import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String id; 
  String make;
  String model;
  int year;
  double mileage;

  Vehicle({required this.id, required this.make, required this.model, required this.year, required this.mileage});

  // Method to convert Firestore document data to Vehicle object
factory Vehicle.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Vehicle(
    id: doc.id, 
    make: data['make'] ?? '',
    model: data['model'] ?? '',
    year: data['year'] ?? 0,
    mileage: data['mileage'] ?? 0.0,
  );
}


  // Method to convert Vehicle object to Firestore document data
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,              
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
    };
  }
}
