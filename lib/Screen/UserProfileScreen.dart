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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
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
      trailing: Icon(
          Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(IconData icon,
      String title,
      bool value,
      ValueChanged<bool> onChanged,) {
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