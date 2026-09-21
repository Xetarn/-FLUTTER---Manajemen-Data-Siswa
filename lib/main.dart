import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jvuqfyqmurijmqegiyef.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2dXFmeXFtdXJpam1xZWdpeWVmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg4NzA1NzMsImV4cCI6MjEwNDQ0NjU3M30.DTg6_PCv19JA_KhzcpyPMCO4VUnva44HsaXpNc2Gx2U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manajemen Data Siswa',
      theme: buildLedgerTheme(),
      home: const LoginPage(),
    );
  }
}