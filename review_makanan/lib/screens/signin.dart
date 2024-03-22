import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class LoginScreen extends StatelessWidget {  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'images/logo.png',
            )
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 300.0,left: 30.0,right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 30.0,right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 187, 0, 255)
                    ),
                      child: ElevatedButton(onPressed: (null), child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 20),),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Column(
                      children: [
                        Text("Doesn't Have Account? Register Here",style: TextStyle(color: Colors.blue,fontSize: 16),),
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}