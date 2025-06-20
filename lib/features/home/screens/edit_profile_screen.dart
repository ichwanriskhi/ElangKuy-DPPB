import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:elangkuy/services/api_service.dart';
import 'package:elangkuy/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  String? _selectedBank;
  final List<String> _banks = [
    'BCA',
    'BRI',
    'Mandiri',
    'BNI',
    'CIMB Niaga',
    'Permata',
    'Danamon',
    'Panin'
  ];

  File? _selectedImage;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final response = await ApiService.getProfile();
    
    if (response['success'] == true) {
      final data = response['data'];
      setState(() {
        _nameController.text = data['nama'] ?? '';
        _phoneController.text = data['telepon'] ?? '';
        _addressController.text = data['alamat'] ?? '';
        _selectedBank = data['bank'];
        _accountNumberController.text = data['no_rekening'] ?? '';
        _currentPhotoUrl = data['foto'];
        _isInitialized = true;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    // Validasi input
    if (_nameController.text.isEmpty) {
      _showErrorSnackbar('Nama lengkap harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService.updateProfile(
      nama: _nameController.text,
      telepon: _phoneController.text.isEmpty ? null : _phoneController.text,
      alamat: _addressController.text.isEmpty ? null : _addressController.text,
      bank: _selectedBank,
      noRekening: _accountNumberController.text.isEmpty 
          ? null 
          : _accountNumberController.text,
      foto: _selectedImage,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success'] == true) {
      _showSuccessSnackbar('Profil berhasil diperbarui');
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      String errorMessage = response['message'] ?? 'Gagal memperbarui profil';
      if (response['errors'] != null) {
        errorMessage += '\n' + 
          response['errors'].entries.map((e) => 
            '${e.key}: ${e.value.join(', ')}').join('\n');
      }
      _showErrorSnackbar(errorMessage);
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          height: maxLines == 1 ? 40 : null,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF4154F1), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedBank,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Pilih bank',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              items: _banks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank, style: TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBank = newValue;
                });
              },
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF4154F1),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Edit Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              _isLoading
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : TextButton.icon(
                      onPressed: _saveProfile,
                      icon: Icon(Icons.save_outlined, 
                        color: Colors.white, size: 20),
                      label: Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF4154F1),
                          Color(0xFF4154F1).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: MediaQuery.of(context).size.width / 2 - 50,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : _currentPhotoUrl != null
                                        ? NetworkImage('${ApiService.imageBaseUrl}$_currentPhotoUrl')
                                        : null,
                                child: _selectedImage == null && _currentPhotoUrl == null
                                    ? Icon(Icons.camera_alt, 
                                        size: 40, color: Colors.grey)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF4154F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Color(0xFF4154F1),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Data Diri',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Form Fields
                    _buildTextField(
                      label: 'Nama Lengkap',
                      controller: _nameController,
                      hint: 'Masukkan nama lengkap',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      label: 'Nomor HP',
                      controller: _phoneController,
                      hint: '+62 812 3456 7890',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      label: 'Alamat',
                      controller: _addressController,
                      hint: 'Masukkan alamat lengkap',
                      maxLines: 3,
                    ),
                    SizedBox(height: 24),

                    // Banking Section
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Rekening Pencairan Dana',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    _buildBankDropdown(),
                    SizedBox(height: 16),

                    _buildTextField(
                      label: 'Nomor Rekening',
                      controller: _accountNumberController,
                      hint: 'Masukkan nomor rekening',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 120), // Extra space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}