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