import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import 'login_page.dart';
import 'about_page.dart';
import 'data_siswa_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  String? errorMessage;

  int totalSiswa = 0;
  int jumlahLakiLaki = 0;
  int jumlahPerempuan = 0;
  Map<String, int> jumlahPerKelas = {};
  String? emailAdmin;

  @override
  void initState() {
    super.initState();
    emailAdmin = supabase.auth.currentUser?.email;
    getStatistik();
  }

  Future<void> getStatistik() async {
    try {
      final data = await supabase.from('siswa').select();
      int lakiLaki = 0;
      int perempuan = 0;
      Map<String, int> kelas = {};
      for (final siswa in data) {
        final jenisKelamin = siswa['jenis_kelamin']?.toString();
        final namaKelas = siswa['kelas']?.toString();
        if (jenisKelamin == 'Laki-laki') {
          lakiLaki++;
        } else if (jenisKelamin == 'Perempuan') {
          perempuan++;
        }
        if (namaKelas != null && namaKelas.isNotEmpty) {
          kelas[namaKelas] = (kelas[namaKelas] ?? 0) + 1;
        }
      }
      if (!mounted) return;
      setState(() {
        totalSiswa = data.length;
        jumlahLakiLaki = lakiLaki;
        jumlahPerempuan = perempuan;
        jumlahPerKelas = kelas;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar dari arsip?'),
          content: const Text(
            'Kamu harus masuk lagi untuk membuka buku induk.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.stamp,
                minimumSize: const Size(100, 44),
              ),
              onPressed: () async {
                await supabase.auth.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstName =
        emailAdmin?.split('@').first ?? 'Admin';

    return Scaffold(
      backgroundColor: AppTokens.chalk,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Arsip tidak bisa dibuka',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage!,
                            style: const TextStyle(
                                color: AppTokens.muted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                errorMessage = null;
                              });
                              getStatistik();
                            },
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppTokens.board,
                  onRefresh: getStatistik,
                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Header band
                        Container(
                          width: double.infinity,
                          color: AppTokens.board,
                          padding: const EdgeInsets.fromLTRB(
                              24, 56, 24, 24),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Halo, $firstName',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight:
                                                FontWeight.w800,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          emailAdmin ??
                                              'Ruang tata usaha',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(
                                                    alpha: 0.68),
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Keluar',
                                    onPressed: () =>
                                        logout(context),
                                    icon: const Icon(
                                      Icons.logout_outlined,
                                      color: Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white
                                            .withValues(
                                                alpha: 0.3),
                                      ),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$totalSiswa',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 64,
                                      fontWeight:
                                          FontWeight.w800,
                                      height: 1,
                                      letterSpacing: -2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      'siswa\ntercatat',
                                      style: TextStyle(
                                        color: Color(0xFFB9C4BC),
                                        fontSize: 14,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              // Proportional composition bar
                              if (totalSiswa > 0)
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: jumlahLakiLaki == 0
                                            ? 1
                                            : jumlahLakiLaki,
                                        child: Container(
                                          height: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        flex: jumlahPerempuan == 0
                                            ? 1
                                            : jumlahPerempuan,
                                        child: Container(
                                          height: 8,
                                          color:
                                              AppTokens.mustard,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (totalSiswa > 0)
                                const SizedBox(height: 10),
                              if (totalSiswa > 0)
                                Text(
                                  '$jumlahLakiLaki laki-laki dan $jumlahPerempuan perempuan',
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                        alpha: 0.75),
                                    fontSize: 13.5,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Ledger sheet
                        Padding(
                          padding:
                              const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // Primary action as ledger row
                              _LedgerNav(
                                title: 'Buka data siswa',
                                desc:
                                    'Cari, saring, tambah, dan perbarui catatan',
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DataSiswaPage(),
                                    ),
                                  );
                                  getStatistik();
                                },
                              ),
                              const SizedBox(height: 22),
                              Text(
                                'Rombongan belajar (${jumlahPerKelas.length})',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTokens.ink,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color:
                                          AppTokens.rule),
                                  borderRadius:
                                      BorderRadius.circular(
                                          14),
                                ),
                                child: jumlahPerKelas.isEmpty
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.all(
                                                20),
                                        child: Text(
                                          'Belum ada rombel. Tambahkan siswa dulu lewat menu data siswa.',
                                          style: TextStyle(
                                            color: AppTokens
                                                .muted,
                                            height: 1.5,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          for (var i = 0;
                                              i <
                                                  jumlahPerKelas
                                                      .entries
                                                      .length;
                                              i++)
                                            Builder(builder:
                                                (context) {
                                              final entry =
                                                  jumlahPerKelas
                                                      .entries
                                                      .elementAt(
                                                          i);
                                              final last = i ==
                                                  jumlahPerKelas
                                                          .length -
                                                      1;
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal:
                                                                16,
                                                            vertical:
                                                                13),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:
                                                              4,
                                                          height:
                                                              28,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppTokens
                                                                .spineFor(_jurusanOf(
                                                                    entry
                                                                        .key)),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    2),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                                12),
                                                        Expanded(
                                                          child:
                                                              Text(
                                                            entry
                                                                .key,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    15),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${entry.value} anak',
                                                          style:
                                                              nisStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!last)
                                                    const Divider(
                                                      indent:
                                                          16,
                                                      endIndent:
                                                          16,
                                                      height: 1,
                                                    ),
                                                ],
                                              );
                                            }),
                                        ],
                                      ),
                              ),
                              const SizedBox(height: 22),
                              const Text(
                                'Lainnya',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTokens.ink,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color:
                                          AppTokens.rule),
                                  borderRadius:
                                      BorderRadius.circular(
                                          14),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons
                                          .info_outline),
                                      title: const Text(
                                          'Tentang aplikasi'),
                                      subtitle: const Text(
                                        'Versi 1.0.0 untuk admin',
                                        style: TextStyle(
                                            color: AppTokens
                                                .muted),
                                      ),
                                      trailing: const Icon(
                                        Icons.chevron_right,
                                        color:
                                            AppTokens.muted,
                                      ),
                                      onTap: () =>
                                          Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AboutPage(),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      indent: 16,
                                      endIndent: 16,
                                      height: 1,
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.logout_outlined,
                                        color:
                                            AppTokens.stamp,
                                      ),
                                      title: const Text(
                                        'Keluar',
                                        style: TextStyle(
                                            color: AppTokens
                                                .stamp),
                                      ),
                                      onTap: () =>
                                          logout(context),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Tarik ke bawah untuk memuat ulang dari arsip.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  String _jurusanOf(String kelas) {
    if (kelas.contains('PPLG')) return 'PPLG';
    if (kelas.contains('FM')) return 'FM';
    if (kelas.contains('AK')) return 'AK';
    return '';
  }
}

class _LedgerNav extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback onTap;

  const _LedgerNav({
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTokens.rule),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTokens.board,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.folder_open_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppTokens.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTokens.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
