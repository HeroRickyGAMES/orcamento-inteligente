import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orcamento_inteligente/PDF/pdf.dart';
import 'package:uuid/uuid.dart';

var UID = FirebaseAuth.instance.currentUser?.uid;

class mainTela extends StatefulWidget {
  const mainTela({super.key});

  @override
  State<mainTela> createState() => _mainTelaState();
}

class _mainTelaState extends State<mainTela> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains){
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Orçamento Inteligente'),
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
                    width: double.infinity,
                    height: constrains.maxHeight - 150,
                    child: StreamBuilder(stream: FirebaseFirestore.instance
                        .collection('orcamentoCollection')
                        .where("idPertence", isEqualTo: UID)
                        .snapshots(), builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot){
              
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if(snapshot.data!.docs.isEmpty){
                        return const Center(
                          child: Text(
                            'Ainda não existe nenhum orçamento adicionado',
                            style: TextStyle(
                                fontSize: 35
                            ),
                          ),
                        );
                      }
              
                      return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListView(
                              children: snapshot.data!.docs.map((documents) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Titulo: ${documents['titulo']}",
                                            style: const TextStyle(
                                                fontSize: 25
                                            ),
                                          ),
                                          Text(
                                            "Nome Do Cliente: ${documents['clientName']}",
                                            style: const TextStyle(
                                                fontSize: 25
                                            ),
                                          ),
                                          Text(
                                            "Produto: ${documents['NomedoItem']}",
                                            style: const TextStyle(
                                                fontSize: 25
                                            ),
                                          ),
                                          Text(
                                            "Unidade: ${documents['unidadeItem']}",
                                            style: const TextStyle(
                                                fontSize: 25
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(onPressed: () async {
                                            var userInfos = await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(UID)
                                                .get();
              
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context){
                                                  return generatePDF2(userInfos["Nome"], documents["clientName"], documents["clientEndereco"], documents["clientNumero"],
                                                      documents["clientEmail"], documents["relatorioInicial"], documents["atividadesDescript"],
                                                      documents["NomedoItem"], documents["valorSemDesconto"], "${documents["valorItem"]}", documents["desconto"]);
                                                }));
                                          }, child: const Icon(Icons.print)
                                          ),
                                          ElevatedButton(onPressed: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Deseja Deletar?'),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        ElevatedButton(onPressed: (){
                                                          Navigator.of(context).pop();
                                                        }, child: const Text('Não')
                                                        ),
                                                        ElevatedButton(onPressed: (){
                                                          FirebaseFirestore.instance.collection("orcamentoCollection").doc(documents['id']).delete().whenComplete((){
                                                            Navigator.of(context).pop();
                                                          });
                                                        }, child: const Text('Sim')
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }, child: const Icon(Icons.delete)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              String Titulo = '';
              String clientName = '';
              String clientNumero = '';
              String clientEndereco = '';
              String clientEmail = '';
              String relatorioInicial = '';
              String atividadesDescript = '';
              String NomedoItem = '';
              String unidadeItem = '1';
              String valorItem = '';
              String desconto = '0';

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                    return Center(
                      child: SingleChildScrollView(
                        child: AlertDialog(
                          title: const Text('Criar uma nova Nota'),
                          actions: [
                            Center(
                              child: Container(
                                width: 500,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              child: TextField(
                                                keyboardType: TextInputType.name,
                                                enableSuggestions: true,
                                                autocorrect: false,
                                                onChanged: (value){
                                                  setState(() {
                                                    Titulo = value;
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
                                                  hintText: 'Titulo',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    child: const Text('Dados do Cliente'),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    child: TextField(
                                                      keyboardType: TextInputType.name,
                                                      enableSuggestions: true,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          clientName = value;
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
                                                        hintText: 'Nome do Cliente',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    child: TextField(
                                                      keyboardType: TextInputType.number,
                                                      enableSuggestions: true,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          clientNumero = value;
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
                                                        hintText: 'Numero do Cliente',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    child: TextField(
                                                      keyboardType: TextInputType.streetAddress,
                                                      enableSuggestions: true,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          clientEndereco = value;
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
                                                        hintText: 'Endereço do Cliente',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    child: TextField(
                                                      keyboardType: TextInputType.emailAddress,
                                                      enableSuggestions: true,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          clientEmail = value;
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
                                                        hintText: 'Email do Cliente',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child:
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          enableSuggestions: true,
                                          autocorrect: true,
                                          minLines: 5,
                                          maxLines: null,
                                          onChanged: (value){
                                            relatorioInicial = value;
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
                                            hintText: 'Relatiorio Inicial',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child:
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          enableSuggestions: true,
                                          autocorrect: true,
                                          minLines: 5,
                                          maxLines: null,
                                          onChanged: (value){
                                            atividadesDescript = value;
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
                                            hintText: 'Descrição das Atividades',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child:
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                child: const Text('Item'),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                child: TextField(
                                                  keyboardType: TextInputType.text,
                                                  enableSuggestions: true,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      NomedoItem = value;
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
                                                    hintText: 'Nome do Item',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  enableSuggestions: true,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      unidadeItem = value;
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
                                                    hintText: 'Unidade',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  enableSuggestions: true,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      valorItem = value;
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
                                                    hintText: 'Valor (R\$)',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child:
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                child: const Text('Desconto'),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  enableSuggestions: true,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      desconto = value;
                                                      if(value == ''){
                                                        desconto = '0';
                                                      }

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
                                                    hintText: 'Desconto em (R\$)',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: const Text('Cancelar')
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              if(Titulo == ''){
                                                Fluttertoast.showToast(
                                                    msg: "Preencha seu titulo!",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              }else{
                                                if(clientName == ''){
                                                  Fluttertoast.showToast(
                                                      msg: "Preencha o nome do Cliente!",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }else{
                                                  if(clientNumero == ''){
                                                    Fluttertoast.showToast(
                                                        msg: "Preencha o numero do Cliente!",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0
                                                    );
                                                  }else{
                                                    if(clientEndereco == ''){
                                                      Fluttertoast.showToast(
                                                          msg: "Preencha o endereço do Cliente!",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                    }else{
                                                      if(clientEmail == ''){
                                                        Fluttertoast.showToast(
                                                            msg: "Preencha o Email do Cliente!",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0
                                                        );
                                                      }else{
                                                        if(NomedoItem == ''){
                                                          Fluttertoast.showToast(
                                                              msg: "Preencha o nome do item!",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.red,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0
                                                          );
                                                        }else{
                                                          if(unidadeItem == ''){
                                                            Fluttertoast.showToast(
                                                                msg: "Preencha a unidade do item! (1, 2, 3 etc)",
                                                                toastLength: Toast.LENGTH_LONG,
                                                                gravity: ToastGravity.CENTER,
                                                                timeInSecForIosWeb: 1,
                                                                backgroundColor: Colors.red,
                                                                textColor: Colors.white,
                                                                fontSize: 16.0
                                                            );
                                                          }else{
                                                            if(valorItem == ''){
                                                              Fluttertoast.showToast(
                                                                  msg: "Preencha o valor do item!",
                                                                  toastLength: Toast.LENGTH_LONG,
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
                                                              var uuid = const Uuid();
                                                              String id = uuid.v4();

                                                              FirebaseFirestore.instance.collection("orcamentoCollection").doc(id).set({
                                                                "id": id,
                                                                "titulo" : Titulo,
                                                                "clientName": clientName,
                                                                "clientNumero": clientNumero,
                                                                'clientEndereco': clientEndereco,
                                                                "clientEmail": clientEmail,
                                                                "relatorioInicial": relatorioInicial,
                                                                "atividadesDescript": atividadesDescript,
                                                                "NomedoItem": NomedoItem,
                                                                "unidadeItem": unidadeItem,
                                                                "valorItem": int.parse(valorItem) * int.parse(unidadeItem) - int.parse(desconto),
                                                                "valorSemDesconto": valorItem,
                                                                "desconto": desconto,
                                                                "idPertence": UID,
                                                              }).whenComplete(() {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pop();
                                                              });
                                                            }
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }

                                            }, child: const Text('Criar Nota')
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },);
                },
              );
            },
            child: const Icon(Icons.add),
          )
      );
    });
  }
}
