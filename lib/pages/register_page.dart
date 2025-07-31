import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? selectedBloodGroup;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedSubDistrict;

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Blood group options
  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  Future showLoginPagE() async{
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Bangladesh divisions and districts
  final Map<String, List<String>> divisionDistricts = {

    'Dhaka': [
      'Dhaka', 'Faridpur', 'Gazipur', 'Gopalganj', 'Kishoreganj',
      'Madaripur', 'Manikganj', 'Munshiganj', 'Narayanganj', 'Narsingdi',
      'Rajbari', 'Shariatpur', 'Tangail'
    ],
    'Chittagong': [
      'Bandarban', 'Brahmanbaria', 'Chandpur', 'Chittagong', 'Comilla',
      'Cox\'s Bazar', 'Feni', 'Khagrachhari', 'Lakshmipur', 'Noakhali',
      'Rangamati'
    ],
    'Rajshahi': [
      'Bogura', 'Chapainawabganj', 'Joypurhat', 'Naogaon', 'Natore',
      'Pabna', 'Rajshahi', 'Sirajganj'
    ],
    'Khulna': [
      'Bagerhat', 'Chuadanga', 'Jessore', 'Jhenaidah', 'Khulna',
      'Kushtia', 'Magura', 'Meherpur', 'Narail', 'Satkhira'
    ],
    'Sylhet': [
      'Habiganj', 'Moulvibazar', 'Sunamganj', 'Sylhet'
    ],
    'Barisal': [
      'Barguna', 'Barisal', 'Bhola', 'Jhalokati', 'Patuakhali', 'Pirojpur'
    ],
    'Rangpur': [
      'Dinajpur', 'Gaibandha', 'Kurigram', 'Lalmonirhat', 'Nilphamari',
      'Panchagarh', 'Rangpur', 'Thakurgaon'
    ],
    'Mymensingh': [
      'Jamalpur', 'Mymensingh', 'Netrakona', 'Sherpur'
    ],

  };






  // Sample sub-districts
  final Map<String, Map<String, List<String>>> districtSubDistricts = {

  'Dhaka': {
      'Dhaka': ['Dhamrai','Dohar','Keraniganj','Nawabganj','Savar'],
      'Faridpur': ['Alfadanga','Bhanga','Boalmari','Char Bhadrasan','Faridpur Sadar','Madhukhali','Nagarkanda','Sadarpur','Saltha'],
      'Gazipur': ['Gazipur Sadar','Kaliakoir','Kaliganj','Kapasia','Sreepur'],
      'Gopalganj': ['Gopalganj Sadar','Kashiani','Kotalipara','Muksudpur','Tungipara'],
      'Kishoreganj': ['Kishoreganj Sadar','Itna','Karimganj','Pakundia','Bajitpur','Bhairab','Mithamain','Nikli','Kuliarchar','Hossainpur'],
      'Madaripur': ['Madaripur Sadar','Rajoir','Shibchar','Kalkini','Dasar'],
      'Manikganj': ['Manikganj Sadar','Saturia','Shivalaya','Singair'],
      'Munshiganj': ['Munshiganj Sadar','Sirajdikhan','Sreenagar','Lohajong','Gajaria','Tongibari'],
      'Narayanganj': ['Narayanganj Sadar','Araihazar','Bandar','Rupganj','Sonargaon'],
      'Narsingdi': ['Narsingdi Sadar','Belabo','Monohardi','Palash','Raipura','Shibpur'],
      'Rajbari': ['Rajbari Sadar','Baliakandi','Goalanda','Kalukhali','Pangsha'],
      'Shariatpur': ['Shariatpur Sadar','Naria','Jajira','Gosairhat','Damudya','Bhedarganj'],
      'Tangail': ['Tangail Sadar','Basail','Bhuapur','Delduar','Dhanbari','Ghatail','Gopalpur','Kalihati','Madhupur','Mirzapur','Nagarpur','Sakhipur']
    },
    'Sylhet': {
      'Sylhet': ['Sylhet Sadar','Beanibazar','Balaganj','Dakshin Surma','Companiganj','Fenchuganj','Golapganj','Gowainghat','Jaintiapur','Kanaighat','Osmani Nagar','Zakiganj'],
      'Habiganj': ['Habiganj Sadar','Ajmiriganj','Bahubal','Baniachong','Chunarughat','Lakhai','Madhabpur','Nabiganj','Shaistaganj'],
      'Moulvibazar': ['Moulvibazar Sadar','Barlekha','Kamalganj','Kulaura','Rajnagar','Sreemangal','Sreemangal','Zakiganj'],
      'Sunamganj': ['Sunamganj Sadar','Dakshin Sunamganj','Chhatak','Dharampasha','Derai','Dhubaura','Jamalgonj','Jagannathpur','Shantiganj']
    },
    'Chittagong': {
      'Bandarban': [
        'Bandarban Sadar', 'Lama', 'Naikhongchhari', 'Ruma',
        'Rowangchhari', 'Thanchi'
      ],
      'Brahmanbaria': [
        'Brahmanbaria Sadar', 'Ashuganj', 'Bancharampur',
        'Bijoynagar', 'Brahmanpara', 'Kasba', 'Nabinagar',
        'Sarail'
      ],
      'Chandpur': [
        'Chandpur Sadar', 'Faridganj', 'Haimchar', 'Haziganj',
        'Kachua', 'Matlab Dakshin', 'Matlab Uttar', 'Shahrasti'
      ],
      'Chittagong': [
        'Anwara','Banshkhali','Boalkhali','Chandanaish','Fatikchhari',
        'Hathazari','Lohagara','Mirsharai','Patiya','Rangunia',
        'Raozan','Sandwip','Satkania','Sitakunda','Karnaphuli'
      ],
      'Comilla': [
        'Comilla Sadar', 'Barura','Brahmanpara','Chandina',
        'Chauddagram','Daudkandi','Debidwar','Homna',
        'Laksham','Meghna','Muradnagar','Nangalkot','Titas'
      ],
      'Cox\'s Bazar': [
        'Cox\'s Bazar Sadar','Chakaria','Kutubdia','Maheshkhali',
        'Ramu','Teknaf','Ukhia','Pekua'
      ],
      'Feni': ['Feni Sadar','Fulgazi','Parshuram','Sonagazi'],
      'Khagrachhari': [
        'Khagrachhari Sadar','Dighinala','Guimara','Matiranga',
        'Panchhari','Rangamati–Bandarban Road'
      ],
      'Lakshmipur': [
        'Lakshmipur Sadar','Raipur','Ramganj','Ramgoti',
        'Kamolganj'
      ],
      'Noakhali': [
        'Noakhali Sadar','Begumganj','Chatkhil','Hatiya',
        'Kabirhat','Senbagh','Sonaimuri','Subarnachar'
      ],
      'Rangamati': [
        'Rangamati Sadar','Barkal','Belaichhari','Kaptai',
        'Juraichhari','Rajasthali','Bagaichhari','Barkal'
      ],
    },

    'Rajshahi': {
      'Bogura': [
        'Adamdighi', 'Bogra Sadar', 'Dhunat', 'Dhupchanchia', 'Gabtali',
        'Kahaloo', 'Nandigram', 'Sariakandi', 'Shajahanpur', 'Sherpur', 'Sonatala'
      ],
      'Chapainawabganj': [
        'Bholahat', 'Gomostapur', 'Nachole', 'Chapainawabganj Sadar', 'Shibganj'
      ],
      'Joypurhat': [
        'Akkelpur', 'Joypurhat Sadar', 'Kalai', 'Khetlal', 'Panchbibi'
      ],
      'Naogaon': [
        'Atrai', 'Badalgachhi', 'Dhamoirhat', 'Manda', 'Mahadebpur',
        'Naogaon Sadar', 'Niamatpur', 'Patnitala', 'Porsha', 'Raninagar', 'Sapahar'
      ],
      'Natore': [
        'Bagatipara', 'Baraigram', 'Gurudaspur', 'Lalpur', 'Natore Sadar', 'Singra'
      ],
      'Pabna': [
        'Atgharia', 'Bera', 'Bhangura', 'Chatmohar', 'Faridpur', 'Ishwardi',
        'Pabna Sadar', 'Santhia', 'Sujanagar'
      ],
      'Rajshahi': [
        'Bagha', 'Bagmara', 'Boalia', 'Charghat', 'Durgapur',
        'Godagari', 'Mohanpur', 'Paba', 'Puthia', 'Rajpara', 'Shah Makhdum'
      ],
      'Sirajganj': [
        'Belkuchi', 'Chauhali', 'Kamarkhanda', 'Kazipur', 'Raiganj',
        'Shahjadpur', 'Sirajganj Sadar', 'Tarash', 'Ullapara'
      ],
    },
    'Khulna': {
      'Bagerhat': [
        'Bagerhat Sadar', 'Chitalmari', 'Fakirhat', 'Kachua',
        'Mollahat', 'Mongla', 'Morrelganj', 'Rampal', 'Sharankhola'
      ],
      'Chuadanga': [
        'Alamdanga', 'Chuadanga Sadar', 'Damurhuda', 'Jibannagar'
      ],
      'Jessore': [
        'Jessore Sadar', 'Abhaynagar', 'Bagherpara', 'Chaugachha',
        'Jhikargacha', 'Keshabpur', 'Manirampur', 'Sharsha'
      ],
      'Jhenaidah': [
        'Harinakundu', 'Jhenaidah Sadar', 'Kaliganj',
        'Kotchandpur', 'Maheshpur', 'Shailkupa'
      ],
      'Khulna': [
        'Batiaghata', 'Dacope', 'Dighalia', 'Dumuria', 'Terokhada',
        'Phultala', 'Paikgachha', 'Rupsa', 'Khalishpur', 'Sonadanga', 'Daulatpur'
      ],
      'Kushtia': [
        'Bheramara', 'Daulatpur', 'Khoksa', 'Kumarkhali',
        'Kushtia Sadar', 'Mirpur'
      ],
      'Magura': [
        'Magura Sadar', 'Mohammadpur', 'Shalikha', 'Sreepur'
      ],
      'Meherpur': [
        'Gangni', 'Meherpur Sadar', 'Mujibnagar'
      ],
      'Narail': [
        'Kalia', 'Lohagara', 'Narail Sadar'
      ],
      'Satkhira': [
        'Assasuni', 'Debhata', 'Kalaroa', 'Kaliganj',
        'Satkhira Sadar', 'Shyamnagar', 'Tala'
      ]
    },
    'Barisal': {
      'Barguna': [
        'Amtali', 'Bamna', 'Barguna Sadar', 'Betagi', 'Patharghata', 'Taltali'
      ],
      'Barisal': [
        'Barisal Sadar', 'Agailjhara', 'Bakerganj', 'Banaripara',
        'Babuganj', 'Gournadi', 'Hizla', 'Mehendiganj', 'Muladi', 'Wazirpur'
      ],
      'Bhola': [
        'Bhola Sadar', 'Borhanuddin', 'Char Fasson', 'Daulatkhan',
        'Lalmohan', 'Manpura', 'Tazumuddin'
      ],
      'Jhalokati': [
        'Jhalokati Sadar', 'Kathalia', 'Nalchity', 'Rajapur'
      ],
      'Patuakhali': [
        'Bauphal', 'Dashmina', 'Dumki', 'Galachipa',
        'Kalapara', 'Mirzaganj', 'Patuakhali Sadar'
      ],
      'Pirojpur': [
        'Bhandaria', 'Kawkhali', 'Mathbaria', 'Nazirpur',
        'Nesarabad', 'Pirojpur Sadar', 'Zianagar'
      ],
    },

    'Rangpur': {
      'Dinajpur': [
        'Birampur', 'Birganj', 'Biral', 'Bochaganj', 'Chirirbandar',
        'Dinajpur Sadar', 'Ghoraghat', 'Hakimpur', 'Khansama', 'Nawabganj', 'Parbatipur', 'Kaharole', 'Fulbari'
      ],
      'Gaibandha': [
        'Fulchhari', 'Gaibandha Sadar', 'Gobindaganj', 'Palashbari',
        'Sadullapur', 'Saghata', 'Sundarganj'
      ],
      'Kurigram': [
        'Bhurungamari', 'Chilmari', 'Phulbari', 'Kurigram Sadar',
        'Nageshwari', 'Rajarhat', 'Raomari', 'Ulipur', 'Char Rajibpur'
      ],
      'Lalmonirhat': [
        'Aditmari', 'Hatibandha', 'Kaliganj', 'Lalmonirhat Sadar', 'Patgram'
      ],
      'Nilphamari': [
        'Dimla', 'Domar', 'Jaldhaka', 'Kishoreganj',
        'Nilphamari Sadar', 'Saidpur'
      ],
      'Panchagarh': [
        'Atwari', 'Boda', 'Debiganj', 'Panchagarh Sadar', 'Tetulia'
      ],
      'Rangpur': [
        'Rangpur Sadar', 'Badarganj', 'Kaunia', 'Gangachara',
        'Mithapukur', 'Taraganj', 'Pirganj', 'Pirgacha'
      ],
      'Thakurgaon': [
        'Thakurgaon Sadar', 'Baliadangi', 'Haripur', 'Pirganj', 'Ranisankail'
      ],
    },

    'Mymensingh': {
      'Jamalpur': [
        'Jamalpur Sadar', 'Bakshiganj', 'Dewanganj', 'Islampur',
        'Madarganj', 'Melandaha', 'Sarishabari'
      ],
      'Mymensingh': [
        'Mymensingh Sadar', 'Muktagacha', 'Bhaluka', 'Haluaghat',
        'Gafargaon', 'Gouripur', 'Trishal', 'Ishwarganj',
        'Nandail', 'Phulpur', 'Fulbaria', 'Dhobaura'
      ],
      'Netrakona': [
        'Netrakona Sadar', 'Atpara', 'Barhatta', 'Durgapur',
        'Khaliajuri', 'Kalmakanda', 'Kendua', 'Madan', 'Mohanganj', 'Purbadhala'
      ],
      'Sherpur': [
        'Sherpur Sadar', 'Nalitabari', 'Jhenaigati',
        'Nakla', 'Sreebardi'
      ],
    }


  };

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Check if email already exists in Firestore
  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.trim().toLowerCase())
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedBloodGroup == null) {
      _showErrorDialog('Please select a blood group');
      return;
    }

    if (selectedDivision == null) {
      _showErrorDialog('Please select a division');
      return;
    }

    if (selectedDistrict == null) {
      _showErrorDialog('Please select a district');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if email already exists
      bool emailExists = await checkEmailExists(emailController.text);
      if (emailExists) {
        _showErrorDialog('This email is already registered. Please use a different email.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'age': int.parse(ageController.text.trim()),
        'email': emailController.text.trim().toLowerCase(),
        'phone': phoneController.text.trim(),
        'bloodGroup': selectedBloodGroup,
        'division': selectedDivision,
        'district': selectedDistrict,
        'subDistrict': selectedSubDistrict,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSuccessDialog('Registration successful! Please login to continue.');

      // Navigate to login page or home page
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed';

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Please use at least 6 characters';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('Registration failed: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  List<String> getDistrictsForDivision(String? division) {
    if (division == null) return [];
    return divisionDistricts[division] ?? [];
  }

  List<String> getSubDistrictsForDistrict(String? district) {
    if (district == null || selectedDivision == null) return [];
    Map<String, List<String>> divisionSubDistricts = districtSubDistricts[selectedDivision!] ?? {};
    return divisionSubDistricts[district] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Registration Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.person_add,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Join Blood Donation',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Create your account to save lives',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),
                  SizedBox(height: 16),

                  // First Name
                  _buildTextField(
                    controller: firstNameController,
                    label: 'First Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      if (value.length < 2) {
                        return 'First name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Last Name
                  _buildTextField(
                    controller: lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      if (value.length < 2) {
                        return 'Last name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Age
                  _buildTextField(
                    controller: ageController,
                    label: 'Age',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      int? age = int.tryParse(value);
                      if (age == null || age < 18 || age > 65) {
                        return 'Age must be between 18 and 65';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Phone
                  _buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 11) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password
                  _buildPasswordField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isVisible: isPasswordVisible,
                    onVisibilityChanged: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Confirm Password
                  _buildPasswordField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isVisible: isConfirmPasswordVisible,
                    onVisibilityChanged: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // Medical Information Section
                  _buildSectionTitle('Medical Information'),
                  SizedBox(height: 16),

                  // Blood Group
                  _buildDropdown(
                    value: selectedBloodGroup,
                    items: bloodGroups,
                    label: 'Blood Group',
                    icon: Icons.bloodtype,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBloodGroup = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 30),

                  // Location Information Section
                  _buildSectionTitle('Location Information'),
                  SizedBox(height: 16),

                  // Division
                  _buildDropdown(
                    value: selectedDivision,
                    items: divisionDistricts.keys.toList(),
                    label: 'Division',
                    icon: Icons.location_city,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDivision = newValue;
                        selectedDistrict = null;
                        selectedSubDistrict = null;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // District
                  _buildDropdown(
                    value: selectedDistrict,
                    items: getDistrictsForDivision(selectedDivision),
                    label: 'District',
                    icon: Icons.location_on,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue;
                        selectedSubDistrict = null;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Sub District
                  _buildDropdown(
                    value: selectedSubDistrict,
                    items: getSubDistrictsForDistrict(selectedDistrict),
                    label: 'Sub District / Upazila',
                    icon: Icons.place,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSubDistrict = newValue;
                      });
                    },
                    isRequired: false,
                  ),
                  SizedBox(height: 40),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: InkWell(
                            onTap: showLoginPagE,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
            filled: true,
            prefixIcon: Icon(icon, color: Colors.red),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[50],
            filled: true,
            prefixIcon: Icon(icon, color: Colors.red),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onVisibilityChanged,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required void Function(String?) onChanged,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[50],
            filled: true,
            prefixIcon: Icon(icon, color: Colors.red),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: isRequired ? (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          } : null,
          hint: Text('Select $label'),
        ),
      ],
    );
  }
}




















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'login_page.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//
//   String? selectedBloodGroup;
//   String? selectedDivision;
//   String? selectedDistrict;
//   String? selectedSubDistrict;
//
//   bool isLoading = false;
//   bool isDataLoaded = false;
//   bool isCheckingEmail = false;
//   String? currentUserEmail; // Store current user's email
//
//   // Blood group options
//   final List<String> bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
//   ];
//
//   // Bangladesh divisions and districts
//   final Map<String, List<String>> divisionDistricts = {
//     'Dhaka': [
//       'Dhaka', 'Faridpur', 'Gazipur', 'Gopalganj', 'Kishoreganj',
//       'Madaripur', 'Manikganj', 'Munshiganj', 'Narayanganj', 'Narsingdi',
//       'Rajbari', 'Shariatpur', 'Tangail'
//     ],
//     'Chittagong': [
//       'Bandarban', 'Brahmanbaria', 'Chandpur', 'Chittagong', 'Comilla',
//       'Cox\'s Bazar', 'Feni', 'Khagrachhari', 'Lakshmipur', 'Noakhali',
//       'Rangamati'
//     ],
//     'Rajshahi': [
//       'Bogura', 'Chapainawabganj', 'Joypurhat', 'Naogaon', 'Natore',
//       'Pabna', 'Rajshahi', 'Sirajganj'
//     ],
//     'Khulna': [
//       'Bagerhat', 'Chuadanga', 'Jessore', 'Jhenaidah', 'Khulna',
//       'Kushtia', 'Magura', 'Meherpur', 'Narail', 'Satkhira'
//     ],
//     'Sylhet': [
//       'Habiganj', 'Moulvibazar', 'Sunamganj', 'Sylhet'
//     ],
//     'Barisal': [
//       'Barguna', 'Barisal', 'Bhola', 'Jhalokati', 'Patuakhali', 'Pirojpur'
//     ],
//     'Rangpur': [
//       'Dinajpur', 'Gaibandha', 'Kurigram', 'Lalmonirhat', 'Nilphamari',
//       'Panchagarh', 'Rangpur', 'Thakurgaon'
//     ],
//     'Mymensingh': [
//       'Jamalpur', 'Mymensingh', 'Netrakona', 'Sherpur'
//     ],
//   };
//
//   // Sample sub-districts (you can expand this)
//   final Map<String, Map<String, List<String>>> districtSubDistricts = {
//     'Dhaka': {
//       'Dhaka': ['Dhamrai','Dohar','Keraniganj','Nawabganj','Savar'],
//       'Faridpur': ['Alfadanga','Bhanga','Boalmari','Char Bhadrasan','Faridpur Sadar','Madhukhali','Nagarkanda','Sadarpur','Saltha'],
//       'Gazipur': ['Gazipur Sadar','Kaliakoir','Kaliganj','Kapasia','Sreepur'],
//       'Gopalganj': ['Gopalganj Sadar','Kashiani','Kotalipara','Muksudpur','Tungipara'],
//       'Kishoreganj': ['Kishoreganj Sadar','Itna','Karimganj','Pakundia','Bajitpur','Bhairab','Mithamain','Nikli','Kuliarchar','Hossainpur'],
//       'Madaripur': ['Madaripur Sadar','Rajoir','Shibchar','Kalkini','Dasar'],
//       'Manikganj': ['Manikganj Sadar','Saturia','Shivalaya','Singair'],
//       'Munshiganj': ['Munshiganj Sadar','Sirajdikhan','Sreenagar','Lohajong','Gajaria','Tongibari'],
//       'Narayanganj': ['Narayanganj Sadar','Araihazar','Bandar','Rupganj','Sonargaon'],
//       'Narsingdi': ['Narsingdi Sadar','Belabo','Monohardi','Palash','Raipura','Shibpur'],
//       'Rajbari': ['Rajbari Sadar','Baliakandi','Goalanda','Kalukhali','Pangsha'],
//       'Shariatpur': ['Shariatpur Sadar','Naria','Jajira','Gosairhat','Damudya','Bhedarganj'],
//       'Tangail': ['Tangail Sadar','Basail','Bhuapur','Delduar','Dhanbari','Ghatail','Gopalpur','Kalihati','Madhupur','Mirzapur','Nagarpur','Sakhipur']
//     },
//     'Sylhet': {
//       'Sylhet': ['Sylhet Sadar','Beanibazar','Balaganj','Dakshin Surma','Companiganj','Fenchuganj','Golapganj','Gowainghat','Jaintiapur','Kanaighat','Osmani Nagar','Zakiganj'],
//       'Habiganj': ['Habiganj Sadar','Ajmiriganj','Bahubal','Baniachong','Chunarughat','Lakhai','Madhabpur','Nabiganj','Shaistaganj'],
//       'Moulvibazar': ['Moulvibazar Sadar','Barlekha','Kamalganj','Kulaura','Rajnagar','Sreemangal','Sreemangal','Zakiganj'],
//       'Sunamganj': ['Sunamganj Sadar','Dakshin Sunamganj','Chhatak','Dharampasha','Derai','Dhubaura','Jamalgonj','Jagannathpur','Shantiganj']
//     },
//     'Chittagong': {
//       'Bandarban': [
//         'Bandarban Sadar', 'Lama', 'Naikhongchhari', 'Ruma',
//         'Rowangchhari', 'Thanchi'
//       ],
//       'Brahmanbaria': [
//         'Brahmanbaria Sadar', 'Ashuganj', 'Bancharampur',
//         'Bijoynagar', 'Brahmanpara', 'Kasba', 'Nabinagar',
//         'Sarail'
//       ],
//       'Chandpur': [
//         'Chandpur Sadar', 'Faridganj', 'Haimchar', 'Haziganj',
//         'Kachua', 'Matlab Dakshin', 'Matlab Uttar', 'Shahrasti'
//       ],
//       'Chittagong': [
//         'Anwara','Banshkhali','Boalkhali','Chandanaish','Fatikchhari',
//         'Hathazari','Lohagara','Mirsharai','Patiya','Rangunia',
//         'Raozan','Sandwip','Satkania','Sitakunda','Karnaphuli'
//       ],
//       'Comilla': [
//         'Comilla Sadar', 'Barura','Brahmanpara','Chandina',
//         'Chauddagram','Daudkandi','Debidwar','Homna',
//         'Laksham','Meghna','Muradnagar','Nangalkot','Titas'
//       ],
//       'Cox\'s Bazar': [
//         'Cox\'s Bazar Sadar','Chakaria','Kutubdia','Maheshkhali',
//         'Ramu','Teknaf','Ukhia','Pekua'
//       ],
//       'Feni': ['Feni Sadar','Fulgazi','Parshuram','Sonagazi'],
//       'Khagrachhari': [
//         'Khagrachhari Sadar','Dighinala','Guimara','Matiranga',
//         'Panchhari','Rangamati–Bandarban Road'
//       ],
//       'Lakshmipur': [
//         'Lakshmipur Sadar','Raipur','Ramganj','Ramgoti',
//         'Kamolganj'
//       ],
//       'Noakhali': [
//         'Noakhali Sadar','Begumganj','Chatkhil','Hatiya',
//         'Kabirhat','Senbagh','Sonaimuri','Subarnachar'
//       ],
//       'Rangamati': [
//         'Rangamati Sadar','Barkal','Belaichhari','Kaptai',
//         'Juraichhari','Rajasthali','Bagaichhari','Barkal'
//       ],
//     },
//
//     'Rajshahi': {
//       'Bogura': [
//         'Adamdighi', 'Bogra Sadar', 'Dhunat', 'Dhupchanchia', 'Gabtali',
//         'Kahaloo', 'Nandigram', 'Sariakandi', 'Shajahanpur', 'Sherpur', 'Sonatala'
//       ],
//       'Chapainawabganj': [
//         'Bholahat', 'Gomostapur', 'Nachole', 'Chapainawabganj Sadar', 'Shibganj'
//       ],
//       'Joypurhat': [
//         'Akkelpur', 'Joypurhat Sadar', 'Kalai', 'Khetlal', 'Panchbibi'
//       ],
//       'Naogaon': [
//         'Atrai', 'Badalgachhi', 'Dhamoirhat', 'Manda', 'Mahadebpur',
//         'Naogaon Sadar', 'Niamatpur', 'Patnitala', 'Porsha', 'Raninagar', 'Sapahar'
//       ],
//       'Natore': [
//         'Bagatipara', 'Baraigram', 'Gurudaspur', 'Lalpur', 'Natore Sadar', 'Singra'
//       ],
//       'Pabna': [
//         'Atgharia', 'Bera', 'Bhangura', 'Chatmohar', 'Faridpur', 'Ishwardi',
//         'Pabna Sadar', 'Santhia', 'Sujanagar'
//       ],
//       'Rajshahi': [
//         'Bagha', 'Bagmara', 'Boalia', 'Charghat', 'Durgapur',
//         'Godagari', 'Mohanpur', 'Paba', 'Puthia', 'Rajpara', 'Shah Makhdum'
//       ],
//       'Sirajganj': [
//         'Belkuchi', 'Chauhali', 'Kamarkhanda', 'Kazipur', 'Raiganj',
//         'Shahjadpur', 'Sirajganj Sadar', 'Tarash', 'Ullapara'
//       ],
//     },
//     'Khulna': {
//       'Bagerhat': [
//         'Bagerhat Sadar', 'Chitalmari', 'Fakirhat', 'Kachua',
//         'Mollahat', 'Mongla', 'Morrelganj', 'Rampal', 'Sharankhola'
//       ],
//       'Chuadanga': [
//         'Alamdanga', 'Chuadanga Sadar', 'Damurhuda', 'Jibannagar'
//       ],
//       'Jessore': [
//         'Jessore Sadar', 'Abhaynagar', 'Bagherpara', 'Chaugachha',
//         'Jhikargacha', 'Keshabpur', 'Manirampur', 'Sharsha'
//       ],
//       'Jhenaidah': [
//         'Harinakundu', 'Jhenaidah Sadar', 'Kaliganj',
//         'Kotchandpur', 'Maheshpur', 'Shailkupa'
//       ],
//       'Khulna': [
//         'Batiaghata', 'Dacope', 'Dighalia', 'Dumuria', 'Terokhada',
//         'Phultala', 'Paikgachha', 'Rupsa', 'Khalishpur', 'Sonadanga', 'Daulatpur'
//       ],
//       'Kushtia': [
//         'Bheramara', 'Daulatpur', 'Khoksa', 'Kumarkhali',
//         'Kushtia Sadar', 'Mirpur'
//       ],
//       'Magura': [
//         'Magura Sadar', 'Mohammadpur', 'Shalikha', 'Sreepur'
//       ],
//       'Meherpur': [
//         'Gangni', 'Meherpur Sadar', 'Mujibnagar'
//       ],
//       'Narail': [
//         'Kalia', 'Lohagara', 'Narail Sadar'
//       ],
//       'Satkhira': [
//         'Assasuni', 'Debhata', 'Kalaroa', 'Kaliganj',
//         'Satkhira Sadar', 'Shyamnagar', 'Tala'
//       ]
//     },
//     'Barisal': {
//       'Barguna': [
//         'Amtali', 'Bamna', 'Barguna Sadar', 'Betagi', 'Patharghata', 'Taltali'
//       ],
//       'Barisal': [
//         'Barisal Sadar', 'Agailjhara', 'Bakerganj', 'Banaripara',
//         'Babuganj', 'Gournadi', 'Hizla', 'Mehendiganj', 'Muladi', 'Wazirpur'
//       ],
//       'Bhola': [
//         'Bhola Sadar', 'Borhanuddin', 'Char Fasson', 'Daulatkhan',
//         'Lalmohan', 'Manpura', 'Tazumuddin'
//       ],
//       'Jhalokati': [
//         'Jhalokati Sadar', 'Kathalia', 'Nalchity', 'Rajapur'
//       ],
//       'Patuakhali': [
//         'Bauphal', 'Dashmina', 'Dumki', 'Galachipa',
//         'Kalapara', 'Mirzaganj', 'Patuakhali Sadar'
//       ],
//       'Pirojpur': [
//         'Bhandaria', 'Kawkhali', 'Mathbaria', 'Nazirpur',
//         'Nesarabad', 'Pirojpur Sadar', 'Zianagar'
//       ],
//     },
//
//     'Rangpur': {
//       'Dinajpur': [
//         'Birampur', 'Birganj', 'Biral', 'Bochaganj', 'Chirirbandar',
//         'Dinajpur Sadar', 'Ghoraghat', 'Hakimpur', 'Khansama', 'Nawabganj', 'Parbatipur', 'Kaharole', 'Fulbari'
//       ],
//       'Gaibandha': [
//         'Fulchhari', 'Gaibandha Sadar', 'Gobindaganj', 'Palashbari',
//         'Sadullapur', 'Saghata', 'Sundarganj'
//       ],
//       'Kurigram': [
//         'Bhurungamari', 'Chilmari', 'Phulbari', 'Kurigram Sadar',
//         'Nageshwari', 'Rajarhat', 'Raomari', 'Ulipur', 'Char Rajibpur'
//       ],
//       'Lalmonirhat': [
//         'Aditmari', 'Hatibandha', 'Kaliganj', 'Lalmonirhat Sadar', 'Patgram'
//       ],
//       'Nilphamari': [
//         'Dimla', 'Domar', 'Jaldhaka', 'Kishoreganj',
//         'Nilphamari Sadar', 'Saidpur'
//       ],
//       'Panchagarh': [
//         'Atwari', 'Boda', 'Debiganj', 'Panchagarh Sadar', 'Tetulia'
//       ],
//       'Rangpur': [
//         'Rangpur Sadar', 'Badarganj', 'Kaunia', 'Gangachara',
//         'Mithapukur', 'Taraganj', 'Pirganj', 'Pirgacha'
//       ],
//       'Thakurgaon': [
//         'Thakurgaon Sadar', 'Baliadangi', 'Haripur', 'Pirganj', 'Ranisankail'
//       ],
//     },
//
//     'Mymensingh': {
//       'Jamalpur': [
//         'Jamalpur Sadar', 'Bakshiganj', 'Dewanganj', 'Islampur',
//         'Madarganj', 'Melandaha', 'Sarishabari'
//       ],
//       'Mymensingh': [
//         'Mymensingh Sadar', 'Muktagacha', 'Bhaluka', 'Haluaghat',
//         'Gafargaon', 'Gouripur', 'Trishal', 'Ishwarganj',
//         'Nandail', 'Phulpur', 'Fulbaria', 'Dhobaura'
//       ],
//       'Netrakona': [
//         'Netrakona Sadar', 'Atpara', 'Barhatta', 'Durgapur',
//         'Khaliajuri', 'Kalmakanda', 'Kendua', 'Madan', 'Mohanganj', 'Purbadhala'
//       ],
//       'Sherpur': [
//         'Sherpur Sadar', 'Nalitabari', 'Jhenaigati',
//         'Nakla', 'Sreebardi'
//       ],
//     }
//     // অন্যান বিভাগগুলো চাইলে এখানে যুক্ত করা যাবে
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }
//
//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     ageController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }
//
//   // Check if email already exists (excluding current user)
//   Future<bool> checkEmailExists(String email) async {
//     try {
//       // Skip check if email hasn't changed
//       if (email == currentUserEmail) {
//         return false;
//       }
//
//       // Check in Firebase Auth
//       final List<String> signInMethods = await FirebaseAuth.instance
//           .fetchSignInMethodsForEmail(email);
//
//       if (signInMethods.isNotEmpty) {
//         return true;
//       }
//
//       // Check in Firestore (excluding current user)
//       final User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('email', isEqualTo: email)
//             .where(FieldPath.documentId, isNotEqualTo: currentUser.uid)
//             .limit(1)
//             .get();
//
//         return querySnapshot.docs.isNotEmpty;
//       }
//
//       return false;
//     } catch (e) {
//       print('Error checking email: $e');
//       return false;
//     }
//   }
//
//   Future<void> loadUserData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();
//
//         if (userDoc.exists) {
//           Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//
//           firstNameController.text = userData['firstName'] ?? '';
//           lastNameController.text = userData['lastName'] ?? '';
//           ageController.text = userData['age']?.toString() ?? '';
//           emailController.text = userData['email'] ?? '';
//           phoneController.text = userData['phone'] ?? '';
//
//           selectedBloodGroup = userData['bloodGroup'];
//           selectedDivision = userData['division'];
//           selectedDistrict = userData['district'];
//           selectedSubDistrict = userData['subDistrict'];
//
//           // Store current user's email
//           currentUserEmail = userData['email'];
//         }
//       }
//     } catch (e) {
//       _showErrorDialog('Error loading user data: ${e.toString()}');
//     } finally {
//       setState(() {
//         isLoading = false;
//         isDataLoaded = true;
//       });
//     }
//   }
//
//   Future<void> updateProfile() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     if (selectedBloodGroup == null) {
//       _showErrorDialog('Please select a blood group');
//       return;
//     }
//
//     if (selectedDivision == null) {
//       _showErrorDialog('Please select a division');
//       return;
//     }
//
//     if (selectedDistrict == null) {
//       _showErrorDialog('Please select a district');
//       return;
//     }
//
//     // Check for email duplication
//     setState(() {
//       isCheckingEmail = true;
//     });
//
//     bool emailExists = await checkEmailExists(emailController.text.trim());
//
//     setState(() {
//       isCheckingEmail = false;
//     });
//
//     if (emailExists) {
//       _showErrorDialog('This email is already registered by another user');
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .update({
//           'firstName': firstNameController.text.trim(),
//           'lastName': lastNameController.text.trim(),
//           'age': int.parse(ageController.text.trim()),
//           'email': emailController.text.trim(),
//           'phone': phoneController.text.trim(),
//           'bloodGroup': selectedBloodGroup,
//           'division': selectedDivision,
//           'district': selectedDistrict,
//           'subDistrict': selectedSubDistrict,
//           'updatedAt': FieldValue.serverTimestamp(),
//         });
//
//         _showSuccessDialog('Profile updated successfully!');
//
//         // Go back to previous screen after 2 seconds
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pop(context);
//         });
//       }
//     } catch (e) {
//       _showErrorDialog('Error updating profile: ${e.toString()}');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Success'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<String> getDistrictsForDivision(String? division) {
//     if (division == null) return [];
//     return divisionDistricts[division] ?? [];
//   }
//
//   List<String> getSubDistrictsForDistrict(String? district) {
//     if (district == null) return [];
//     if (selectedDivision == null) return [];
//
//     // Get the division's district-subdistrict mapping
//     Map<String, List<String>> divisionSubDistricts = districtSubDistricts[selectedDivision!] ?? {};
//     return divisionSubDistricts[district] ?? [];
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: GoogleFonts.poppins(
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         color: Colors.red,
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.red),
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.red, width: 2),
//         ),
//         labelStyle: TextStyle(color: Colors.grey[600]),
//       ),
//     );
//   }
//
//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//     required IconData icon,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.red),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.red, width: 2),
//         ),
//         labelStyle: TextStyle(color: Colors.grey[600]),
//       ),
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//     );
//   }
//
//   Future SignOut()async{
//     Fluttertoast.showToast(
//         msg: "SignOut",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.CENTER
//     );
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context)=> LoginPage())
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: (isLoading || isCheckingEmail) ? null : updateProfile,
//           ),
//           IconButton
//             (
//               onPressed: SignOut,
//               icon: Icon(Icons.logout)
//           ),
//         ],
//       ),
//       body: isLoading && !isDataLoaded
//           ? Center(child: CircularProgressIndicator())
//           : SafeArea(
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Profile Header
//                   Center(
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.red,
//                           child: Icon(
//                             Icons.person,
//                             size: 60,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Edit Your Profile',
//                           style: GoogleFonts.poppins(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Update your information',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 30),
//
//                   // Personal Information Section
//                   _buildSectionTitle('Personal Information'),
//                   SizedBox(height: 16),
//
//                   // First Name
//                   _buildTextField(
//                     controller: firstNameController,
//                     label: 'First Name',
//                     icon: Icons.person,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your first name';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//
//                   // Last Name
//                   _buildTextField(
//                     controller: lastNameController,
//                     label: 'Last Name',
//                     icon: Icons.person_outline,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your last name';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//
//                   // Age
//                   _buildTextField(
//                     controller: ageController,
//                     label: 'Age',
//                     icon: Icons.calendar_today,
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your age';
//                       }
//                       int? age = int.tryParse(value);
//                       if (age == null || age < 1 || age > 120) {
//                         return 'Please enter a valid age';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//
//                   // Blood Group
//                   _buildDropdown(
//                     label: 'Blood Group',
//                     value: selectedBloodGroup,
//                     items: bloodGroups,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedBloodGroup = value;
//                       });
//                     },
//                     icon: Icons.bloodtype,
//                   ),
//                   SizedBox(height: 24),
//
//                   // Contact Information Section
//                   _buildSectionTitle('Contact Information'),
//                   SizedBox(height: 16),
//
//                   // Email
//                   _buildTextField(
//                     controller: emailController,
//                     label: 'Email',
//                     icon: Icons.email,
//                     keyboardType: TextInputType.emailAddress,
//                     suffixIcon: isCheckingEmail
//                         ? SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                       ),
//                     )
//                         : null,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                           .hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//
//                   // Phone
//                   _buildTextField(
//                     controller: phoneController,
//                     label: 'Phone',
//                     icon: Icons.phone,
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       if (value.length < 10) {
//                         return 'Please enter a valid phone number';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 24),
//
//                   // Location Information Section
//                   _buildSectionTitle('Location Information'),
//                   SizedBox(height: 16),
//
//                   // Division
//                   _buildDropdown(
//                     label: 'Division',
//                     value: selectedDivision,
//                     items: divisionDistricts.keys.toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedDivision = value;
//                         selectedDistrict = null;
//                         selectedSubDistrict = null;
//                       });
//                     },
//                     icon: Icons.location_on,
//                   ),
//                   SizedBox(height: 16),
//
//                   // District
//                   _buildDropdown(
//                     label: 'District',
//                     value: selectedDistrict,
//                     items: getDistrictsForDivision(selectedDivision),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedDistrict = value;
//                         selectedSubDistrict = null;
//                       });
//                     },
//                     icon: Icons.location_city,
//                   ),
//                   SizedBox(height: 16),
//
//                   // Sub-District (Optional)
//                   if (selectedDistrict != null)
//                     _buildDropdown(
//                       label: 'Sub-District (Optional)',
//                       value: selectedSubDistrict,
//                       items: getSubDistrictsForDistrict(selectedDistrict),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedSubDistrict = value;
//                         });
//                       },
//                       icon: Icons.place,
//                     ),
//                   SizedBox(height: 30),
//
//                   // Update Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: (isLoading || isCheckingEmail)
//                           ? null
//                           : updateProfile,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: isLoading
//                           ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor:
//                               AlwaysStoppedAnimation<Color>(
//                                   Colors.white),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text('Updating...'),
//                         ],
//                       )
//                           : isCheckingEmail
//                           ? Row(
//                         mainAxisAlignment:
//                         MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor:
//                               AlwaysStoppedAnimation<Color>(
//                                   Colors.white),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text('Checking Email...'),
//                         ],
//                       )
//                           : Text(
//                         'Update Profile',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }