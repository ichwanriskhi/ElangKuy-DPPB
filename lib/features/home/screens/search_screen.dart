import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Example recent searches
  final List<String> recentSearches = [
    'MacBook Pro M2',
    'Iphone 15 128',
    'Asus VivoBook 15',
    'Zenbook duo',
    'Lampu belajar',
  ];

  // Updated popular searches with correct products to match the image
  final List<Map<String, dynamic>> popularSearches = [
    {'title': 'Monitor Gaming', 'image': 'assets/images/monitor.png'},
    {'title': 'Iphone 15', 'image': 'assets/images/iphone.png'},
    {'title': 'Lenovo Ideapad 5', 'image': 'assets/images/laptop.png'},
    {'title': 'MacBook Pro', 'image': 'assets/images/macbook.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar with back button and filter
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/back.png',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Search field
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: TextField(
                          controller: _searchController,
                          // Tambahkan textAlignVertical untuk mengatur posisi teks secara vertikal
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Ketik sesuatu...',
                            border: InputBorder.none,
                            // Tambahkan vertical padding untuk balancing
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0, // Tambahkan padding vertikal
                            ),
                            // Gunakan isDense untuk lebih mengontrol layout
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? IconButton(
                                      padding:
                                          EdgeInsets
                                              .zero, // Hapus padding dari icon
                                      constraints:
                                          BoxConstraints(), // Hindari constraint tambahan
                                      icon: const Icon(Icons.clear, size: 16),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                    : null,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Filter button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/filter.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Recent searches section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pencarian Terbaru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Recent search items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            recentSearches[index],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              recentSearches.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Popular searches section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pencarian Populer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Popular search grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: popularSearches.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          // 🔁 Ganti width dari 60 jadi 70 agar gambar tidak terlalu sempit
                          SizedBox(
                            width: 70,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(7),
                              ),
                              child: Image.asset(
                                popularSearches[index]['image'],
                                fit: BoxFit.contain,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              // 🔁 Ganti Text biasa jadi Column dengan split teks per kata
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    popularSearches[index]['title']
                                        .toString()
                                        .split(' ')
                                        .map(
                                          (word) => Text(
                                            word,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
