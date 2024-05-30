import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:review_makanan/providers/auth.dart';
import 'package:review_makanan/screens/signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text;
        String password = _passwordController.text;
        String name = _nameController.text;
        String noHp = _noHpController.text;

        UserCredential userCredential = await _auth.signUpWithEmailAndPassword(email, password);
        User? user = userCredential.user;

        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'name': name,
            'noHp': noHp,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register Success'), backgroundColor: Colors.green),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Nama Anda";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: _noHpController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Handphone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Nomor Handphone Anda";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Email Anda";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$")
                      .hasMatch(value)) {
                    return "Masukkan alamat email yang valid";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Password Anda";
                  } else if (value.length < 6) {
                    return "Password minimal 6 karakter";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                backgroundColor: const Color.fromARGB(255, 187, 0, 255),
              ),
              onPressed: _signup,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 170),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                child: const Text('Sudah Punya Akun? Kembali Ke Login'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
