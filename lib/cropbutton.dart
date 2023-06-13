import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart' as px;

class CropButton extends StatefulWidget {
  const CropButton({Key? key}) : super(key: key);

  @override
  State<CropButton> createState() => _CropButtonState();
}

class _CropButtonState extends State<CropButton> {
  String pdfPath='';
  Future<int> pdftoImage(int pageIndex, px.PdfDocument pdfFile)async{
    String imgPath = 'C:\\edit_tools\\save\\$pageIndex.jpg';
    File imageFile = File(imgPath);
    final page = await pdfFile.getPage(pageIndex+1);
    final pageImage = await page.render(
        width: 2000,
        height: 2732,
        format: px.PdfPageImageFormat.jpeg,
        cropRect: const Rect.fromLTWH(0, 0, 2000, 2732)
    );
    imageFile = await imageFile.writeAsBytes(pageImage!.bytes);
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            int pageIndex=0;
            if(result!=null){
              setState((){
                pdfPath = result.files.single.path!;
              });
              px.PdfDocument pdfFile = await px.PdfDocument.openFile(pdfPath);
              for(int i=0;i<pdfFile.pagesCount;i++) {
                try {
                  await pdftoImage(pageIndex, pdfFile);
                  pageIndex += 1;
                }
                catch (e) {
                  break;
                }
              }
            }
          },
          child: const Text('upload'),
        ),
      ),
    );
  }
}
