import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_makanan/screens/favorite.dart';
import 'package:review_makanan/screens/home.dart';
import 'package:review_makanan/screens/profile.dart';
import 'package:review_makanan/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'images/logo.png',
                width: 400,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
                margin: EdgeInsets.only(top: 30.0),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 187, 0, 255)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 187, 0, 255)),
                  onPressed: () {
                    _login();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
            const SizedBox(height: 8.0),
            TextButton(
              child: const Text('Belum punya akun? Daftar di sini'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    }
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  void _selectedNavMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xfffc88ff),
        currentIndex: _selectedIndex,
        onTap: _selectedNavMenu,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite")
        ],
      ),
    );
  }
}