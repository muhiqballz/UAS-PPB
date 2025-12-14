import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_navigation.dart';
import '../config/api_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; 

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_nimController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIM dan Password harus diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/login.php');
      final response = await http.post(url, body: {
        'username': _nimController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final userData = data['data'];
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(
                userId: userData['id'].toString(),
                userName: userData['nama_lengkap'] ?? 'User',
                userNim: userData['username'] ?? '-', 
                userRole: userData['role'] ?? 'mahasiswa',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message']), backgroundColor: Colors.orange),
          );
        }
      } else {
        throw Exception('Error Server: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Login. Cek koneksi/IP: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(color: const Color(0xFF3498DB), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.school, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 30),
                const Text('StudyMate', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFECF0F1))),
                const SizedBox(height: 10),
                const Text('Sistem Manajemen Pembelajaran', style: TextStyle(fontSize: 14, color: Color(0xFFECF0F1))),
                const SizedBox(height: 50),
                
                TextField(
                  controller: _nimController,
                  style: const TextStyle(color: Color(0xFF2C3E50)),
                  decoration: InputDecoration(
                    filled: true, fillColor: Colors.white, hintText: 'Nomor Induk / Username',
                    prefixIcon: const Icon(Icons.person, color: Color(0xFF3498DB)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFF2C3E50)),
                  decoration: InputDecoration(
                    filled: true, fillColor: Colors.white, hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF3498DB)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}