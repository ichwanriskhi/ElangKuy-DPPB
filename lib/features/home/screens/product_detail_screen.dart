import 'package:flutter/material.dart';
import 'package:elangkuy/services/api_service.dart';
import 'package:elangkuy/models/barang_model.dart' as barang_model;
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final String barangId;

  const ProductDetailScreen({super.key, required this.barangId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String nominalTawaran = '';
  String uangMuka = '';
  int selectedImageIndex = 0;
  late Future<barang_model.BarangDetail> _barangFuture;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSubmitting = false;

  // Add this controller
  final TextEditingController _nominalTawaranController =
      TextEditingController();
  final TextEditingController _uangMukaController = TextEditingController();

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final parsedValue = int.tryParse(cleanValue) ?? 0;
    return NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    ).format(parsedValue);
  }

  int _parseCurrency(String value) {
    if (value.isEmpty) return 0;
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleanValue) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _barangFuture = _fetchBarangDetail();

    // Add listener to automatically calculate down payment
    _nominalTawaranController.addListener(_calculateDownPayment);
  }

  @override
  void dispose() {
    _nominalTawaranController.dispose();
    _uangMukaController.dispose();
    super.dispose();
  }

  void _calculateDownPayment() {
    if (_nominalTawaranController.text.isEmpty) {
      setState(() {
        uangMuka = '';
        _uangMukaController.text = '';
      });
      return;
    }

    try {
      final nominal = _parseCurrency(_nominalTawaranController.text);
      final downPayment = (nominal * 0.1).round(); // 10% of bid amount

      setState(() {
        uangMuka = downPayment.toString();
        _uangMukaController.text = _formatCurrency(downPayment.toString());
      });
    } catch (e) {
      setState(() {
        uangMuka = '';
        _uangMukaController.text = '';
      });
    }
  }

  Future<void> _submitBid() async {
    if (_nominalTawaranController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal tawaran terlebih dahulu'),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });

      final nominal = _parseCurrency(_nominalTawaranController.text);
      final downPayment = _parseCurrency(_uangMukaController.text);

      final barang = await _barangFuture;
      final lelangId = barang.lelang?['id_lelang']?.toString();

      if (lelangId == null) {
        throw Exception('Lelang tidak tersedia');
      }

      final result = await ApiService.submitBid(
        lelangId: lelangId,
        penawaranHarga: nominal,
        uangMuka: downPayment,
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<barang_model.BarangDetail> _fetchBarangDetail() async {
    try {
      final barang = await ApiService.getBarangDetail(widget.barangId);
      setState(() {
        _isLoading = false;
      });
      return barang;
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      throw e;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final newData = await _fetchBarangDetail();
      setState(() {
        _barangFuture = Future.value(newData);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<barang_model.BarangDetail>(
        future: _barangFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Muat Ulang'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data barang tidak ditemukan'));
          }

          final barang = snapshot.data!;
          final fotoArray = barang.foto;
          final mainImage =
              barang.fotoUtama.isNotEmpty
                  ? barang.fotoUtama
                  : 'default-product.png';
          final hargaAwalFormatted = currencyFormat.format(barang.hargaAwal);
          final hargaAkhir =
              int.tryParse(barang.lelang?['harga_akhir']?.toString() ?? '0') ??
              0;
          final hargaAkhirFormatted =
              hargaAkhir > 0 ? currencyFormat.format(hargaAkhir) : 'Rp. 0';
          final penjualNama = barang.penjual['nama'] ?? 'Tidak diketahui';
          final penjualFoto = barang.penjual['foto'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(mainImage, fotoArray),
                if (fotoArray.length > 1) _buildThumbnailRow(fotoArray),
                _buildProductTitleSection(
                  barang.namaBarang,
                  barang.kategori['nama_kategori'] ?? '',
                  barang.lokasiTampil,
                  barang.kondisi,
                ),
                _buildPriceSection(hargaAwalFormatted, hargaAkhirFormatted),
                _buildBiddingSection(),
                _buildDescriptionSection(barang.deskripsi),
                _buildSellerSection(penjualNama, penjualFoto),
                _buildReviewsSection(),
                _buildDiscussionSection(),
                _buildDivider(),
                _buildSimilarProductsSection(
                  context,
                  barang.kategori['id_kategori'] ?? '',
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildImageSection(String mainImage, List<String> fotoArray) {
    // Tentukan gambar yang akan ditampilkan berdasarkan selectedImageIndex
    final displayImage =
        fotoArray.isNotEmpty ? fotoArray[selectedImageIndex] : mainImage;

    return Stack(
      children: [
        Container(
          height: 330,
          width: double.infinity,
          color: Colors.white,
          child: Image.network(
            '${ApiService.imageBaseUrl}$displayImage', // Ganti dari mainImage ke displayImage
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
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
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              fotoArray.length, // Ganti dari 4 ke fotoArray.length
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

  Widget _buildThumbnailRow(List<String> fotoArray) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fotoArray.length,
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
                  child: Image.network(
                    '${ApiService.imageBaseUrl}${fotoArray[index]}',
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

  Widget _buildProductTitleSection(
    String title,
    String kategori,
    String lokasi,
    String kondisi,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                kategori,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                lokasi,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                kondisi,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(String hargaAwal, String hargaAkhir) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Harga Awal',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Tawaran Tertinggi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hargaAwal,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                  child: Text(
                    hargaAkhir,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
              controller: _nominalTawaranController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Silakan masukkan tawaran anda...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                // Format the input as currency
                final formattedValue = _formatCurrency(value);
                _nominalTawaranController.value = TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(
                    offset: formattedValue.length,
                  ),
                );
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
              controller: _uangMukaController,
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: '10% dari nominal tawaran...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String deskripsi) {
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
          Text(
            deskripsi,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerSection(String penjualNama, String? penjualFoto) {
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
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    penjualFoto != null
                        ? NetworkImage('${ApiService.imageBaseUrl}$penjualFoto')
                        : null,
                child:
                    penjualFoto == null
                        ? const Icon(Icons.person, size: 20)
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      penjualNama,
                      style: const TextStyle(
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
          _buildReviewCard(
            name: 'Suzanna Advania',
            comment: 'Penjual amanah, recommended banget...',
            rating: 5,
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            name: 'Hudsonia Gerunica',
            comment: 'Trusted',
            rating: 5,
          ),
          const SizedBox(height: 24),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/43.jpg',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          _buildDiscussionItem(
            name: 'Haryono',
            comment: 'Pemakalan berapa lama?',
            time: '2 Hari Lalu',
          ),
          const SizedBox(height: 16),
          _buildDiscussionItem(
            name: 'Alexander',
            comment: 'Kayanya bagus barangnya',
            time: '2 Hari Lalu',
          ),
          const SizedBox(height: 16),
          _buildDiscussionItem(
            name: 'Stewart John',
            comment: 'Saya minat juga',
            time: '2 Hari Lalu',
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(24),
            ),
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ajukan Pertanyaan...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const Icon(Icons.send, color: Color(0xFF4154F1), size: 20),
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          margin: const EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: const Icon(Icons.person, color: Colors.grey, size: 20.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• $time',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
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

  Widget _buildSimilarProductsSection(BuildContext context, String kategoriId) {
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
            child: FutureBuilder<List<barang_model.Barang>>(
              future: ApiService.getSimilarProducts(kategoriId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada produk serupa'));
                }

                final similarProducts = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.only(right: 16),
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    final product = similarProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildSimilarProductItem(
                        context,
                        product.namaBarang,
                        product.kondisi,
                        product.hargaFormatted,
                        product.fotoUtama,
                        product.idBarang,
                      ),
                    );
                  },
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
    String productId,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(barangId: productId),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(vertical: 4),
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
                '${ApiService.imageBaseUrl}$image',
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
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

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitBid,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4154F1),
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child:
            _isSubmitting
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Text(
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
