import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';

class PdfExportService {
  Future<Uint8List> generateMaintenanceReport({
    required String vehicleName,
    required List<MaintenanceLog> logs,
    required DateTime start,
    required DateTime end,
    String reportTitle = 'Maintenance Report',
    String generatedFooter = 'Generated {date} {time}',
    String emptyMessage = 'No maintenance logs in this period.',
    String servicesInPeriod = 'service(s) in this period',
    String dateHeader = 'Date',
    String descriptionHeader = 'Description',
    String odometerHeader = 'Odometer',
    String kmSuffix = 'km',
    String partsHeader = 'Parts',
    Map<String, List<MaintenanceLogPart>> partsByLog = const {},
  }) async {
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: boldFont,
      ),
    );

    final dateFmt = DateFormat('dd/MM/yyyy');
    final timeFmt = DateFormat('HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(reportTitle,
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text(vehicleName,
                style: pw.TextStyle(
                    fontSize: 14, color: PdfColors.grey700)),
            pw.SizedBox(height: 2),
            pw.Text(
              '${dateFmt.format(start)} - ${dateFmt.format(end)}',
              style: pw.TextStyle(
                  fontSize: 12, color: PdfColors.grey600),
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            generatedFooter
                .replaceFirst('{date}', dateFmt.format(DateTime.now()))
                .replaceFirst('{time}', timeFmt.format(DateTime.now())),
            style: pw.TextStyle(
                fontSize: 10, color: PdfColors.grey500),
          ),
        ),
        build: (context) => [
          if (logs.isEmpty)
            pw.Center(
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(top: 32),
                child: pw.Text(
                  emptyMessage,
                  style: pw.TextStyle(
                      fontSize: 14, color: PdfColors.grey600),
                ),
              ),
            )
          else ...[
            pw.Text(servicesInPeriod,
                style: pw.TextStyle(
                    fontSize: 14, color: PdfColors.grey700)),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                  color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blueGrey700),
              cellStyle: const pw.TextStyle(fontSize: 10),
              border: const pw.TableBorder(
                horizontalInside: pw.BorderSide(
                    color: PdfColors.grey300, width: 0.5),
                verticalInside: pw.BorderSide(
                    color: PdfColors.grey300, width: 0.5),
                bottom: pw.BorderSide(
                    color: PdfColors.grey300, width: 0.5),
              ),
              headers: [dateHeader, descriptionHeader, partsHeader, odometerHeader],
              data: logs.map((log) {
                final parts = (partsByLog[log.id] ?? const <MaintenanceLogPart>[])
                    .map((p) => _partText(p))
                    .join(', ');
                return [
                  dateFmt.format(log.date),
                  log.description,
                  parts.isEmpty ? '-' : parts,
                  log.odometerAtService > 0
                      ? '${log.odometerAtService.toStringAsFixed(0)} $kmSuffix'
                      : '-',
                ];
              }).toList(),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  String _partText(MaintenanceLogPart part) {
    if (part.unit == null || part.unit!.isEmpty) {
      if (part.quantity == 1) return part.name;
      return '${part.name} \u00d7 ${_fmtQty(part.quantity)}';
    }
    return '${part.name} \u00d7 ${_fmtQty(part.quantity)} ${part.unit}';
  }

  String _fmtQty(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.round().toString();
    }
    return quantity.toString();
  }
}
