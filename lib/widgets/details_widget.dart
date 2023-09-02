import 'package:aimedscribble/Controllers/createPDF.dart';
import 'package:aimedscribble/uitilities/colors.dart';
import 'package:aimedscribble/widgets/liveStream_widget.dart';
import 'package:aimedscribble/widgets/organize_widget.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';//

              

class DetailsWidget extends StatefulWidget {
  const DetailsWidget({super.key});

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  String reviewText = 'Hello..! Shahid Jaber';



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.32,
      height: MediaQuery.of(context).size.height * 1.00,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final pdfFile =
                        await PdfApi.generateCenteredText(reviewText);
                    print('pdf file:: ${pdfFile.path}');
                  },
                  child: Text('Save Document')),
              ElevatedButton(
                  onPressed: () async {
                    final pdfFile =
                        await PdfApi.generateCenteredText(reviewText);
                    print('pdf file:: ${pdfFile.path}');

                    PdfApi.openFile(pdfFile);
                  },
                  child: Text('Open Document')),
            ],
          ),
          Expanded(
            child: ContainedTabBarView(
              tabBarProperties: const TabBarProperties(
                alignment: TabBarAlignment.start,
                padding: EdgeInsets.only(left: 30),
                width: 350,
                labelColor: blueColor,
                unselectedLabelColor: Colors.grey,
              ),
              tabs: [
                Text(
                  'Organize',
                  style: GoogleFonts.urbanist(
                      fontSize: 18, fontWeight: FontWeight.w900),
                ),
                // Text(
                //   'Build',
                //   style:
                //       GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900),
                // ),
                Text(
                  'Review',
                  style: GoogleFonts.urbanist(
                      fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ],
              views: [
                OrganizeWidget(
                    output: GlobalVariables.output,
                    output2: GlobalVariables.output2),
                // Text('data-2'),
                Text(reviewText),
              ],
              onChange: (index) => print(index),
            ),
          ),
        ],
      ),
    );
  }
}
