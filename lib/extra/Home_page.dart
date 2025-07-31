import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _logoTapCount = 0;
  bool _easterEggActive = false;
  late AnimationController _pulseController;

  final List<Widget> _pages = [
    BloodSearchScreen(),
    AboutBloodDonationScreen(),
    BloodOrganizationScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> HOMEPAGE() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onLogoTap() {
    setState(() {
      _logoTapCount++;
    });

    if (_logoTapCount == 5) {
      _activateEasterEgg();
    }




    // Reset counter after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _logoTapCount = 0;
        });
      }
    });
  }








  void _activateEasterEgg() {

    setState(() {
      _easterEggActive = true;
    });

    HapticFeedback.lightImpact();
    // HapticFeedback.heavyImpact();    // ভারী কাঁপুনি
    // HapticFeedback.mediumImpact();   // মাঝারি কাঁপুনি
    // HapticFeedback.selectionClick(); // ছোট ক্লিক টাইপ কাঁপুনি
    // HapticFeedback.vibrate();        // সাধারণ ভাইব্রেশন

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text('🎉 Developer Mode!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🩸 You found the secret developer Easter egg!'),
            SizedBox(height: 10),
            Text('Fun fact: Just like how one developer can debug an entire app, one blood donor can save up to 3 lives! 😄'),
            SizedBox(height: 10),


            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '💻 Team Stats:\n'
                    '• Bugs squashed: ∞\n'
                    '• Coffee consumed: Too much ☕\n'
                    '• Lives saved through code: Countless! 🚀',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(Duration(seconds: 10), () {
                if (mounted) {
                  setState(() {
                    _easterEggActive = false;
                  });
                }
              });
            },
            child: InkWell(
              onTap: HOMEPAGE,
                child: Text('Awesome Team! 🎯')
            ),
          ),
        ],
      ),
    );
  }





