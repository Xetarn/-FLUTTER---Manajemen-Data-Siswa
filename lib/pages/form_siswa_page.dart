import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';

class FormSiswaPage extends StatefulWidget {
  final Map<String, dynamic>? siswa;

  const FormSiswaPage({super.key, this.siswa});

  @override
  State<FormSiswaPage> createState() => _FormSiswaPageState();
}

class _FormSiswaPageState extends State<FormSiswaPage> {
  final supabase = Supabase.instance.client;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tempatLahirController =
      TextEditingController();
  final TextEditingController tanggalLahirController =
      TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTeleponController =
      TextEditingController();

  String? jurusan;
  String? kelas;
  String? jenisKelamin;
  bool isLoading = false;
  File? selectedImage;
  bool get isEdit => widget.siswa != null;
  final List<String> daftarJurusan = ['PPLG', 'FM', 'AK'];

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      nisController.text = widget.siswa!['nis']?.toString() ?? '';
      namaController.text = widget.siswa!['nama']?.toString() ?? '';
      tempatLahirController.text =
          widget.siswa!['tempat_lahir']?.toString() ?? '';
      tanggalLahirController.text =
          widget.siswa!['tanggal_lahir']?.toString() ?? '';
      alamatController.text =
          widget.siswa!['alamat']?.toString() ?? '';
      noTeleponController.text =
          widget.siswa!['no_telepon']?.toString() ?? '';
      jurusan = widget.siswa!['jurusan']?.toString();
      kelas = widget.siswa!['kelas']?.toString();
      jenisKelamin = widget.siswa!['jenis_kelamin']?.toString();
    }
  }

  Future<void> pilihFoto() async {
    final picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => selectedImage = File(image.path));
  }

  Future<void> pilihTanggal() async {
    DateTime? tanggalAwal;
    if (tanggalLahirController.text.isNotEmpty) {
      try {
        tanggalAwal =
            DateTime.parse(tanggalLahirController.text);
      } catch (_) {
        tanggalAwal = null;
      }
    }
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: tanggalAwal ?? DateTime(2008),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (tanggal == null) return;
    final bulan = tanggal.month.toString().padLeft(2, '0');
    final hari = tanggal.day.toString().padLeft(2, '0');
    setState(() {
      tanggalLahirController.text =
          '${tanggal.year}-$bulan-$hari';
    });
  }

  List<String> get daftarKelas {
    if (jurusan == 'PPLG') return ['X PPLG', 'XI PPLG', 'XII PPLG'];
    if (jurusan == 'FM') return ['X FM', 'XI FM', 'XII FM'];
    if (jurusan == 'AK') {
      return ['X AK', 'XI AK', 'XII AK', 'XIII AK'];
    }
    return [];
  }

  Future<String?> uploadFoto() async {
    if (selectedImage == null) return null;
    final extension =
        selectedImage!.path.split('.').last.toLowerCase();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${nisController.text.trim()}.$extension';
    final filePath = 'siswa/$fileName';
    await supabase.storage
        .from('siswa')
        .upload(filePath, selectedImage!);
    return supabase.storage.from('siswa').getPublicUrl(filePath);
  }

  Future<void> simpanSiswa() async {
    final isValid =
        _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Periksa kembali data yang ditandai merah.')),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      final Map<String, dynamic> data = {
        'nis': nisController.text.trim(),
        'nama': namaController.text.trim(),
        'tempat_lahir': tempatLahirController.text.trim(),
        'tanggal_lahir': tanggalLahirController.text.trim(),
        'jenis_kelamin': jenisKelamin,
        'alamat': alamatController.text.trim(),
        'no_telepon': noTeleponController.text.trim(),
        'kelas': kelas,
        'jurusan': jurusan,
      };
      if (selectedImage != null) {
        final fotoUrl = await uploadFoto();
        if (fotoUrl != null) data['foto_url'] = fotoUrl;
      }
      if (isEdit) {
        await supabase
            .from('siswa')
            .update(data)
            .eq('id', widget.siswa!['id']);
      } else {
        await supabase.from('siswa').insert(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isEdit
                ? 'Data siswa berhasil diperbarui'
                : 'Data siswa berhasil ditambahkan')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    noTeleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existingFoto = widget.siswa?['foto_url']?.toString();
    return Scaffold(
      backgroundColor: AppTokens.chalk,
      appBar: AppBar(
        title: Text(
          isEdit ? 'Ubah catatan' : 'Catatan baru',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo row
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppTokens.rule),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 72,
                        height: 84,
                        color: AppTokens.chalk,
                        child: selectedImage != null
                            ? Image.file(selectedImage!,
                                fit: BoxFit.cover)
                            : (isEdit &&
                                    existingFoto != null &&
                                    existingFoto.isNotEmpty
                                ? Image.network(
                                    existingFoto,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __,
                                            ___) =>
                                        const Icon(
                                      Icons.person_outline,
                                      color:
                                          AppTokens.muted,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person_outline,
                                    size: 32,
                                    color: AppTokens.muted,
                                  )),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Foto kartu pelajar',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Wajah jelas, latar polos. Bisa diisi belakangan.',
                            style: TextStyle(
                              color: AppTokens.muted,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: pilihFoto,
                            icon: const Icon(
                                Icons.photo_outlined,
                                size: 18),
                            label: const Text('Pilih foto'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  AppTokens.board,
                              side: const BorderSide(
                                  color: AppTokens.board),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _SectionHead(
                  title: 'Identitas',
                  desc: 'Sesuai yang tertulis di rapor.'),
              const SizedBox(height: 10),
              TextFormField(
                controller: nisController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  hintText: 'Contoh 12345',
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'NIS wajib diisi'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: namaController,
                maxLength: 25,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'))
                ],
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  hintText: 'Sesuai akta kelahiran',
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Nama wajib diisi'
                        : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: tempatLahirController,
                      maxLength: 20,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'))
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Tempat lahir',
                        counterText: '',
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Wajib diisi'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: tanggalLahirController,
                      readOnly: true,
                      onTap: pilihTanggal,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal lahir',
                        hintText: '2008-01-01',
                        suffixIcon:
                            Icon(Icons.calendar_today_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Wajib diisi'
                              : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                decoration: const InputDecoration(
                    labelText: 'Jenis kelamin'),
                items: const [
                  DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki')),
                  DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan')),
                ],
                onChanged: (v) =>
                    setState(() => jenisKelamin = v),
                validator: (v) =>
                    v == null ? 'Pilih jenis kelamin' : null,
              ),
              const SizedBox(height: 20),
              const _SectionHead(
                  title: 'Tempat tinggal',
                  desc: 'Untuk surat menyurat sekolah.'),
              const SizedBox(height: 10),
              TextFormField(
                controller: alamatController,
                maxLength: 50,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  alignLabelWithHint: true,
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Alamat wajib diisi'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noTeleponController,
                keyboardType: TextInputType.phone,
                maxLength: 16,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: 'Nomor telepon',
                  hintText: 'Nomor wali murid',
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Nomor telepon wajib diisi'
                        : null,
              ),
              const SizedBox(height: 20),
              const _SectionHead(
                  title: 'Kelas',
                  desc: 'Menentukan rombongan belajar.'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: jurusan,
                decoration:
                    const InputDecoration(labelText: 'Jurusan'),
                items: daftarJurusan
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() {
                  jurusan = v;
                  kelas = null;
                }),
                validator: (v) =>
                    v == null ? 'Pilih jurusan' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: kelas,
                decoration:
                    const InputDecoration(labelText: 'Kelas'),
                items: daftarKelas
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(e)))
                    .toList(),
                onChanged: daftarKelas.isEmpty
                    ? null
                    : (v) => setState(() => kelas = v),
                validator: (v) =>
                    v == null ? 'Pilih kelas' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : simpanSiswa,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEdit
                          ? 'Simpan perubahan'
                          : 'Simpan ke buku'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHead extends StatelessWidget {
  final String title;
  final String desc;
  const _SectionHead({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 4,
              decoration: BoxDecoration(
                color: AppTokens.mustard,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTokens.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            desc,
            style: const TextStyle(
                fontSize: 13, color: AppTokens.muted),
          ),
        ),
      ],
    );
  }
}
