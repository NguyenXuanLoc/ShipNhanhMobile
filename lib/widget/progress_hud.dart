// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/color/color.dart';

class ProgressHUD extends StatefulWidget {
  final Color backgroundColor;
  final Color color;
  final Color containerColor;
  final double borderRadius;
  final String text;
  final bool loading;
  final _ProgressHUDState state = _ProgressHUDState();

  ProgressHUD(
      {Key key,
      this.backgroundColor = Colors.black12,
      this.color = AppColors.colorAccent,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text,
      this.loading = true})
      : super(key: key);

  @override
  _ProgressHUDState createState() => state;
}

class _ProgressHUDState extends State<ProgressHUD> {
  bool visible = true;

  @override
  void initState() {
    super.initState();

    visible = widget.loading;
  }

  void dismiss() {
    setState(() {
      visible = false;
    });
  }

  void show() {
    setState(() {
      visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (visible) {
      return Scaffold(
          backgroundColor: widget.backgroundColor,
          body: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: widget.containerColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius))),
                ),
              ),
              Center(
                child: _getCenterContent(),
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  Widget _getCenterContent() {
    if (widget.text == null || widget.text.isEmpty) {
      return _getCircularProgress();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getCircularProgress(),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: Text(
              widget.text,
              style: TextStyle(color: widget.color),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(widget.color));
  }
}
