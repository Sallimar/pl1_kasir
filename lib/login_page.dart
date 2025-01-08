import 'package:flutter/material.dart';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background Container
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2020/03/25/21/05/pizza-4968645_960_720.jpg'),
                    fit: BoxFit.cover),
                color: (Colors.teal[100]),
              ),
            ),
            //Login
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Silahkan Login Disini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.transparent,                      
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.white),
                              labelText: 'Username',
                              hintStyle: TextStyle(
                                color:Colors.blueGrey,
                              ),
                              hintText: 'Enter Username',
                              prefixIcon: Icon(Icons.person,
                              size: 25, 
                              color: Colors.white,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              return value!.isEmpty ? 'Please enter username' : null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true, // Menyembunyikan password
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              labelText: 'Password',
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              prefixIcon: Icon(Icons.lock,
                              color: Colors.white,
                              size: 25,),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              return value!.isEmpty ? 'Please enter password' : null;
                            },
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            },
                            child: Text('Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            ),
                          ),
                        ],
                      ),
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