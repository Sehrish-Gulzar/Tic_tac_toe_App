import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(MaterialApp(home: UserScreen()));
}

class UserProfile {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String homeAddress;
  String emergencyContactName;
  String emergencyContactNumber;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.homeAddress,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
  });
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UserProfile _userProfile;
  LocationData? _currentLocation;

  // Method to handle emergency call
  void handleEmergencyCall() {
    // Implement your emergency call functionality here
  }

  // Method to handle first aid care
  void handleFirstAidCare() {
    // Implement your first aid care functionality here
  }

  // Method to handle donation
  void handleDonation() {
    // Implement your donation functionality here
  }

  // Method to get user's current location
  Future<void> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle case where user doesn't enable location services
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // Handle case where user doesn't grant location permission
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // User profile form
          // Implement the form fields for personal, home, and guidance details

          // Emergency call button
          ElevatedButton(
            onPressed: handleEmergencyCall,
            child: Text('Emergency Call'),
          ),

          // First aid care button
          ElevatedButton(
            onPressed: handleFirstAidCare,
            child: Text('First Aid Care'),
          ),

          // User's current location
          if (_currentLocation != null)
            Text('Latitude: ${_currentLocation!.latitude}\n'
                'Longitude: ${_currentLocation!.longitude}')
          else
            SizedBox(),
          // Donation button
          ElevatedButton(
            onPressed: handleDonation,
            child: Text('Donate'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getCurrentLocation,
        child: Icon(Icons.location_on),
      ),
    );
  }
}
