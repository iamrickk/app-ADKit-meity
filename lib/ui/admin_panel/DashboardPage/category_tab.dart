import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTab extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final imgPath, tabName, tabDesc, imgHeight, imgLeft, imgBottom;
  final Color? color;
  final AutoSizeGroup? titleGrp, descGrp;
  final String? index, count;
  const CategoryTab(
      {super.key,
      this.imgPath,
      this.tabName,
      this.color,
      this.tabDesc,
      this.imgHeight = 150.0,
      this.imgLeft = 15.0,
      this.imgBottom = -8.0,
      this.titleGrp,
      this.descGrp,
      this.index,
      this.count});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<double> _tween;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _tween = Tween(begin: 0.0, end: double.parse(widget.count!));
    _animation = _tween.animate(_controller);

    _controller.forward();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        height: 142,
        child: Stack(
          children: <Widget>[
            //Title Container
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
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                        stepGranularity: 1,
                        maxFontSize: 23,
                        maxLines: 1,
                        group: widget.titleGrp!,
                      ),
                      AutoSizeText(
                        "${widget.tabDesc!}",
                        style: TextStyle(
                          color: widget.color,
                          fontFamily: "Montserrat",
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                        stepGranularity: 1,
                        maxFontSize: 19,
                        maxLines: 3,
                        group: widget.descGrp,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.07,
              // bottom: widget.imgBottom,
              child: SizedBox(
                // height: widget.imgHeight,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final value = _animation.value;
                    return Text(
                      value.toStringAsFixed(0),
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.0,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
