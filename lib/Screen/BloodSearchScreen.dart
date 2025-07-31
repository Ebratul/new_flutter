class BloodSearchScreen extends StatefulWidget {
  @override
  _BloodSearchScreenState createState() => _BloodSearchScreenState();
}

class _BloodSearchScreenState extends State<BloodSearchScreen> {
  String selectedBloodType = 'All';
  String selectedLocation = 'All';
  bool isUrgent = false;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _allDonors = [
    {'name': 'Reat', 'bloodType': 'O+', 'location': 'Dhaka', 'rating': 4.8, 'lastDonation': '2 weeks ago', 'isAvailable': true, 'distance': 2.5},
    {'name': 'safiul', 'bloodType': 'A+', 'location': 'Chattogram', 'rating': 4.9, 'lastDonation': '1 month ago', 'isAvailable': true, 'distance': 1.2},
    {'name': 'nahid', 'bloodType': 'B-', 'location': 'Chattogram', 'rating': 4.6, 'lastDonation': '3 weeks ago', 'isAvailable': true, 'distance': 5.8},
    {'name': 'towhid', 'bloodType': 'AB+', 'location': 'Khulna', 'rating': 4.7, 'lastDonation': '1 week ago', 'isAvailable': true, 'distance': 3.1},
    {'name': 'niha', 'bloodType': 'O-', 'location': 'Rajshahi', 'rating': 4.5, 'lastDonation': '2 days ago', 'isAvailable': true, 'distance': 8.2},
    {'name': 'seyam', 'bloodType': 'A-', 'location': 'Barisal', 'rating': 4.8, 'lastDonation': '5 days ago', 'isAvailable': true, 'distance': 4.7},
    {'name': 'Ebratul', 'bloodType': 'B+', 'location': 'Sylhet', 'rating': 4.4, 'lastDonation': '1 month ago', 'isAvailable': true, 'distance': 6.3},
    {'name': 'Milon', 'bloodType': 'AB-', 'location': 'Rangpur', 'rating': 4.9, 'lastDonation': '3 days ago', 'isAvailable': true, 'distance': 2.8},
    {'name': 'mehedi', 'bloodType': 'AB-', 'location': 'Mymensingh', 'rating': 4.9, 'lastDonation': '3 days ago', 'isAvailable': true, 'distance': 2.8},
  ];

  List<Map<String, dynamic>> get _filteredDonors {
    var filtered = _allDonors.where((donor) {
      bool matchesBloodType = selectedBloodType == 'All' || donor['bloodType'] == selectedBloodType;
      bool matchesLocation = selectedLocation == 'All' || donor['location'] == selectedLocation;
      return matchesBloodType && matchesLocation;
    }).toList();

    if (isUrgent) {
      // For urgent requests, prioritize by:
      // 1. Distance (closer first)
      // 2. Recent availability (last donation timing)
      // 3. Rating
      filtered.sort((a, b) {
        // First sort by distance
        int distanceCompare = a['distance'].compareTo(b['distance']);
        if (distanceCompare != 0) return distanceCompare;

        // Then by rating (higher first)
        return b['rating'].compareTo(a['rating']);
      });

      // For urgent, show only closest and most reliable donors
      filtered = filtered.take(15).toList();
    } else {
      // Normal search - sort by rating
      filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final donors = _filteredDonors;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Blood Search'),
      //   backgroundColor: Colors.red[600],
      //   foregroundColor: Colors.white,
      // ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Header
            Row(
              children: [
                Icon(Icons.search, size: 28, color: Colors.red[600]),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Find Blood Donors',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Urgent Request Banner (only shown when urgent is selected)
            if (isUrgent)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[800], size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Urgent Request Active',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Showing closest donors first • Emergency notifications sent',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Search Filters
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Blood Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedBloodType,
                      decoration: InputDecoration(
                        labelText: 'Blood Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.bloodtype),
                      ),
                      items: ['All', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBloodType = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Location Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      items: ['All', 'Dhaka', 'Chattogram', 'Khulna', 'Rajshahi','Barisal','Sylhet', 'Rangpur','Mymensingh']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocation = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Urgent checkbox and Search button
                    Row(
                      children: [
                        Checkbox(
                          value: isUrgent,
                          onChanged: (bool? value) {
                            setState(() {
                              isUrgent = value!;
                            });

                            // Show urgent request confirmation
                            if (isUrgent) {
                              _showUrgentRequestDialog();
                            }
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Urgent Request'),
                              if (isUrgent)
                                Text(
                                  'Priority sorting enabled',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // HapticFeedback.heavyImpact();

                            _performSearch();
                          },
                          child: Text('Search'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isUrgent ? Colors.orange[600] : Colors.red[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Search Results Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUrgent
                            ? 'Urgent: ${donors.length} closest donors'
                            : 'Available Donors (${donors.length})',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (isUrgent)
                        Text(
                          'Sorted by distance & availability',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 12),

            // Donors List
            Expanded(
              child: ListView.builder(
                itemCount: donors.length,
                itemBuilder: (context, index) {
                  final donor = donors[index];

                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red[100],
                            child: Text(
                              donor['bloodType'],
                              style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (isUrgent)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(donor['name'], style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${donor['location']} • ${donor['distance']} km away'),
                          SizedBox(height: 4),
                          // Fixed Row with proper overflow handling
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(' ${donor['rating']} ', style: TextStyle(fontSize: 12)),
                              Expanded(
                                child: Text(
                                  '• Last donation: ${donor['lastDonation']}',
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (isUrgent)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.green, size: 14),
                                  Expanded(
                                    child: Text(
                                      ' Available now',
                                      style: TextStyle(fontSize: 12, color: Colors.green),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUrgent)
                            IconButton(
                              icon: Icon(Icons.call, color: Colors.red),
                              onPressed: () => _makeUrgentCall(donor['name']),
                            )
                          else
                            IconButton(
                              icon: Icon(Icons.phone, color: Colors.green),
                              onPressed: () => _makeCall(donor['name']),
                            ),
                          IconButton(
                            icon: Icon(Icons.message, color: Colors.blue),
                            onPressed: () => _sendMessage(donor['name']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showUrgentRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Urgent Request'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🚨 Urgent mode activated!'),
            SizedBox(height: 8),
            Text('• Donors sorted by distance'),
            Text('• Emergency notifications sent'),
            Text('• Priority contact methods enabled'),
            Text('• Showing closest 15 donors only'),
            SizedBox(height: 8),
            Text(
              'Please ensure this is a genuine emergency.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    // fetch data from firebase



    // Simulate search action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isUrgent
              ? '🚨 Urgent search completed! Emergency notifications sent to nearby donors.'
              : 'Search completed! Found ${_filteredDonors.length} donors.',
        ),
        backgroundColor: isUrgent ? Colors.orange[600] : Colors.green[600],
      ),
    );
  }

  void _makeUrgentCall(String donorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚨 Making urgent call to $donorName...'),
        backgroundColor: Colors.red[600],
      ),
    );
  }

  void _makeCall(String donorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📞 Calling $donorName...'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  void _sendMessage(String donorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💬 Sending message to $donorName...'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}