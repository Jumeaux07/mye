import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/setting/controllers/setting_controller.dart';
import 'package:nom_du_projet/app/data/models/factures.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AbonnementView extends StatelessWidget {
  final SettingController controller = Get.find();

  AbonnementView({super.key});

  Future<void> _generateAndPrintPdf(Abonnement abonnement) async {
    final pdf = pw.Document();
    final user = controller.userrr.value;

    // Charge le logo depuis les assets
    final ByteData logoBytes =
        await rootBundle.load('assets/images/LOGO-MYE-Dark.png');
    final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
    final image = pw.MemoryImage(logoUint8List);

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête : Logo et Nom utilisateur
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(image, width: 80, height: 80),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                        "Utilisateur : ${Env.userAuth.getFullName() ?? 'Inconnu'}",
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Référence : ${abonnement.reference ?? 'N/A'}",
                        style: pw.TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
            pw.SizedBox(height: 24),

            pw.Text("Détails de l'Abonnement",
                style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue)),
            pw.Divider(),

            pw.SizedBox(height: 12),

            // 🧾 Tableau d'information
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Champ",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Valeur",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Référence")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("${abonnement.reference ?? 'N/A'}")),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Date de fin")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                          "${convertDate(abonnement.datefin.toString())}")),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Durée")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("${abonnement.jours ?? 0} jours")),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Statut")),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                          abonnement.statut == 1 ? "Actif" : "Inactif",
                          style: pw.TextStyle(
                              color: abonnement.statut == 1
                                  ? PdfColors.green
                                  : PdfColors.red))),
                ]),
              ],
            ),

            pw.Spacer(),

            // Message final
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Merci de votre confiance !",
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic, fontSize: 12)),
            )
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes Abonnements")),
      body: controller.obx(
        (data) {
          final factures = controller.factures;
          final abonnements =
              factures.expand((facture) => facture.abonnement ?? []).toList();

          if (abonnements.isEmpty) {
            return const Center(child: Text("Aucun abonnement trouvé."));
          }

          return ListView.builder(
            itemCount: abonnements.length,
            itemBuilder: (context, index) {
              final ab = abonnements[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.subscriptions, color: Colors.blue),
                  title: Text("Référence : ${ab.reference ?? 'N/A'}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ab.datefin != null)
                        Text(
                            "Expire le : ${convertDate(ab.datefin.toString())}"),
                      Text("Durée : ${ab.jours ?? 0} jours"),
                      Text("Statut : ${ab.statut == 1 ? 'Actif' : 'Inactif'}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    onPressed: () => _generateAndPrintPdf(ab),
                  ),
                ),
              );
            },
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("Aucune facture disponible.")),
        onError: (err) => Center(child: Text("Erreur : $err")),
      ),
    );
  }
}
