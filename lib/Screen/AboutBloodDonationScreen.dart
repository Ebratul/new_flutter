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