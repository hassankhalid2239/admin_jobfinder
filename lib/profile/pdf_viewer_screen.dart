import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String resumeName;
  const PdfViewerScreen(
      {super.key, required this.pdfUrl, required this.resumeName});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  initializePDF() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        centerTitle: true,
        title: Text(widget.resumeName,
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: document == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              document: document!,
            ),
    );
  }
}