///////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _easterEggActive ? Colors.purple[600] : Colors.red[600],
        title: Row(
          children: [
            InkWell(
              onTap: _onLogoTap,
              child: AnimatedBuilder(
                animation: _easterEggActive ? _pulseController : kAlwaysCompleteAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _easterEggActive ? 1.0 + (_pulseController.value * 0.3) : 1.0,
                    child: Icon(
                      Icons.bloodtype,
                      color: _easterEggActive ? Colors.yellow : Colors.white,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 8),
            Text(
              _easterEggActive ? 'Dev Mode Active!' : 'Blood Donation',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          InkWell(
            child: IconButton(
              icon: Icon(Icons.event, color: Colors.white, ),
              onPressed: () => _showEventsModal(),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              // color: Colors.green,
              color: Colors.redAccent,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.red,
            color: Colors.green,
            activeColor: Colors.white,
            tabBackgroundColor: _easterEggActive ? Colors.purple.shade800 : Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              HapticFeedback.selectionClick();
            },
            tabs: const [
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.info, text: 'About'),
              GButton(icon: Icons.local_hospital, text: 'Organizations'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }






  void _showEventsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EventsModal(),
    );
  }


}




class EventsModal extends StatefulWidget {
  const EventsModal({super.key});

  @override
  State<EventsModal> createState() => _EventsModalState();
}

class _EventsModalState extends State<EventsModal> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modal Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📅 Upcoming Events',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Donor vs Receiver Chart
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🩸 Blood Type Compatibility Chart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildCompatibilityChart(),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Events List
          Text(
            'Blood Drive Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                _buildEventCard(
                  'Central Hospital Blood Drive',
                  'March 15, 2024 • 9:00 AM - 5:00 PM',
                  'Central Hospital, Main Building',
                  Icons.local_hospital,
                  Colors.red,
                ),
                _buildEventCard(
                  'Community Blood Camp',
                  'March 18, 2024 • 10:00 AM - 3:00 PM',
                  'Community Center, Downtown',
                  Icons.people,
                  Colors.blue,
                ),
                _buildEventCard(
                  'University Blood Donation',
                  'March 22, 2024 • 11:00 AM - 4:00 PM',
                  'University Campus, Student Hall',
                  Icons.school,
                  Colors.green,
                ),
                _buildEventCard(
                  'Emergency Blood Drive',
                  'March 25, 2024 • 8:00 AM - 6:00 PM',
                  'City Hospital, Emergency Wing',
                  Icons.warning,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


// Events Modal Widget
// class EventsModal extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.8,
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Modal Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '📅 Upcoming Events',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//
//           // Donor vs Receiver Chart
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '🩸 Blood Type Compatibility Chart',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   _buildCompatibilityChart(),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//
//           // Events List
//           Text(
//             'Blood Drive Events',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Expanded(
//             child: ListView(
//               children: [
//                 _buildEventCard(
//                   'Central Hospital Blood Drive',
//                   'March 15, 2024 • 9:00 AM - 5:00 PM',
//                   'Central Hospital, Main Building',
//                   Icons.local_hospital,
//                   Colors.red,
//                 ),
//                 _buildEventCard(
//                   'Community Blood Camp',
//                   'March 18, 2024 • 10:00 AM - 3:00 PM',
//                   'Community Center, Downtown',
//                   Icons.people,
//                   Colors.blue,
//                 ),
//                 _buildEventCard(
//                   'University Blood Donation',
//                   'March 22, 2024 • 11:00 AM - 4:00 PM',
//                   'University Campus, Student Hall',
//                   Icons.school,
//                   Colors.green,
//                 ),
//                 _buildEventCard(
//                   'Emergency Blood Drive',
//                   'March 25, 2024 • 8:00 AM - 6:00 PM',
//                   'City Hospital, Emergency Wing',
//                   Icons.warning,
//                   Colors.orange,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }





  Widget _buildCompatibilityChart() {
    return Column(
      children: [
        // Chart Header
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Blood Type', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: Text('Can Donate To', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: Text('Can Receive From', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Divider(),
        // Chart Data
        _buildChartRow('O-', 'All types', 'O- only', Colors.red),
        _buildChartRow('O+', 'All +ve types', 'O-, O+', Colors.orange),
        _buildChartRow('A-', 'A-, A+, AB-, AB+', 'A-, O-', Colors.blue),
        _buildChartRow('A+', 'A+, AB+', 'A-, A+, O-, O+', Colors.lightBlue),
        _buildChartRow('B-', 'B-, B+, AB-, AB+', 'B-, O-', Colors.green),
        _buildChartRow('B+', 'B+, AB+', 'B-, B+, O-, O+', Colors.lightGreen),
        _buildChartRow('AB-', 'AB-, AB+', 'A-, B-, AB-, O-', Colors.purple),
        _buildChartRow('AB+', 'AB+ only', 'All types', Colors.deepPurple),
      ],
    );
  }




  Widget _buildChartRow(String bloodType, String canDonateTo, String canReceiveFrom, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                bloodType,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(canDonateTo, style: TextStyle(fontSize: 12)),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(canReceiveFrom, style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }





  Widget _buildEventCard(String title, String date, String location, IconData icon, Color color) {
    bool cnt = true;
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: TextStyle(fontSize: 12)),
            Text(location, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: ElevatedButton(
          onPressed:(){
           setState(() {
             cnt = !cnt;
           });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cnt ?color:Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(cnt ?'Join' : 'Joined'),
        ),
      ),
    );
  }


}





// Blood Search Screen

/// items: ['All', 'Dhaka', 'Chattogram', 'Khulna', 'Rajshahi','Barisal','Sylhet', 'Rangpur','Mymensingh']
//////////////////////////////////////////////////////////////////////////////////////Find Blood Donors
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
//////////////////////////////////////////////////////////////////////////////////////Find Blood Donors end




// About Blood Donation Screen
class AboutBloodDonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.info, size: 28, color: Colors.red[600]),
              SizedBox(width: 12),
              Text(
                'About Blood Donation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Hero Card
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 40),
                  SizedBox(height: 12),
                  Text(
                    'Every Drop Counts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your donation can save up to 3 lives',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Key Facts
          _buildInfoSection(
            'Key Facts',
            [
              '• One donation can save up to 3 lives',
              '• Blood cannot be manufactured - it can only come from donors',
              '• Every 2 seconds, someone needs blood',
              '• Less than 10% of eligible people donate blood',
              '• Blood has a shelf life of only 42 days',
            ],
            Icons.fact_check,
            Colors.blue,
          ),

          // Eligibility Criteria
          _buildInfoSection(
            'Eligibility Criteria',
            [
              '• Age: 18-65 years old',
              '• Weight: At least 50 kg (110 lbs)',
              '• Hemoglobin: Minimum 12.5 g/dL',
              '• No recent illness or medication',
              '• No recent tattoos or piercings (3 months)',
              '• No recent travel to malaria-endemic areas',
            ],
            Icons.person_outline,
            Colors.green,
          ),

          // Process
          _buildInfoSection(
            'Donation Process',
            [
              '1. Registration and health screening',
              '2. Mini physical examination',
              '3. Actual blood donation (8-10 minutes)',
              '4. Rest and refreshment',
              '5. Total time: 45-60 minutes',
            ],
            Icons.timeline,
            Colors.purple,
          ),

          // Benefits
          _buildInfoSection(
            'Benefits of Donating',
            [
              '• Free health screening',
              '• Helps maintain healthy iron levels',
              '• Reduces risk of heart disease',
              '• Burns calories (about 650 per donation)',
              '• Psychological benefit of helping others',
            ],
            Icons.health_and_safety,
            Colors.orange,
          ),

          // Blood Types
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bloodtype, color: Colors.red[600], size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Blood Type Distribution',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildBloodTypeBar('O+', 37.4, Colors.red),
                  _buildBloodTypeBar('O-', 6.6, Colors.red[300]!),
                  _buildBloodTypeBar('A+', 35.7, Colors.blue),
                  _buildBloodTypeBar('A-', 6.3, Colors.blue[300]!),
                  _buildBloodTypeBar('B+', 8.5, Colors.green),
                  _buildBloodTypeBar('B-', 1.5, Colors.green[300]!),
                  _buildBloodTypeBar('AB+', 3.4, Colors.purple),
                  _buildBloodTypeBar('AB-', 0.6, Colors.purple[300]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(item, style: TextStyle(fontSize: 14)),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodTypeBar(String type, double percentage, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 20,
                  width: (percentage / 100) * 200, // Fixed width instead of using MediaQuery
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text('${percentage}%', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// Blood Organization Screen
class BloodOrganizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      // Header
      Row(
      children: [
      Icon(Icons.local_hospital, size: 28, color: Colors.red[600]),
      SizedBox(width: 12),
      Text(
        'Blood Organizations',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      ],
    ),
    SizedBox(height: 20),

    // Search Bar
    Card(
    child: TextField(
    decoration: InputDecoration(
    hintText: 'Search organizations...',
    prefixIcon: Icon(Icons.search),
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(16),
    ),
    ),
    ),
    SizedBox(height: 20),

    // Filter Buttons
    SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    children: [
    _buildFilterChip('All', true),
    SizedBox(width: 8),
    _buildFilterChip('Blood Banks', false),
    SizedBox(width: 8),
    _buildFilterChip('Hospitals', false),
    SizedBox(width: 8),
    _buildFilterChip('NGOs', false),
    ],
    ),
    ),
    SizedBox(height: 20),

    // Organizations List
    _buildOrganizationCard(
    'American Red Cross',
    'Blood Bank • National Organization',
    '24/7 Emergency Service',
    'New York, NY',
    '4.8',
    Icons.bloodtype,
    Colors.red,
    ),
    _buildOrganizationCard(
    'Central Hospital Blood Center',
    'Hospital Blood Bank',
    'Trauma Center Level 1',
    'Los Angeles, CA',
    '4.6',
    Icons.local_hospital,
    Colors.blue,
    ),
    _buildOrganizationCard(
    'Community Blood Services',
    'Non-Profit Organization',
    'Serving 15+ hospitals',
    'Chicago, IL',
    '4.7',
    Icons.people,
    Colors.green,
    ),
    _buildOrganizationCard(
    'Blood & Tissue Center',
    'Regional Blood Center',
    'Specialized in rare blood types',
    'Houston, TX',
    '4.5',
    Icons.local_pharmacy,
    Colors.purple,
    ),
    _buildOrganizationCard(
    'City General Hospital',
    'Public Hospital',
    'Emergency blood services',
    'Miami, FL',
    '4.4',
    Icons.local_hospital,
    Colors.orange,
    ),
    _buildOrganizationCard(
      // Continuing from where the code was cut off...

      'LifeShare Blood Foundation',
      'Non-Profit Foundation',
      'Mobile blood drive services',
      'Phoenix, AZ',
      '4.9',
      Icons.directions_car,
      Colors.teal,
    ),
          ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle filter selection
      },
      selectedColor: Colors.red[100],
      checkmarkColor: Colors.red[600],
    );
  }

  Widget _buildOrganizationCard(
      String name,
      String type,
      String description,
      String location,
      String rating,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(rating),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('Contact'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Visit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// User Profile Screen
class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _notificationsEnabled = true;
  bool _emergencyAlerts = true;
  bool _donationReminders = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.person, size: 28, color: Colors.red[600]),
              SizedBox(width: 12),
              Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Profile Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red[100],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.red[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ebratul',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Blood Type: A+',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Verified Donor',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Statistics
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.favorite, color: Colors.red[600], size: 30),
                        SizedBox(height: 8),
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Donations',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.people, color: Colors.blue[600], size: 30),
                        SizedBox(height: 8),
                        Text(
                          '36',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Lives Saved',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Menu Items
          _buildMenuSection('Account Settings', [
            _buildMenuItem(Icons.edit, 'Edit Profile', () {}),
            _buildMenuItem(Icons.history, 'Donation History', () {}),
            _buildMenuItem(Icons.card_membership, 'Donor Card', () {}),
            _buildMenuItem(Icons.medical_services, 'Medical Records', () {}),
          ]),

          _buildMenuSection('Notifications', [
            _buildSwitchItem(
              Icons.notifications,
              'Push Notifications',
              _notificationsEnabled,
                  (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            _buildSwitchItem(
              Icons.warning,
              'Emergency Alerts',
              _emergencyAlerts,
                  (value) {
                setState(() {
                  _emergencyAlerts = value;
                });
              },
            ),
            _buildSwitchItem(
              Icons.schedule,
              'Donation Reminders',
              _donationReminders,
                  (value) {
                setState(() {
                  _donationReminders = value;
                });
              },
            ),
          ]),

          _buildMenuSection('Support', [
            _buildMenuItem(Icons.help, 'Help Center', () {}),
            _buildMenuItem(Icons.contact_support, 'Contact Support', () {}),
            _buildMenuItem(Icons.star_rate, 'Rate App', () {}),
            _buildMenuItem(Icons.share, 'Share App', () {}),
          ]),

          _buildMenuSection('Legal', [
            _buildMenuItem(Icons.privacy_tip, 'Privacy Policy', () {}),
            _buildMenuItem(Icons.description, 'Terms of Service', () {}),
            _buildMenuItem(Icons.info, 'About App', () {}),
          ]),

          SizedBox(height: 20),

          // Logout Button
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red[600]),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red[600]),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ),
          SizedBox(height: 20),

          // App Version
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: items,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
      IconData icon,
      String title,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.red[600],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red[600]),
              ),
            ),
          ],
        );
      },
    );
  }
}