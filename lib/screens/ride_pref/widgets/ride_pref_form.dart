import 'package:flutter/material.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../theme/theme.dart';
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
    return Container(
      padding: const EdgeInsets.all(BlaSpacings.m),
      decoration: BoxDecoration(
        color: BlaColors.white,
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Departure & Arrival with Switch Button on the Right
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          Icon(Icons.location_on, color: BlaColors.iconNormal),
                      title: Text(departure?.name ?? 'Leaving from',
                          style: BlaTextStyles.body
                              .copyWith(color: BlaColors.textNormal)),
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
                    Divider(color: BlaColors.disabled),
                    ListTile(
                      leading:
                          Icon(Icons.location_on, color: BlaColors.iconNormal),
                      title: Text(arrival?.name ?? 'Going to',
                          style: BlaTextStyles.body
                              .copyWith(color: BlaColors.textNormal)),
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
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                onPressed: _switchLocations,
                tooltip: 'Switch locations',
              ),
            ],
          ),
          Divider(color: BlaColors.disabled),
          // Date Picker
          ListTile(
            leading: Icon(Icons.calendar_today, color: BlaColors.iconNormal),
            title: Text(
              '${departureDate.day}/${departureDate.month}/${departureDate.year}',
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
            onTap: () => _selectDate(context),
          ),
          Divider(color: BlaColors.disabled),
          // Seats Selector
          ListTile(
            leading: Icon(Icons.person, color: BlaColors.iconNormal),
            title: Text('$requestedSeats',
                style:
                    BlaTextStyles.body.copyWith(color: BlaColors.textNormal)),
            trailing: DropdownButton<int>(
              value: requestedSeats,
              onChanged: _updateSeats,
              dropdownColor: BlaColors.white,
              items: List.generate(4, (index) => index + 1)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString(),
                      style: BlaTextStyles.body
                          .copyWith(color: BlaColors.textNormal)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: BlaSpacings.m),
          // Search Button
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: BlaColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BlaSpacings.radius),
              ),
            ),
            child: Text(
              'Search',
              style: BlaTextStyles.button.copyWith(color: BlaColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
