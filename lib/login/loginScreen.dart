import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orcamento_inteligente/criarConta/criarConta.dart';
import 'package:orcamento_inteligente/mainTela/mainTela.dart';

//Desenvolvido por HeroRickyGames

final FirebaseAuth _auth = FirebaseAuth.instance;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String Email = '';
  String Senha = '';

  irParaTelaMain(){
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return mainTela();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  "assets/ic_launcher.png",
                  scale: 3,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Text('Simples, facil e gratis!')
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: true,
                    autocorrect: false,
                    onChanged: (value){
                      setState(() {
                        Email = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.black
                        ),
                      ),
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    onChanged: (value){
                      setState(() {
                        Senha = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.black
                        ),
                      ),
                      hintText: 'Senha',
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(onPressed: () async {

                  if(Email == ''){
                    Fluttertoast.showToast(
                        msg: "Preencha seu email!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }else{
                    if(Senha == ''){
                      Fluttertoast.showToast(
                          msg: "Preencha sua senha!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );

                    }else{
                      bool onError = false;
                      _auth.signInWithEmailAndPassword(email: Email, password: Senha).catchError((e){
                        onError = true;
                        Fluttertoast.showToast(
                            msg: "Ocorreu um erro: $e",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }).whenComplete(() {
                        if(onError == false){
                          irParaTelaMain();
                        }
                      });
                    }
                  }
                },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent
                    ),
                    child: const Text(
                      'Logar',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
              ),
              TextButton(onPressed: (){

                if(Email == ''){
                  Fluttertoast.showToast(
                      msg: "Preencha o seu email!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }else{
                  var auth = FirebaseAuth.instance;

                  auth.sendPasswordResetEmail(email: Email).whenComplete((){
                    Fluttertoast.showToast(
                        msg: "Email de recuperação enviado para seu email!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  });
                }
              }, child: const Text(
                'Esqueceu sua Senha?',
                style: TextStyle(
                    color: Colors.deepPurpleAccent
                ),
              )
              ),
              const Text(
                'Você ainda não tem uma conta?',
              ),
              TextButton(onPressed: (){
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return const criarConta();
                    }));
                }, child: const Text(
                  'Crie uma conta agora!',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
