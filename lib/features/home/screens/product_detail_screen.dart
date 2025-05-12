import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final String title;
  final String image;
  final String price;
  final String condition;

  const ProductDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.condition,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String nominalTawaran = '';
  String uangMuka = '';
  int selectedImageIndex = 0;

  final List<String> thumbnails = [
    'assets/images/iphone13.jpg',
    'assets/images/iphone13-3.jpg',
    'assets/images/iphone13-2.jpg',
    'assets/images/iphone13-1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildThumbnailRow(),
            _buildProductTitleSection(),
            _buildPriceSection(),
            _buildBiddingSection(),
            _buildDescriptionSection(),
            _buildSellerSection(),
            _buildReviewsSection(),
            _buildDiscussionSection(),
            _buildDivider(),
            _buildSimilarProductsSection(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Main image
        Container(
          height: 330,
          width: double.infinity,
          color: Colors.white,
          child: Image.asset(thumbnails[selectedImageIndex], fit: BoxFit.cover),
        ),

        // Back button
        Positioned(
          top: 40,
          left: 16,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(134, 82, 82, 82),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Image indicator dots at bottom
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              thumbnails.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == selectedImageIndex ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      index == selectedImageIndex
                          ? const Color(0xFF4154F1)
                          : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailRow() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: thumbnails.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder:
            (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedImageIndex = index;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        selectedImageIndex == index
                            ? const Color(0xFF4154F1)
                            : Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    thumbnails[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildProductTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Iphone 13 128 GB iBox',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              const Text(
                'Elektronik',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Text(
                ' ',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Text(
                'Telkom University Bandung',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Text(
                ' ',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Text(
                'Baru',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Harga Awal dan Tawaran Tertinggi
          Row(
            children: [
              Expanded(
                child: Text(
                  'Harga Awal',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Tawaran Tertinggi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Kotak Harga
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Rp. 8.000.000',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Rp. 8.500.000',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nominal Tawaran',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Silakan masukkan tawaran anda...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  nominalTawaran = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Uang Muka',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Minimal 10% dari nominal tawaran yang diajukan...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  uangMuka = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Barang',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Fitur-fitur utama :',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('Layar Super Retina XDR 6,1 inci'),
          _buildFeatureItem(
            'Sistem kamera canggih untuk foto yang lebih baik dalam berbagai kondisi pencahayaan',
          ),
          _buildFeatureItem(
            'Mode Sinematik kini dalam Dolby Vision 4K pada kecepatan hingga 30 fps',
          ),
          _buildFeatureItem('Mode Aksi untuk video handheld yang stabil'),
          _buildFeatureItem(
            'Fitur keselamatan penting, —Deteksi Tabrakan memanggil bantuan saat Anda tak bisa',
          ),
          _buildFeatureItem(
            'Kekuatan baterai sepanjang hari dan pemutaran video hingga 20 jam',
          ),
          _buildFeatureItem(
            'Chip A15 Bionic dengan GPU 5-core untuk performa secepat kilat. Seluler 5G super cepat',
          ),
          _buildFeatureItem(
            ' Fitur ketahanan terdepan di industri dengan Ceramic Shield dan tahan air',
          ),
          _buildFeatureItem(
            ' iOS 16 menawarkan semakin banyak cara untuk personalisasi, komunikasi, dan berbagi',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil Penjual',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dewangga Saputra',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4154F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFF4154F1), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        color: const Color(0xFF4154F1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ulasan Terbaru',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Card Ulasan 1
          _buildReviewCard(
            name: 'Suzanna Advania',
            comment: 'Penjual amanah, recommended banget...',
            rating: 5,
          ),
          const SizedBox(height: 16),

          // Card Ulasan 2
          _buildReviewCard(
            name: 'Hudsonia Gerunica',
            comment: 'Trusted',
            rating: 5,
          ),
          const SizedBox(height: 24),

          // Tombol Lihat Semua
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Lihat semua ulasan',
                style: TextStyle(
                  color: Color(0xFF4154F1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String comment,
    required int rating,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris untuk profil, nama, dan rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil kecil (CircleAvatar)
              const CircleAvatar(
                radius: 16, // Ukuran profil kecil
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/43.jpg', // URL gambar profil
                ),
              ),
              const SizedBox(width: 8), // Jarak antara profil dan nama
              // Kolom untuk nama dan komentar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris untuk nama dan rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 16,
                              color:
                                  index < rating
                                      ? const Color(0xFFFFD700)
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Komentar
                    Text(
                      comment,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diskusi Barang',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Item Diskusi 1
          _buildDiscussionItem(
            name: 'Haryono',
            comment: 'Pemakalan berapa lama?',
            time: '2 Hari Lalu',
            avatarUrl: null, // You can replace with actual URL if available
          ),
          const SizedBox(height: 16),

          // Item Diskusi 2
          _buildDiscussionItem(
            name: 'Alexander',
            comment: 'Kayanya bagus barangnya',
            time: '2 Hari Lalu',
            avatarUrl: null, // You can replace with actual URL if available
          ),
          const SizedBox(height: 16),

          // Item Diskusi 3
          _buildDiscussionItem(
            name: 'Stewart John',
            comment: 'Saya minat juga',
            time: '2 Hari Lalu',
            avatarUrl: null, // You can replace with actual URL if available
          ),

          const SizedBox(height: 24),

          // Input Pertanyaan
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(24),
            ),
            height: 40, // Match the action bar button height
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ajukan Pertanyaan...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Icon(Icons.send, color: const Color(0xFF4154F1), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionItem({
    required String name,
    required String comment,
    required String time,
    String? avatarUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Icon
        Container(
          width: 36.0,
          height: 36.0,
          margin: const EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            image:
                avatarUrl != null
                    ? DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              avatarUrl == null
                  ? Icon(Icons.person, color: Colors.grey.shade400, size: 20.0)
                  : null,
        ),

        // Content Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama dan Waktu dalam satu baris
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold, // Nama lebih tebal
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• $time', // Tambahkan bullet point
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Komentar
              Text(
                comment,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(height: 1, color: Colors.grey.withOpacity(0.2)),
    );
  }

  Widget _buildSimilarProductsSection(BuildContext context) {
    // Data untuk produk serupa
    final similarProducts = [
      {
        'title': 'iPhone 12 Pro',
        'condition': 'Bekas',
        'price': 'Rp. 7.500.000',
        'image': 'assets/images/iphone13.jpg',
      },
      {
        'title': 'iPhone 14',
        'condition': 'Bekas',
        'price': 'Rp. 10.000.000',
        'image': 'assets/images/iphone15.jpg',
      },
      {
        'title': 'Samsung S22',
        'condition': 'Bekas',
        'price': 'Rp. 6.800.000',
        'image': 'assets/images/infinix_note40.jpg',
      },
      {
        'title': 'Pixel 7',
        'condition': 'Bekas',
        'price': 'Rp. 7.200.000',
        'image': 'assets/images/asus_vivobook.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Produk Serupa',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior:
                  Clip.none, // Ini solusi utama untuk shadow yang terpotong
              padding: const EdgeInsets.only(
                right: 16,
              ), // Memberi ruang di akhir list
              itemCount: similarProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildSimilarProductItem(
                    context,
                    similarProducts[index]['title'] as String,
                    similarProducts[index]['condition'] as String,
                    similarProducts[index]['price'] as String,
                    similarProducts[index]['image'] as String,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarProductItem(
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
        width: 160,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ), // Memberi ruang untuk shadow atas/bawah
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.1,
              ), // Meningkatkan opacity shadow
              blurRadius: 5, // Meningkatkan blur radius
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
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

  // Widget _buildRelatedProductsSection() {
  //   final relatedProducts = [
  //     {
  //       'title': 'Iphone 14 Pro',
  //       'condition': 'Bekas',
  //       'price': 'Rp. 12.500.000',
  //       'image': 'assets/images/iphone14.jpg',
  //     },
  //     {
  //       'title': 'Macbook Air M1',
  //       'condition': 'Bekas',
  //       'price': 'Rp. 10.000.000',
  //       'image': 'assets/images/macbook_air.jpg',
  //     },
  //     {
  //       'title': 'Samsung S23 Ultra',
  //       'condition': 'Bekas',
  //       'price': 'Rp. 11.000.000',
  //       'image': 'assets/images/samsung_s23.jpg',
  //     },
  //     {
  //       'title': 'AirPods Pro 2',
  //       'condition': 'Bekas',
  //       'price': 'Rp. 2.500.000',
  //       'image': 'assets/images/airpods_pro.jpg',
  //     },
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 24),
  //       const SizedBox(height: 24),
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16),
  //         child: Text(
  //           'Produk Terkait',
  //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Column(
  //         children: relatedProducts.map((product) {
  //           return Padding(
  //             padding: const EdgeInsets.only(bottom: 16),
  //             child: _buildRelatedProductCard(
  //               context,
  //               product['title'] as String,
  //               product['condition'] as String,
  //               product['price'] as String,
  //               product['image'] as String,
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildRelatedProductCard(
  //   BuildContext context,
  //   String title,
  //   String condition,
  //   String price,
  //   String image,
  // ) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ProductDetailScreen(
  //             title: title,
  //             image: image,
  //             price: price,
  //             condition: condition,
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.1),
  //             blurRadius: 5,
  //             spreadRadius: 1,
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               bottomLeft: Radius.circular(12),
  //             ),
  //             child: Image.asset(
  //               image,
  //               width: 120,
  //               height: 120,
  //               fit: BoxFit.cover,
  //               errorBuilder: (context, error, stackTrace) => Container(
  //                 width: 120,
  //                 height: 120,
  //                 color: Colors.grey.shade200,
  //                 child: const Icon(Icons.image, color: Colors.grey),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(12),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 14,
  //                     ),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     condition,
  //                     style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 8,
  //                       vertical: 4,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFF2E3A8A),
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                     child: Text(
  //                       price,
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     blurRadius: 6,
        //     offset: const Offset(0, -2),
        //   ),
        // ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4154F1),
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Ikut Lelang',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
