import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfAssetPath;

  PdfViewerScreen({required this.pdfAssetPath});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _pdfFilePath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final byteData = await rootBundle.load(widget.pdfAssetPath);
      final file = File('${(await getTemporaryDirectory()).path}/temp.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      setState(() {
        _pdfFilePath = file.path;
      });
    } catch (e) {
      print("Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lector de PDF'),
      ),
      body: _pdfFilePath != null
          ? PDFView(
        filePath: _pdfFilePath!,
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
