// @dart = 2.9
import 'package:flutter/material.dart';

class AlertDialogTwoButton extends StatelessWidget {

  final title;
  final message;
  Function onYesClicked;
  Function() onNoClicked;

  AlertDialogTwoButton({@required this.title, @required this.message, @required this.onYesClicked, this.onNoClicked});

  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Không'),
      onPressed: (){
        Navigator.of(context).pop();
        if (onNoClicked != null) {
          onNoClicked();
        }
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Có'),
      onPressed: () {
        Navigator.of(context).pop();
        onYesClicked();
      },
    );

    // set up the AlertDialog
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    return alert;
  }
}
