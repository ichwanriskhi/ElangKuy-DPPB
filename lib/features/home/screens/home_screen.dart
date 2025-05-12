import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'product_detail_screen.dart';
import 'history_screen.dart';  // Import the actual history screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const HistoryPage(),  // Using the real HistoryPage from history_screen.dart
    const PlaceholderPage(), // This is a placeholder for the center button
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // Important to allow content to extend behind bottom nav
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index:
            _selectedIndex == 2
                ? 0
                : _selectedIndex, // Always show home when center button is pressed
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

            // History Button
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

            // Profile Button
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
          color: Colors.white, // optional, apply tint if needed
        ),
        onPressed: () {
          setState(() {
            _selectedIndex = 0; // Go to home
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildAppBar(),
                const SizedBox(height: 16),
                _buildSearchBar(context),
                const SizedBox(height: 16),
                _buildPromoBanner(),
                const SizedBox(height: 20),
                _buildCategoryGrid(),
                const SizedBox(height: 24),
                _buildAuctionSection(context),
                const SizedBox(
                  height: 100,
                ), // Extra space at bottom for nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildAppBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Logo di kiri
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
      // Row untuk ikon-ikon di kanan (Chat dan Notification)
      Row(
        children: [
          // Icon Chat
          Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.only(right: 10), // Jarak antara icon chat dan notification
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
                'assets/images/chat.png', // Pastikan asset ini tersedia
                width: 20,
                height: 20,
                color: Color(0xFF2E3A8A),
              ),
            ),
          ),
          // Icon Notification dengan badge
          Stack(
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
                    color: Color(0xFF2E3A8A),
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
                color: Colors.grey, // hapus kalau ikonnya sudah berwarna
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
    final auctions = [
      {
        'title': 'Iphone 13',
        'condition': 'Bekas',
        'price': 'Rp. 8.000.000',
        'image': 'assets/images/iphone13.jpg',
      },
      {
        'title': 'Asus VivoBook 14',
        'condition': 'Bekas',
        'price': 'Rp. 5.000.000',
        'image': 'assets/images/asus_vivobook.jpg',
      },
      {
        'title': 'Infinix Note 40',
        'condition': 'Bekas',
        'price': 'Rp. 1.500.000',
        'image': 'assets/images/infinix_note40.jpg',
      },
      {
        'title': 'Lampu Belajar',
        'condition': 'Bekas',
        'price': 'Rp. 30.000',
        'image': 'assets/images/lampu_belajar.jpg',
      },
      {
        'title': 'YSL Tribute Shoes',
        'condition': 'Bekas',
        'price': 'Rp. 5.500.000',
        'image': 'assets/images/ysl_shoes.jpg',
      },
      {
        'title': 'Iphone 15',
        'condition': 'Bekas',
        'price': 'Rp. 7.000.000',
        'image': 'assets/images/iphone15.jpg',
      },
    ];

    return Column(
      children: [
        for (var i = 0; i < auctions.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildAuctionItem(
                    context,
                    auctions[i]['title'] as String,
                    auctions[i]['condition'] as String,
                    auctions[i]['price'] as String,
                    auctions[i]['image'] as String,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      i + 1 < auctions.length
                          ? _buildAuctionItem(
                            context,
                            auctions[i + 1]['title'] as String,
                            auctions[i + 1]['condition'] as String,
                            auctions[i + 1]['price'] as String,
                            auctions[i + 1]['image'] as String,
                          )
                          : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAuctionItem(
    BuildContext context,
    String title,
    String condition,
    String price,
    String image,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(
                  title: title,
                  image: image,
                  price: price,
                  condition: condition,
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
              child: Image.asset(
                image,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    condition,
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
                      price,
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

// Placeholder pages for the remaining tabs
// Remove the HistoryPage placeholder as we're using the real one now

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Placeholder')));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Halaman Profil')));
  }
}