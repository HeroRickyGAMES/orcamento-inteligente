import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orcamento_inteligente/login/loginScreen.dart';
import 'package:orcamento_inteligente/mainTela/mainTela.dart';

//Desenvolvido por HeroRickyGames

class criarConta extends StatefulWidget {
  const criarConta({super.key});

  @override
  State<criarConta> createState() => _criarContaState();
}

class _criarContaState extends State<criarConta> {
  String nome = '';
  String Email = '';
  String Senha = '';

  irParaTelaMain(){
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return const mainTela();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Criar sua conta',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  "assets/ic_launcher.png",
                  scale: 3,
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    enableSuggestions: true,
                    autocorrect: false,
                    onChanged: (value){
                      setState(() {
                        nome = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.black
                        ),
                      ),
                      hintText: 'Seu nome',
                    ),
                  ),
                ),
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
                        borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.black
                        ),
                      ),
                      hintText: 'Seu Email',
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
                        borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.black
                        ),
                      ),
                      hintText: 'Sua Senha',
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(onPressed: () async {
                  if(nome == ''){
                    Fluttertoast.showToast(
                        msg: "Preencha seu nome!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }else{
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
                            msg: "Preencha seu senha!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{

                        if(!Email.contains("@")){
                          Fluttertoast.showToast(
                              msg: "Preencha o email corretamente",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }else{
                          if(!Email.contains(".com")){
                            Fluttertoast.showToast(
                                msg: "Preencha o email corretamente",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else{
                            if(Senha.length < 8){
                              Fluttertoast.showToast(
                                  msg: "Sua senha é curta de mais!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text('Aguarde!'),
                                    actions: [
                                      Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    ],
                                  );
                                },
                              );

                              var auth = FirebaseAuth.instance;

                              auth.createUserWithEmailAndPassword(email: Email, password: Senha).whenComplete(() {
                                var UID = FirebaseAuth.instance.currentUser?.uid;

                                FirebaseFirestore.instance.collection('Users').doc(UID).set({
                                  'uid': UID,
                                  'Nome' : nome.trim(),
                                  'Email': Email.trim(),
                                }).whenComplete(() {
                                  Navigator.of(context).pop();
                                  irParaTelaMain();
                                });
                              }).catchError((e){
                                Fluttertoast.showToast(
                                    msg: "Ocorreu um erro: $e",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              });
                            }
                          }
                        }
                      }
                    }
                  }
                },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent
                    ),child: const Text(
                      'Criar uma conta.',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
              ),
              WillPopScope(
                onWillPop: () async {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return const login();
                      }));
                  return false;
                }, child: const Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
