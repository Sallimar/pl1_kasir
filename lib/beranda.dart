import 'package:flutter/material.dart';

void main(){
  runApp(const Beranda());
}

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Beranda',
          style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back),
          color: Colors.white,),
        ),
        body: Center(
          child: const Text("selamat datang di beranda!!!"),
        ),
      ),
    );
  }
}