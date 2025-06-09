import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'history_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // Adding controllers for bank and account number
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  // List of banks for dropdown
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profil', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: const Color(0xFF4154F1),
              child: const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/nailong.jpg'),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data Diri',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: 'Masukkan Nama',
                          border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text('Email',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: 'Masukkan Email',
                          border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text('No. HP',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          hintText: 'Masukkan No. HP',
                          border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  Text('Alamat',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          hintText: 'Masukkan Alamat',
                          border: OutlineInputBorder())),
                  SizedBox(height: 10),

                  // Add Rekening Pencairan Dana section
                  Text('Rekening Pencairan Dana',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),

                  // Bank dropdown
                  Text('Bank', style: TextStyle(fontSize: 14)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedBank,
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Pilih bank'),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        items: _banks.map((String bank) {
                          return DropdownMenuItem<String>(
                            value: bank,
                            child: Text(bank),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBank = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Account number text field
                  Text('Nomor Rekening', style: TextStyle(fontSize: 14)),
                  TextField(
                    controller: _accountNumberController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nomor rekening anda',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 20),
                  // Simpan button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika untuk menyimpan data disini
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data berhasil disimpan')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4154F1),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Simpan', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100), // Extra space at bottom for nav bar
          ],
        ),
      ),
    );
  }
}