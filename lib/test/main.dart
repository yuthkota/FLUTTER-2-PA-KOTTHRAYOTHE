// import 'package:flutter/material.dart';
// import 'screens/ride_pref/widgets/ride_pref_form.dart';
// import 'theme/theme.dart';
// import '../../../model/ride_pref/ride_pref.dart'; // Import your mock data model if needed
// import '../../../model/ride/locations.dart'; // Import the Location model

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: appTheme,
//       home: Scaffold(
//         body: RidePrefForm(initRidePref: RidePref(
//           departure: Location(name: "London", country: Country.uk),
//           departureDate: DateTime.now().add(Duration(days: 1)),
//           arrival: Location(name: "Paris", country: Country.france),
//           requestedSeats: 2,
//         )),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:week_3_blabla_project/screens/ride_pref/widgets/ride_pref_form.dart'; // Adjust the import path

// import 'package:week_3_blabla_project/model/ride/locations.dart'; // Assuming your Location model is here
// import 'package:week_3_blabla_project/model/ride_pref/ride_pref.dart'; // Assuming your RidePref model is here

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Ride Preference Form Test'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: RidePrefForm(
//               // You can provide an initial RidePref here if needed
//               // initRidePref: RidePref(
//               //   departure: Location(name: 'London', country: Country.uk),
//               //   departureDate: DateTime.now().add(Duration(days: 2)),
//               //   arrival: Location(name: 'Paris', country: Country.france),
//               //   requestedSeats: 3,
//               // ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/screens/ride_pref/widgets/ride_pref_form.dart'; 
import 'package:week_3_blabla_project/model/ride/locations.dart'; 
import 'package:week_3_blabla_project/model/ride_pref/ride_pref.dart';
import '../screens/location_picker_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ride Preference Form Test'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                MyRidePrefForm(), 
          ),
        ),
      ),
    );
  }
}

class MyRidePrefForm extends StatefulWidget {
  const MyRidePrefForm({super.key});

  @override
  _MyRidePrefFormState createState() => _MyRidePrefFormState();
}

class _MyRidePrefFormState extends State<MyRidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  @override
  void initState() {
    super.initState();
    departureDate = DateTime.now();
    requestedSeats = 1;
  }

  void _selectDeparture(Location location) {
    setState(() {
      departure = location;
    });
  }

  void _selectArrival(Location location) {
    setState(() {
      arrival = location;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != departureDate) {
      setState(() {
        departureDate = picked;
      });
    }
  }

  void _updateSeats(int? newValue) {
    if (newValue != null) {
      setState(() {
        requestedSeats = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(departure?.name ?? 'Leaving from'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LocationPickerScreen(
                  onLocationSelected: _selectDeparture,
                ),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(arrival?.name ?? 'Going to'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LocationPickerScreen(
                  onLocationSelected: _selectArrival,
                ),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text(
            '${departureDate.day}/${departureDate.month}/${departureDate.year}',
          ),
          onTap: () => _selectDate(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Seats'),
          trailing: DropdownButton<int>(
            value: requestedSeats,
            onChanged: _updateSeats,
            items: List.generate(4, (index) => index + 1)
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              if (departure == null || arrival == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Please select departure and arrival locations.')),
                );
                return;
              }

              final ridePref = RidePref(
                departure: departure!,
                departureDate: departureDate,
                arrival: arrival!,
                requestedSeats: requestedSeats,
              );
              print(ridePref);
            },
            child: const Text('Search'),
          ),
        ),
      ],
    );
  }
}
