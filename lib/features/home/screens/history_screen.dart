import 'package:flutter/material.dart';
import 'package:elangkuy/services/api_service.dart';
import 'package:elangkuy/models/penawaran_model.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<PenawaranResponse> _historyFuture;
  String _searchQuery = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _historyFuture = ApiService.getPenawaranHistory();
  }

  Future<void> _refreshData() async {
    setState(() {
      _historyFuture = ApiService.getPenawaranHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  FutureBuilder<PenawaranResponse>(
                    future: _historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingActivitySummary();
                      } else if (snapshot.hasError) {
                        return _buildErrorActivitySummary(
                          snapshot.error.toString(),
                        );
                      } else if (snapshot.hasData) {
                        return _buildActivitySummary(snapshot.data!.stats);
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildAuctionHistoryHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  FutureBuilder<PenawaranResponse>(
                    future: _historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingHistoryItems();
                      } else if (snapshot.hasError) {
                        return _buildErrorHistoryItems(
                          snapshot.error.toString(),
                        );
                      } else if (snapshot.hasData) {
                        final filteredItems = _filterHistoryItems(
                          snapshot.data!.items,
                          _searchQuery,
                          _filter,
                        );
                        return _buildHistoryItems(filteredItems);
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 100), // Extra space for bottom nav
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingActivitySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Lelang',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildShimmerActivityCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerActivityCard()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildShimmerActivityCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerActivityCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerActivityCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 100,
    );
  }

  Widget _buildErrorActivitySummary(String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Lelang',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Gagal memuat data: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySummary(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Lelang',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                'Dimenangkan',
                stats['won'].toString(),
                const Color(0xFF4154F1),
                Icons.workspace_premium,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                'Diselesaikan',
                stats['completed'].toString(),
                Colors.green,
                Icons.check_circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                'Dibatalkan',
                stats['banned'].toString(),
                Colors.red,
                Icons.cancel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                'Pengembalian',
                stats['refund'].toString(),
                const Color(0xFF2E3A8A),
                Icons.replay,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard(
    String title,
    String count,
    Color iconColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Riwayat Penawaran',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: _showFilterDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Filter Riwayat'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'all'),
              child: const Text('Semua'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'win'),
              child: const Text('Menang'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'unpaid'),
              child: const Text('Belum Dibayar'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'completed'),
              child: const Text('Selesai'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'banned'),
              child: const Text('Kalah'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _filter = result;
      });
    }
  }

  Widget _buildLoadingHistoryItems() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 80,
        ),
      ),
    );
  }

  Widget _buildErrorHistoryItems(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Gagal memuat riwayat: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  List<Penawaran> _filterHistoryItems(
    List<Penawaran> items,
    String searchQuery,
    String filter,
  ) {
    List<Penawaran> filtered = items;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (item) => item.lelang.barang.namaBarang.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    // Apply status filter
    switch (filter) {
      case 'win':
        filtered = filtered.where((item) => item.statusTawar == 'win').toList();
        break;
      case 'unpaid':
        filtered =
            filtered
                .where(
                  (item) => item.statusTawar == 'win' && item.statusBs == null,
                )
                .toList();
        break;
      case 'completed':
        filtered =
            filtered.where((item) => item.statusBs == 'dikonfirmasi').toList();
        break;
      case 'banned':
        filtered =
            filtered.where((item) => item.statusTawar == 'banned').toList();
        break;
      default:
        break;
    }

    return filtered;
  }

  Widget _buildHistoryItems(List<Penawaran> items) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('Tidak ada riwayat penawaran')),
      );
    }

    return Column(
      children: items.map((item) => _buildHistoryItem(item)).toList(),
    );
  }

  void _showBidDetails(Penawaran item) {
    final dateFormat = DateFormat('dd MMM yyyy HH:mm');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Detail Penawaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Bid details
                _buildDetailRow('Nama Barang', item.lelang.barang.namaBarang),
                _buildDetailRow(
                  'Kategori',
                  item.lelang.barang.kategori?.namaKategori ?? '-',
                ),
                _buildDetailRow(
                  'Harga Awal',
                  _formatCurrency(item.lelang.barang.hargaAwal),
                ),
                _buildDetailRow(
                  'Tawaran Anda',
                  _formatCurrency(item.penawaranHarga),
                ),
                _buildDetailRow('Uang Muka', _formatCurrency(item.uangMuka)),
                if (item.bayarSisa != null)
                  _buildDetailRow(
                    'Pembayaran Sisa',
                    _formatCurrency(item.bayarSisa!),
                  ),
                _buildDetailRow(
                  'Waktu Penawaran',
                  dateFormat.format(DateTime.parse(item.waktu)),
                ),
                if (item.waktuBs != null)
                  _buildDetailRow(
                    'Waktu Pembayaran',
                    dateFormat.format(DateTime.parse(item.waktuBs!)),
                  ),
                _buildDetailRow(
                  'Status Penawaran',
                  _getStatusText(item),
                  textColor: _getStatusColor(item),
                ),
                _buildDetailRow(
                  'Status Lelang',
                  _getAuctionStatusText(item.lelang.status),
                ),
                const SizedBox(height: 30),

                // Action buttons
                if (item.statusTawar == 'win' && item.statusBs == null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4154F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Add your payment logic here
                      },
                      child: const Text(
                        'Bayar Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF4154F1)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Color(0xFF4154F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _getStatusText(Penawaran item) {
    if (item.statusBs == 'dikonfirmasi') return 'Selesai';
    if (item.statusTawar == 'win' && item.statusBs == null)
      return 'Menang (Belum Dibayar)';
    if (item.statusTawar == 'win') return 'Menang';
    if (item.statusTawar == 'banned') return 'Kalah';
    return 'Sedang Diproses';
  }

  String _getAuctionStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'dibuka':
        return 'Sedang Berlangsung';
      case 'ditutup':
        return 'Selesai';
      default:
        return '-';
    }
  }

  Widget _buildDetailRow(String title, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Penawaran item) {
    return GestureDetector(
      onTap: () => _showBidDetails(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.lelang.barang.namaBarang,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(item.penawaranHarga),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              item.getStatusText(),
              style: TextStyle(
                color: _getStatusColor(item),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(Penawaran item) {
    if (item.statusBs == 'dikonfirmasi') return Colors.green;
    if (item.statusTawar == 'win' && item.statusBs == null)
      return Colors.orange;
    if (item.statusTawar == 'win') return const Color(0xFF4154F1);
    if (item.statusTawar == 'banned') return Colors.red;
    return Colors.grey.shade600;
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
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
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Keep your existing _buildAppBar method
  Widget _buildAppBar() {
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
          ],
        ),
      ],
    );
  }
}
