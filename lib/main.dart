import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orcamento_inteligente/firebase_options.dart';
import 'package:orcamento_inteligente/login/loginScreen.dart';
import 'package:orcamento_inteligente/mainTela/mainTela.dart';

//Desenvolvido por HeroRickyGames

void main(){
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark
      ),
      home: MainApp(),
    )
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {

    initFirebase() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseAuth.instance.idTokenChanges().listen((User? user) {
        if(user == null){
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return login();
              }));
        }else{
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return mainTela();
              }));
        }
      });
    }

    initFirebase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Orçamento Inteligente'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
