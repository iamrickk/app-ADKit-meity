import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SlideTab extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final imgPath, tabName, tabDesc, imgHeight, imgLeft, imgBottom;
  final Color? color;
  final AutoSizeGroup? titleGrp, descGrp;
  final int? numbers;
  final int? pageno;
  const SlideTab({
    super.key,
    this.imgPath,
    this.tabName,
    this.color,
    this.tabDesc,
    this.imgHeight = 150.0,
    this.imgLeft = 15.0,
    this.imgBottom = -8.0,
    this.titleGrp,
    this.numbers,
    this.descGrp,
    this.pageno,
  });

  @override
  State<SlideTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<SlideTab> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            // Left text
            Positioned(
              left: MediaQuery.of(context).size.width * 0.005,
              top: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.numbers_outlined,
                          color: (widget.pageno == 0
                              ? const Color.fromARGB(255, 224, 219, 219)
                              : Colors.black),
                        ),
                        iconSize: 30,
                      ),
                      Text(
                        (widget.pageno != 0) ? "${widget.numbers}" : "",
                        style: TextStyle(
                          color: widget.color,
                          fontFamily: "Montserrat",
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right text
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 150, right: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.color!.withOpacity(0.13),
                  ),
                  height: 125,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AutoSizeText(
                        "${widget.tabName}",
                        style: TextStyle(
                          color: widget.color,
                          fontFamily: "Montserrat",
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        stepGranularity: 1,
                        maxFontSize: 20,
                        maxLines: 1,
                        group: widget.titleGrp!,
                      ),
                      AutoSizeText(
                        "${widget.tabDesc!}",
                        style: TextStyle(
                          color: widget.color,
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        stepGranularity: 1,
                        maxFontSize: 15,
                        maxLines: 3,
                        group: widget.descGrp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
