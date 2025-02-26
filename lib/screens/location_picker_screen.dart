import 'package:flutter/material.dart';
import '../dummy_data/dummy_data.dart';
import '../model/ride/locations.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(Location) onLocationSelected;
  final Location? excludedLocation;

  const LocationPickerScreen({
    super.key,
    required this.onLocationSelected,
    this.excludedLocation,
  });

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _filteredLocations = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handles search functionality by filtering locations based on the query
  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;

      if (_isSearching) {
        _filteredLocations = fakeLocations
            .where((location) =>
                location.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

        // Exclude selected location if needed
        if (widget.excludedLocation != null) {
          _filteredLocations
              .removeWhere((location) => location == widget.excludedLocation);
        }
      } else {
        _filteredLocations.clear();
      }
    });
  }

  /// Handles location selection, ensuring the excluded location is not chosen
  void _selectLocation(Location location) {
    if (widget.excludedLocation != null &&
        location == widget.excludedLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This location is already selected."),
        ),
      );
      return; // Prevent selection
    }

    widget.onLocationSelected(location);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildLocationList()),
        ],
      ),
    );
  }

  /// Builds the search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          labelText: 'Search Location',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  /// Builds the list of locations or a placeholder message
  Widget _buildLocationList() {
    if (!_isSearching) {
      return const Center(
        child: Text('Start typing to search for locations.'),
      );
    }

    return ListView.builder(
      itemCount: _filteredLocations.length,
      itemBuilder: (ctx, index) {
        final location = _filteredLocations[index];
        return ListTile(
          title: Text(location.name),
          subtitle: Text(location.country.name),
          onTap: () => _selectLocation(location),
        );
      },
    );
  }
}
