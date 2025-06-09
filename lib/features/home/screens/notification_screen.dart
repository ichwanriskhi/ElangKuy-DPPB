import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A8A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Implement mark all as read functionality
            },
            child: const Text(
              'Tandai semua dibaca',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4154F1),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4154F1),
          labelColor: const Color(0xFF4154F1),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Lelang'),
            Tab(text: 'Transaksi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(),
          _buildLelangNotifications(),
          _buildTransaksiNotifications(),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView(
      children: [
        _buildNotificationGroup('Hari Ini', [
          _NotificationItem(
            title: 'Penawaran Anda diterima!',
            message: 'Penawaran Anda untuk Asus Vivobook 14 sebesar Rp. 6.000.000 telah diterima oleh penjual.',
            time: '10:30',
            iconColor: const Color(0xFF4154F1),
            iconData: Icons.gavel,
            isUnread: true,
          ),
          _NotificationItem(
            title: 'Transaksi selesai',
            message: 'Transaksi Iphone 14 telah diselesaikan. Terima kasih telah menggunakan layanan kami.',
            time: '09:15',
            iconColor: Colors.green,
            iconData: Icons.check_circle,
            isUnread: false,
          ),
        ]),
        _buildNotificationGroup('Kemarin', [
          _NotificationItem(
            title: 'Lelang dibatalkan',
            message: 'Lelang untuk Acer Swift 14 telah dibatalkan oleh penjual.',
            time: 'Kemarin, 16:45',
            iconColor: Colors.red,
            iconData: Icons.cancel,
            isUnread: false,
          ),
          _NotificationItem(
            title: 'Pengingat pembayaran',
            message: 'Harap segera melakukan pembayaran untuk Asus Vivobook 14 sebelum 24 jam ke depan.',
            time: 'Kemarin, 14:20',
            iconColor: Colors.grey.shade700,
            iconData: Icons.access_time,
            isUnread: true,
          ),
        ]),
        _buildNotificationGroup('Minggu Lalu', [
          _NotificationItem(
            title: 'Item baru ditambahkan',
            message: 'Iphone 14 telah ditambahkan ke lelang dengan harga awal Rp. 6.500.000.',
            time: '10 Mei',
            iconColor: const Color(0xFF4154F1),
            iconData: Icons.notifications,
            isUnread: false,
          ),
          _NotificationItem(
            title: 'Pengembalian barang',
            message: 'Permintaan pengembalian untuk Asus Vivobook 14 telah disetujui.',
            time: '8 Mei',
            iconColor: Colors.blue.shade700,
            iconData: Icons.assignment_return,
            isUnread: false,
          ),
        ]),
      ],
    );
  }

  Widget _buildLelangNotifications() {
    return ListView(
      children: [
        _buildNotificationGroup('Hari Ini', [
          _NotificationItem(
            title: 'Penawaran Anda diterima!',
            message: 'Penawaran Anda untuk Asus Vivobook 14 sebesar Rp. 6.000.000 telah diterima oleh penjual.',
            time: '10:30',
            iconColor: const Color(0xFF4154F1),
            iconData: Icons.gavel,
            isUnread: true,
          ),
        ]),
        _buildNotificationGroup('Kemarin', [
          _NotificationItem(
            title: 'Lelang dibatalkan',
            message: 'Lelang untuk Acer Swift 14 telah dibatalkan oleh penjual.',
            time: 'Kemarin, 16:45',
            iconColor: Colors.red,
            iconData: Icons.cancel,
            isUnread: false,
          ),
        ]),
        _buildNotificationGroup('Minggu Lalu', [
          _NotificationItem(
            title: 'Item baru ditambahkan',
            message: 'Iphone 14 telah ditambahkan ke lelang dengan harga awal Rp. 6.500.000.',
            time: '10 Mei',
            iconColor: const Color(0xFF4154F1),
            iconData: Icons.notifications,
            isUnread: false,
          ),
        ]),
      ],
    );
  }

  Widget _buildTransaksiNotifications() {
    return ListView(
      children: [
        _buildNotificationGroup('Hari Ini', [
          _NotificationItem(
            title: 'Transaksi selesai',
            message: 'Transaksi Iphone 14 telah diselesaikan. Terima kasih telah menggunakan layanan kami.',
            time: '09:15',
            iconColor: Colors.green,
            iconData: Icons.check_circle,
            isUnread: false,
          ),
        ]),
        _buildNotificationGroup('Kemarin', [
          _NotificationItem(
            title: 'Pengingat pembayaran',
            message: 'Harap segera melakukan pembayaran untuk Asus Vivobook 14 sebelum 24 jam ke depan.',
            time: 'Kemarin, 14:20',
            iconColor: Colors.grey.shade700,
            iconData: Icons.access_time,
            isUnread: true,
          ),
        ]),
        _buildNotificationGroup('Minggu Lalu', [
          _NotificationItem(
            title: 'Pengembalian barang',
            message: 'Permintaan pengembalian untuk Asus Vivobook 14 telah disetujui.',
            time: '8 Mei',
            iconColor: Colors.blue.shade700,
            iconData: Icons.assignment_return,
            isUnread: false,
          ),
        ]),
      ],
    );
  }

  Widget _buildNotificationGroup(String title, List<Widget> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        ...notifications,
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final Color iconColor;
  final IconData iconData;
  final bool isUnread;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.iconColor,
    required this.iconData,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A8A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF4154F1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}