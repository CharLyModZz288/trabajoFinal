import 'package:flutter/material.dart';

class CustomPhoneTextField extends StatelessWidget{

  String sHint;
  TextEditingController tecController;
  bool blIsPassword;
  double dPaddingH;
  double dPaddingV;

  CustomPhoneTextField({Key? key,
    this.sHint="",
    required this.tecController,
    this.blIsPassword=false,
    this.dPaddingH=60,
    this.dPaddingV=15
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Padding(padding: EdgeInsets.symmetric(horizontal: dPaddingH, vertical: dPaddingV),
      child: Row(children: [
        Flexible(
          child: TextFormField(
              controller: tecController,
              obscureText: blIsPassword,
              enableSuggestions: !blIsPassword,
              autocorrect: !blIsPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                //hintText: sHint,
                fillColor: Colors.greenAccent,
                filled: true,
                labelText: sHint,
                suffixIcon:Icon(Icons.check_circle),
                prefixIcon: Icon(Icons.check_circle),
              )),
        ),
        //Image.network("https://media.tenor.com/zBc1XhcbTSoAAAAC/nyan-cat-rainbow.gif",width: 80, height:80),
      ],
      ),
    );


  }

}