import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orcamento_inteligente/mainTela/mainTela.dart';
import 'package:uuid/uuid.dart';

//Desenvolvido por HeroRickyGames

final FirebaseStorage storage = FirebaseStorage.instance;

bool Start = false;

class userConfig extends StatefulWidget {
  String nome = '';
  File convertedFilee;

  userConfig(this.nome, this.convertedFilee, {super.key});

  @override
  State<userConfig> createState() => _userConfigState();
}

Future<String> _uploadImageToFirebase(File file, String id) async {
  // Crie uma referência única para o arquivo

  final reference = storage.ref().child('images/$id/$id.png');

  // Faça upload da imagem para o Cloud Storage
  await reference.putFile(file);

  // Recupere a URL do download da imagem para salvar no banco de dados
  final url = await reference.getDownloadURL();
  return url;
}

class _userConfigState extends State<userConfig> {
  String nome = '';

  final NameController = TextEditingController();

  voidPickFile() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      widget.convertedFilee = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {

    setNameController() async {
      var resulte = await FirebaseFirestore.instance
          .collection("Users")
          .doc(UID)
          .get();
      setState(() {
        NameController.text = resulte["Nome"];
        nome = resulte["Nome"];
      });
    }

    if(Start == false){
      setNameController();
    }


    Start = true;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Configurações do Usuario'),
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
                child: InkWell(
                    onTap: (){
                      voidPickFile();
                    },
                    child: Image.file(
                      widget.convertedFilee,
                      scale: 2,
                      width: 500,
                      height: 500,
                    )
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: NameController,
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
                  child: ElevatedButton(
                    onPressed: () async {
                      if(nome == ""){
                        Fluttertoast.showToast(
                            msg: "Nome está vazio!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        if(widget.convertedFilee == null){
                          Fluttertoast.showToast(
                              msg: "A imagem é nula!",
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

                          final imageUrl = await _uploadImageToFirebase(widget.convertedFilee, UID!);
                          FirebaseFirestore.instance.collection("Users").doc(UID).update({
                            "Nome": nome,
                            "LogoImage": imageUrl
                          }).whenComplete(() {
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                            Start = false;
                          });
                        }
                      }
                    },
                    child: const Text('Salvar e sair'),
                  )
                ),
              ),
              WillPopScope(child: Container(), onWillPop: () async {
                Navigator.pop(context);
                Start = false;
                return false;
              })
            ],
          ),
        ),
      ),
    );
  }
}
