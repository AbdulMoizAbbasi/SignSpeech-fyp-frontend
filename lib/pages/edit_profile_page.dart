import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String? _selectedGender;
  String? _selectedBirthYear;
  bool _isLoading = false;
  bool _isLoadingData = true;

  // Generate list of years
  final List<String> _years = List.generate(
    DateTime.now().year - 1900 + 1,
    (index) => (1900 + index).toString(),
  ).reversed.toList();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            nameController.text = userDoc['name'] ?? '';
            emailController.text = currentUser.email ?? '';
            _selectedGender = userDoc['gender'];
            _selectedBirthYear = userDoc['birthYear']?.toString();
          });
        } else {
          emailController.text = currentUser.email ?? '';
        }
      }
    } catch (e) {
      _showError("Failed to load profile: ${e.toString()}");
    } finally {
      setState(() => _isLoadingData = false);
    }
  }

  Future<void> _updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      _showError("Name cannot be empty");
      return;
    }

    if (_selectedGender == null || _selectedBirthYear == null) {
      _showError("Please select your gender and year of birth");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .update({
              "name": nameController.text.trim(),
              "gender": _selectedGender,
              "birthYear": _selectedBirthYear,
            });

        _showSuccess("Profile updated successfully");
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      _showError("Failed to update profile: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_isLoadingData) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // BACKGROUND HEADER
          Container(
            height: size.height * 0.25,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BCD4), Color(0xFF01579B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Back Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // Title
                  const Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FORM CONTENT
          Container(
            margin: EdgeInsets.only(top: size.height * 0.20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Name Field
                  _buildFormCard(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: const TextStyle(color: Color(0xFF01579B)),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF01579B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF00BCD4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF01579B),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email Field (Read-only)
                  _buildFormCard(
                    child: TextField(
                      controller: emailController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gender Dropdown
                  _buildFormCard(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: const TextStyle(color: Color(0xFF01579B)),
                        prefixIcon: const Icon(
                          Icons.wc,
                          color: Color(0xFF01579B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF00BCD4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF01579B),
                            width: 2,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedGender = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Birth Year Dropdown
                  _buildFormCard(
                    child: DropdownButtonFormField<String>(
                      value: _selectedBirthYear,
                      decoration: InputDecoration(
                        labelText: "Year of Birth",
                        labelStyle: const TextStyle(color: Color(0xFF01579B)),
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF01579B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF00BCD4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF01579B),
                            width: 2,
                          ),
                        ),
                      ),
                      items: _years
                          .map(
                            (year) => DropdownMenuItem(
                              value: year,
                              child: Text(year),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedBirthYear = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00BCD4), Color(0xFF0288D1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0288D1).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _isLoading ? null : _updateProfile,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "SAVE CHANGES",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
