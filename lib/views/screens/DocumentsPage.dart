import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:open_file/open_file.dart';

class DocumentsPage extends StatelessWidget {
  final Map<String, String> fileIcons = {
    'doc': ImageUtils.WordVector,
    'pdf': ImageUtils.PDFVector,
    'docx': ImageUtils.WordVector,
    'xls': ImageUtils.DocumentVector,
    'xlsx': ImageUtils.DocumentVector,
    'ppt': ImageUtils.PPTVector,
    'pptx': ImageUtils.PPTVector,
    'txt': ImageUtils.TXTVector,
  };

  DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final List<FileModel> docsFiles = Get.arguments['files'] ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Documents",
          style: TextStyle(
            color: Colors.white,
            fontSize: h * 0.024,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff9099FF),
                Color(0xff4B5DFF),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: h * 0.84,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(h * 0.02),
            topRight: Radius.circular(h * 0.02),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(h * 0.02),
          child: docsFiles.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: h * 0.26,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            ImageUtils.ImagePath + ImageUtils.NoFileFound,
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Center(
                      child: Text(
                        'No Files Found',
                        style: TextStyle(
                          fontSize: h * 0.026,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${docsFiles.length} Documents",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: h * 0.026,
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Expanded(
                      child: ListView.builder(
                        itemCount: docsFiles.length,
                        itemBuilder: (context, index) {
                          String fileExtension = docsFiles[index]
                              .path
                              .split('.')
                              .last
                              .toLowerCase();
                          String iconPath = fileIcons[fileExtension] ??
                              ImageUtils.DocumentIcon2;

                          return SizedBox(
                            height: h * 0.12,
                            child: GestureDetector(
                              onTap: () async {
                                await OpenFile.open(docsFiles[index].path);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: h * 0.1,
                                    width: h * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(h * 0.02),
                                      color: const Color(0xffEFEFEF),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          ImageUtils.ImagePath + iconPath,
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: w * 0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          docsFiles[index].name,
                                          style: TextStyle(
                                            fontSize: h * 0.022,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
