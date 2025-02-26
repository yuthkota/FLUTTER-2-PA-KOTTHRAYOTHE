import 'package:flutter/material.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../utils/animations_util.dart';
import '../../location_picker_screen.dart';

class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  @override
  void initState() {
    super.initState();
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      departureDate = widget.initRidePref!.departureDate;
      arrival = widget.initRidePref!.arrival;
      requestedSeats = widget.initRidePref!.requestedSeats;
    } else {
      departureDate = DateTime.now();
      requestedSeats = 1;
    }
  }

  void _selectDeparture(Location location) {
    if (arrival != null && arrival == location) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Departure and arrival locations cannot be the same.')),
      );
      return;
    }
    setState(() {
      departure = location;
    });
  }

  void _selectArrival(Location location) {
    if (departure != null && departure == location) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Departure and arrival locations cannot be the same.')),
      );
      return;
    }
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

  void _switchLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
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
              AnimationUtils.createBottomToTopRoute(
                LocationPickerScreen(
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
              AnimationUtils.createBottomToTopRoute(
                LocationPickerScreen(
                  onLocationSelected: _selectArrival,
                ),
              ),
            );
          },
        ),
        const Divider(),
        IconButton(
          icon: const Icon(Icons.swap_horiz),
          onPressed: _switchLocations,
          tooltip: 'Switch locations',
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
