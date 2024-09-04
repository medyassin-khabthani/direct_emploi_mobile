import 'package:direct_emploi/helper/de_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../helper/style.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String pdfTitle;

  const PdfViewScreen({required this.pdfUrl, Key? key, required this.pdfTitle}) : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  late File pdfFile;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int currentPage = 0;
  int totalPages = 0;
  late PDFViewController pdfViewController;

  @override
  void initState() {
    super.initState();
    loadNetwork();
  }

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final url = widget.pdfUrl;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final filename = basename(url);
        final dir = await getApplicationDocumentsDirectory();
        var file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          pdfFile = file;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to download PDF. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Une erreur est survenue : $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      pdfViewController.setPage(currentPage + 1);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      pdfViewController.setPage(currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DEBackButton(),
        centerTitle: true,
        title: Text(
          widget.pdfTitle,
          style: TextStyle(fontSize: 14, color: textColor, fontFamily: 'semi-bold'),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text(errorMessage))
          : Stack(
        children: [
          PDFView(
            filePath: pdfFile.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) {
              setState(() {
                totalPages = pages!;
              });
            },
            onViewCreated: (controller) {
              pdfViewController = controller;
            },
            onPageChanged: (page, total) {
              setState(() {
                currentPage = page!;
              });
            },
            onError: (error) {
              setState(() {
                hasError = true;
                errorMessage = 'Failed to load PDF: $error';
              });
            },
            onPageError: (page, error) {
              setState(() {
                hasError = true;
                errorMessage = 'Failed to load page $page: $error';
              });
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: previousPage,
                    ),
                    Text('${currentPage + 1}/$totalPages'),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: nextPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
