import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(String myText) async {
    // making a pdf document to store a text and it is provided by pdf pakage
    final pdf = Document();

    // Text is added here in center
    pdf.addPage(
  Page(
    pageFormat: PdfPageFormat.a4,
    build: (Context context) {
      return Center(
        child: Text(myText, style: TextStyle(fontSize: 48)),
      ); // Center
    },
  ), // Page
);

    // passing the pdf and name of the docoment to make a direcotory in  the internal storage
    return saveDocument(name: '123.pdf', pdf: pdf);
  }

  // it will make a named dircotory in the internal storage and then return to its call
  static Future<File> saveDocument({
    String? name,
    Document? pdf,
  }) async {
    // pdf save to the variable called bytes
    final bytes = await pdf!.save();

    // here a beautiful pakage  path provider helps us and take dircotory and name of the file  and made a proper file in internal storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    print('file print:: $file');

    // reterning the file to the top most method which is generate centered text.
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print('url print:: ${url}');

    await OpenFile.open(url);
  }
}
