import 'package:flutter/material.dart';


Color backgroundColor   = const Color(0xFFF1F2F6);
Color shadowColor       = const Color(0xFFDADFF0);

class ModernSwitch extends StatefulWidget {
  final bool controller;
  final Function onTap;
  final Color activeColor;

  const ModernSwitch({Key? key, required this.controller, required this.onTap, required this.activeColor}) : super(key: key);

  @override
  ModernSwitchState createState() => ModernSwitchState();
}

class ModernSwitchState extends State<ModernSwitch> {
  double scale = 0.7;
  double animatedPosition = 0;
  bool editingMode = false;


  @override
  Widget build(BuildContext context) {
    if (widget.controller == true && editingMode == false) {
      animatedPosition = 1;
    }

    return SizedBox(
      width: 70*scale,
      height: 35*scale,
       child: GestureDetector(
        onTap: () {
          setState(() {
            animatedPosition = 0;//animatedPosition = ((widget.controller == true) ? 1 : 0);
          });
          widget.onTap(!widget.controller);
        },
        /*
        onHorizontalDragStart: (dragInfo) {
          setState(() {
            editingMode = true;
            animatedPosition = (dragInfo.localPosition.dx) / (70 * scale);// * (70*scale - 35*scale)
          });
          print(70*scale);
          print(dragInfo.localPosition.dx);
        },
        onHorizontalDragUpdate: (dragInfo) {
          if (dragInfo.localPosition.dx < 0) {
            setState(() {
              animatedPosition = 0;
            });
          } else if (dragInfo.localPosition.dx > 1) {
            setState(() {
              animatedPosition = 1;
            });
          } else {
            setState(() {
              animatedPosition = (dragInfo.localPosition.dx) / (70 * scale);
            });
          }
          print(70*scale);
          print(dragInfo.localPosition.dx);
        },
        onHorizontalDragEnd: (_) {
          if (animatedPosition > 0.5) {
            setState(() {
              editingMode = false;
              animatedPosition = 1;
            });
            widget.onTap(true);
          } else {
            setState(() {
              animatedPosition = 0;
            });
            widget.onTap(false);
          }
        },
        onHorizontalDragCancel: () {
          setState(() {
            editingMode = false;
          });
        },
        */
        child: Stack(
           children: [
             Container(
               width: 70*scale,
               height: 25*scale,
               decoration: BoxDecoration(
                 color: backgroundColor,
                 borderRadius: BorderRadius.circular(50*scale),
                 boxShadow: [
                   BoxShadow(color: shadowColor, blurRadius: 5)
                 ]
               ),
               child: Row(
                 children: [
                   AnimatedContainer(
                     duration: const Duration(milliseconds: 100),
                      width: 70*scale * ((widget.controller == true) ? 1 : 0), //animatedPosition,
                      height: 25*scale,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50*scale), color: widget.activeColor),
                   ),
                 ],
               ),
             ),
             Transform.translate(
               offset: Offset(animatedPosition * (70*scale - 35*scale), -5*scale),
               child: Container(
                 width: 35*scale,
                 height: 35*scale,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     colors: [backgroundColor, const Color(0xFFDADADA)],
                     begin: Alignment.centerLeft,
                     end: Alignment.centerRight,
                   ),
                   borderRadius: BorderRadius.circular(50*scale),
                   boxShadow: [
                     BoxShadow(color: shadowColor, blurRadius: 6),
                   ]
                 ),
                 child: Container(

                 ),
               ),
             )
           ],
         ),
       ),
    );
  }
}
