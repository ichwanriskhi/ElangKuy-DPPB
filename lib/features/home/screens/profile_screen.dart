import 'package:flutter/material.dart';
import 'package:elangkuy/features/home/screens/edit_profile_screen.dart';
import 'package:elangkuy/features/home/screens/home_screen.dart';
import 'package:elangkuy/services/api_service.dart';
import 'package:elangkuy/services/auth_service.dart';
import 'package:elangkuy/features/auth/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Di ProfilePage - Method _handleLogout() (sekitar baris 33-50)
  // Ganti method ini dengan kode berikut:

  Future<void> _handleLogout() async {
    // Tampilkan dialog konfirmasi
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Ya, Logout'),
            ),
          ],
        );
      },
    );

    if (confirmLogout != true) return;

    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await ApiService.logout();

      // Tutup loading dialog
      Navigator.of(context).pop();

      if (response['success'] == true) {
        // Clear authentication data
        await AuthService.logout();

        // Navigate to login screen dan hapus semua route sebelumnya
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout berhasil'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Gagal logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Tutup loading dialog jika error
      Navigator.of(context).pop();

      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await ApiService.getProfile();

    if (response['success'] == true) {
      setState(() {
        _userData = response['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Gagal memuat data profil';
      });
    }
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    ).then((_) {
      // Refresh data setelah kembali dari edit profile
      _fetchProfileData();
    });
  }

  void _handleBackButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Widget _buildDisplayField({
    required String label,
    required String? value,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value ?? '-',
            style: TextStyle(
              fontSize: 14,
              color: value == null ? Colors.grey[400] : Colors.grey[800],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _handleBackButton,
            ),
            title: Text(
              'Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: _navigateToEditProfile,
                icon: Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                label: Text(
                  'Edit Profil',
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
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  _userData?['foto'] != null
                                      ? NetworkImage(
                                        '${ApiService.imageBaseUrl}${_userData?['foto']}',
                                      )
                                      : AssetImage(
                                            'assets/images/blank-profile-picture.png',
                                          )
                                          as ImageProvider,
                              backgroundColor: Colors.white,
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
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 60,
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
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

                            // Display Fields
                            _buildDisplayField(
                              label: 'Nama Lengkap',
                              value: _userData?['nama'],
                            ),
                            SizedBox(height: 16),

                            _buildDisplayField(
                              label: 'Email',
                              value: _userData?['email'],
                            ),
                            SizedBox(height: 16),

                            _buildDisplayField(
                              label: 'Nomor HP',
                              value: _userData?['telepon'],
                            ),
                            SizedBox(height: 16),

                            _buildDisplayField(
                              label: 'Alamat',
                              value: _userData?['alamat'],
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

                            _buildDisplayField(
                              label: 'Bank',
                              value: _userData?['bank'],
                            ),
                            SizedBox(height: 16),

                            _buildDisplayField(
                              label: 'Nomor Rekening',
                              value: _userData?['no_rekening'],
                            ),
                            SizedBox(height: 16),

                            // Add logout button
                            GestureDetector(
                              onTap: _handleLogout,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red[100]!),
                                ),
                                child: Center(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 60,
                            ), // Extra space for bottom navigation
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
