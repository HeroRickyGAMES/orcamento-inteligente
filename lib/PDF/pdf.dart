import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

//Programado por HeroRickyGames

class generatePDF2 extends StatelessWidget {

  String userName;
  String clientName;
  String clientEndereco;
  String clientNumero;
  String clientEmail;
  String relatorioInicial;
  String atividadesDescript;
  String NomedoItem;
  String valorSemDesconto;
  String valorItem;
  String desconto;
  generatePDF2(this.userName, this.clientName, this.clientEndereco,
      this.clientNumero, this.clientEmail, this.relatorioInicial,
      this.atividadesDescript, this.NomedoItem, this.valorSemDesconto, this.valorItem, this.desconto, {super.key});

  var UID = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains){
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(right: 50),
                        child: const Text('Gerar PDF')
                    ),
                  ],
                ),
              )
          ),
          body: PdfPreview(
            build: (format) => _generatePDF2(format, 'Gerar PDF', userName, clientName,
                clientEndereco, clientNumero, clientEmail,
                relatorioInicial, atividadesDescript, NomedoItem, valorSemDesconto, valorItem, desconto, context),
          ),
        );
      },
    );
  }

  Future<Uint8List> _generatePDF2(PdfPageFormat format,
      String titulo, String userName, String clientName,
      String clientEndereco, String clientNumero, String clientEmail,
      String relatorioInicial, String atividadesDescript, String NomedoItem,
      String valorSemDesconto, String valorItem, String desconto,
      context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            //crossAxisAlignment: pw.CrossAxisAlignment.center,
            //mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                              "DE",
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                              userName,
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )
                          ),
                        ),
                      ]
                    ),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                                "PARA",
                                style: const pw.TextStyle(
                                  fontSize: 16,
                                )
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                                clientName,
                                style: const pw.TextStyle(
                                  fontSize: 16,
                                )
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                                "Endereço: $clientEndereco",
                                style: const pw.TextStyle(
                                  fontSize: 16,
                                )
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                                "Numero: $clientNumero",
                                style: const pw.TextStyle(
                                  fontSize: 16,
                                )
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                                clientEmail,
                                style: const pw.TextStyle(
                                  fontSize: 16,
                                )
                            ),
                          ),
                        ]
                    ),
                  ]
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(1),
                  child: pw.Text(
                      "Relatório Inicial",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      relatorioInicial,
                      style: const pw.TextStyle(
                        fontSize: 16,
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(1),
                  child: pw.Text(
                      "Descrição das Atividades",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      atividadesDescript,
                      style: const pw.TextStyle(
                        fontSize: 16,
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(1),
                  child: pw.Text(
                      "Preços",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                          NomedoItem,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold
                          )
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                          "R\$ $valorSemDesconto",
                          style: const pw.TextStyle(
                            fontSize: 16,
                          )
                      ),
                    ),
                  ]
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      "Subtotal: R\$ $valorSemDesconto",
                      style: const pw.TextStyle(
                        fontSize: 16,
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      "Desconto: R\$ $desconto",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      "Total: R\$ $valorItem",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      "\n\n\n\n\n\n\n\n\n\n--------------------Nome Completo--------------------",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      "\n\n\n\n\n\n-----------------------Assinatura-----------------------",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                ),
              ]
          );
        },
      ),
    );
    return pdf.save();
  }
}