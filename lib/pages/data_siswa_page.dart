import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import 'form_siswa_page.dart';
import 'detail_siswa_page.dart';

class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

class _DataSiswaPageState extends State<DataSiswaPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> siswa = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController searchController = TextEditingController();
  String selectedJurusan = 'Semua';
  String selectedKelas = 'Semua';

  final List<String> daftarJurusan = ['Semua', 'PPLG', 'FM', 'AK'];

  @override
  void initState() {
    super.initState();
    getSiswa();
  }

  Future<void> getSiswa() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await supabase.from('siswa').select().order('id');
      setState(() => siswa = List<Map<String, dynamic>>.from(data));
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<String> get daftarKelas {
    if (selectedJurusan == 'PPLG') {
      return ['Semua', 'X PPLG', 'XI PPLG', 'XII PPLG'];
    }
    if (selectedJurusan == 'FM') {
      return ['Semua', 'X FM', 'XI FM', 'XII FM'];
    }
    if (selectedJurusan == 'AK') {
      return ['Semua', 'X AK', 'XI AK', 'XII AK', 'XIII AK'];
    }
    return [
      'Semua',
      'X PPLG',
      'XI PPLG',
      'XII PPLG',
      'X FM',
      'XI FM',
      'XII FM',
      'X AK',
      'XI AK',
      'XII AK',
      'XIII AK',
    ];
  }

  List<Map<String, dynamic>> get filteredSiswa {
    final keyword = searchController.text.toLowerCase();
    return siswa.where((data) {
      final nis = data['nis']?.toString().toLowerCase() ?? '';
      final nama = data['nama']?.toString().toLowerCase() ?? '';
      final jurusan = data['jurusan']?.toString() ?? '';
      final kelas = data['kelas']?.toString() ?? '';
      final cocokSearch = nis.contains(keyword) || nama.contains(keyword);
      final cocokJurusan =
          selectedJurusan == 'Semua' || jurusan == selectedJurusan;
      final cocokKelas = selectedKelas == 'Semua' || kelas == selectedKelas;
      return cocokSearch && cocokJurusan && cocokKelas;
    }).toList();
  }

  void bukaDetailSiswa(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailSiswaPage(siswa: data)),
    );
  }

  Future<void> bukaFormTambah() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormSiswaPage()),
    );
    getSiswa();
  }

  Future<void> bukaFormEdit(Map<String, dynamic> data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormSiswaPage(siswa: data)),
    );
    getSiswa();
  }

  Future<void> hapusSiswa(Map<String, dynamic> data) async {
    try {
      await supabase.from('siswa').delete().eq('id', data['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data siswa berhasil dihapus')),
      );
      getSiswa();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  void konfirmasiHapus(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus ${data['nama']}?'),
          content: const Text(
            'Catatan ini keluar dari buku induk dan tidak bisa dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.stamp,
                minimumSize: const Size(90, 44),
              ),
              onPressed: () {
                Navigator.pop(context);
                hapusSiswa(data);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void tampilkanMenu(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTokens.rule,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Ubah catatan'),
                onTap: () {
                  Navigator.pop(context);
                  bukaFormEdit(data);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: AppTokens.stamp),
                title: const Text('Hapus dari buku',
                    style: TextStyle(color: AppTokens.stamp)),
                onTap: () {
                  Navigator.pop(context);
                  konfirmasiHapus(data);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void resetFilter() {
    setState(() {
      searchController.clear();
      selectedJurusan = 'Semua';
      selectedKelas = 'Semua';
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasil = filteredSiswa;
    return Scaffold(
      backgroundColor: AppTokens.chalk,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data siswa',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
            if (!isLoading && errorMessage == null)
              Text(
                '${hasil.length} dari ${siswa.length} catatan',
                style:
                    const TextStyle(fontSize: 13, color: AppTokens.muted),
              ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Cari nama atau NIS',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Jurusan segmented
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: daftarJurusan.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final j = daftarJurusan[i];
                final active = selectedJurusan == j;
                return ChoiceChip(
                  label: Text(j == 'Semua' ? 'Semua jurusan' : j),
                  selected: active,
                  onSelected: (_) => setState(() {
                    selectedJurusan = j;
                    selectedKelas = 'Semua';
                  }),
                  selectedColor: AppTokens.board,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: active ? Colors.white : AppTokens.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                  side: BorderSide(
                    color: active ? AppTokens.board : AppTokens.rule,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: daftarKelas.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final k = daftarKelas[i];
                final active = selectedKelas == k;
                return ChoiceChip(
                  label: Text(k == 'Semua' ? 'Semua kelas' : k),
                  selected: active,
                  onSelected: (_) =>
                      setState(() => selectedKelas = k),
                  selectedColor: AppTokens.ink,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: active ? Colors.white : AppTokens.muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  side: BorderSide(
                    color: active ? AppTokens.ink : AppTokens.rule,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: resetFilter,
              child: const Text('Atur ulang saringan'),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Catatan tidak bisa dimuat',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                errorMessage!,
                                style: const TextStyle(
                                    color: AppTokens.muted),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: getSiswa,
                                child: const Text('Muat ulang'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : hasil.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTokens.rule),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.search_off_outlined,
                                      color: AppTokens.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Tidak ada yang cocok',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Coba kata kunci lain atau longgarkan saringan kelas.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTokens.muted,
                                        height: 1.5),
                                  ),
                                  const SizedBox(height: 14),
                                  TextButton(
                                    onPressed: resetFilter,
                                    child: const Text(
                                        'Atur ulang saringan'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 96),
                            itemCount: hasil.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final data = hasil[index];
                              final nama =
                                  data['nama']?.toString() ??
                                      '-';
                              final nis =
                                  data['nis']?.toString() ??
                                      '-';
                              final kelas =
                                  data['kelas']?.toString() ??
                                      '-';
                              final jurusan =
                                  data['jurusan']?.toString() ??
                                      '';
                              final fotoUrl = data['foto_url']
                                  ?.toString();
                              final spine =
                                  AppTokens.spineFor(jurusan);
                              return Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(13),
                                  side: const BorderSide(
                                      color: AppTokens.rule),
                                ),
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.circular(13),
                                  onTap: () =>
                                      bukaDetailSiswa(data),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 78,
                                        decoration: BoxDecoration(
                                          color: spine,
                                          borderRadius:
                                              const BorderRadius.only(
                                            topLeft:
                                                Radius.circular(
                                                    13),
                                            bottomLeft:
                                                Radius.circular(
                                                    13),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                                9),
                                        child: Container(
                                          width: 46,
                                          height: 52,
                                          color: AppTokens.chalk,
                                          child: fotoUrl != null &&
                                                  fotoUrl
                                                      .isNotEmpty
                                              ? Image.network(
                                                  fotoUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_,
                                                          __,
                                                          ___) =>
                                                      const Icon(
                                                    Icons.person_outline,
                                                    color: AppTokens
                                                        .muted,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons
                                                      .person_outline,
                                                  color: AppTokens
                                                      .muted,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  vertical: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                nama,
                                                style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                  fontSize: 15,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                              ),
                                              const SizedBox(
                                                  height: 3),
                                              Text(
                                                'NIS $nis',
                                                style: nisStyle(),
                                              ),
                                              const SizedBox(
                                                  height: 2),
                                              Text(
                                                'Kelas $kelas',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppTokens
                                                      .muted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color:
                                              AppTokens.muted,
                                        ),
                                        onPressed: () =>
                                            tampilkanMenu(
                                                data),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: bukaFormTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
