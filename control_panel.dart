import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:snake_game/control_button.dart';
import 'package:snake_game/direction.dart';
class ControlPanel extends StatelessWidget {

   final void Function(Direction direction) onTaped;
  const ControlPanel({Key? key, required this.onTaped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0.0,
        right: 10.0,
        bottom: 50.0,
        child: Row(
        children: [
        Expanded(child: Row(
         children: [
           Expanded(child: Container(),),
           ControlButton(onPressed: () {
             onTaped(Direction.left);
           },
             icon: Icon(Icons.arrow_left),
           ),
         ],
        ),),
          Expanded(child: Column(
            children: [
              ControlButton(onPressed: () {
                onTaped(Direction.up);
              },
                icon: Icon(Icons.arrow_drop_up),
              ),
              SizedBox(
                height: 70.0,
              ),
              ControlButton(onPressed: () {
                onTaped(Direction.down);
              },
                icon: Icon(Icons.arrow_drop_down),
              ),
            ],
          )),
          Expanded(child: Row(
            children: [
              ControlButton(onPressed: () {
                onTaped(Direction.right);
              },
                icon: Icon(Icons.arrow_right),
              ),
              Expanded(child: Container(),),
            ],
          ),),

      ],
    )
    );
  }
}

