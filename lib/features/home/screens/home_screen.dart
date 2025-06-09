import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_screen.dart';
import 'product_detail_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'package:elangkuy/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const HistoryPage(),
    const PlaceholderPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex == 2 ? 0 : _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: _buildCenterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildFloatingBottomNavigationBar(),
    );
  }

  Widget _buildFloatingBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Center(
                  child: Image.asset(
                    'assets/images/history.png',
                    width: 28,
                    height: 28,
                    color:
                        _selectedIndex == 1
                            ? const Color(0xFF6A7BFF)
                            : Colors.grey,
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
                child: Center(
                  child: Image.asset(
                    'assets/images/user.png',
                    width: 24,
                    height: 24,
                    color:
                        _selectedIndex == 3
                            ? const Color(0xFF6A7BFF)
                            : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF4154F1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4154F1).withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Image.asset(
          'assets/images/home_icon.png',
          width: 28,
          height: 28,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
    );
  }
}

class Barang {
  final String id;
  final String title;
  final String condition;
  final String price;
  final String image;
  final String? kategori;

  Barang({
    required this.id,
    required this.title,
    required this.condition,
    required this.price,
    required this.image,
    this.kategori,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id_barang'].toString(),
      title: json['nama_barang'],
      condition: json['kondisi'] == 'Baru' ? 'Baru' : 'Bekas',
      price:
          'Rp. ${json['harga_awal'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
      image: 'http://192.168.0.101:8000/storage/${json['foto_utama']}',
      kategori: json['kategori']?['nama_kategori'],
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<Barang>> _barangFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _barangFuture = _fetchBarang();
  }

  Future<List<Barang>> _fetchBarang() async {
    try {
      final token = await AuthService.getToken();
      print('Token saat fetch barang: $token'); // Add this line
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await http.get(
        Uri.parse('http://192.168.0.101:8000/api/barang/approved-pembeli'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}'); // Add this line
      print('Response body: ${response.body}'); // Add this line

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> items = data['data']['items'];
        return items.map((item) => Barang.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _fetchBarang: $e'); // Add this line
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newData = await _fetchBarang();
      setState(() {
        _barangFuture = Future.value(newData);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildAppBar(context),
                  const SizedBox(height: 16),
                  _buildSearchBar(context),
                  const SizedBox(height: 16),
                  _buildPromoBanner(),
                  const SizedBox(height: 20),
                  _buildCategoryGrid(),
                  const SizedBox(height: 24),
                  _buildAuctionSection(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF4154F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/e_logo2.png',
              width: 22,
              height: 22,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/chat.png',
                  width: 20,
                  height: 20,
                  color: const Color(0xFF2E3A8A),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/notification.png',
                        width: 20,
                        height: 20,
                        color: const Color(0xFF2E3A8A),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '12',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/search.png',
                width: 18,
                height: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text(
                'Search',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/promo_banner2.png',
        height: 164,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Fashion', 'image': 'assets/images/fashion.png'},
      {'name': 'Elektronik', 'image': 'assets/images/electronic.png'},
      {'name': 'Furnitur', 'image': 'assets/images/furniture.png'},
      {'name': 'Aksesoris', 'image': 'assets/images/aksesoris.png'},
      {'name': 'Lain-lain', 'image': 'assets/images/lain_lain.png'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          categories.map((category) {
            return Column(
              children: [
                Image.asset(category['image'] as String, width: 50, height: 50),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildAuctionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lelang Pilihan',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildAuctionGrid(context),
      ],
    );
  }

  Widget _buildAuctionGrid(BuildContext context) {
    return FutureBuilder<List<Barang>>(
      future: _barangFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Gagal memuat data',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: _refreshData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final auctions = snapshot.data!;
          if (auctions.isEmpty) {
            return const Center(child: Text('Tidak ada data lelang tersedia'));
          }
          return Column(
            children: [
              for (var i = 0; i < auctions.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: _buildAuctionItem(context, auctions[i])),
                      const SizedBox(width: 12),
                      Expanded(
                        child:
                            i + 1 < auctions.length
                                ? _buildAuctionItem(context, auctions[i + 1])
                                : const SizedBox(),
                      ),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildAuctionItem(BuildContext context, Barang barang) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(
                  title: barang.title,
                  image: barang.image,
                  price: barang.price,
                  condition: barang.condition,
                  barangId: barang.id,
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                barang.image,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barang.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    barang.condition,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3A8A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      barang.price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Placeholder')));
  }
}
