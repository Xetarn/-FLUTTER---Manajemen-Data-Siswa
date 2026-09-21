import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.chalk,
      appBar: AppBar(
        title: const Text(
          'Tentang aplikasi',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTokens.board,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Buku induk siswa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pengganti lemari berkas ruang tata usaha. Semua catatan kelas tersusun dalam satu buku yang selalu ikut dibawa.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTokens.rule),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  _AboutRow(
                    icon: Icons.layers_outlined,
                    label: 'Dibangun dengan',
                    value: 'Flutter, Dart, Supabase',
                  ),
                  Divider(indent: 16, endIndent: 16, height: 1),
                  _AboutRow(
                    icon: Icons.key_outlined,
                    label: 'Dibuka oleh',
                    value: 'Admin tata usaha',
                  ),
                  Divider(indent: 16, endIndent: 16, height: 1),
                  _AboutRow(
                    icon: Icons.tag_outlined,
                    label: 'Edisi',
                    value: '1.0.0',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTokens.rule),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(18),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cara memakai',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Buka data siswa untuk mencari nama atau NIS, saring menurut jurusan dan kelas, lalu tambah catatan baru lewat tombol Tambah. Tarik ke bawah kapan saja untuk memuat ulang dari arsip.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTokens.muted,
                      height: 1.6,
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

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _AboutRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTokens.chalk,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTokens.rule),
            ),
            child: Icon(icon, size: 20, color: AppTokens.board),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppTokens.muted,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
