// @dart = 2.9
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartship_partner/config/color/color.dart';
import 'package:smartship_partner/data/model/note_item_model.dart';

class NoteListItem extends StatelessWidget {
  NoteItemModel noteItem;
  Function(NoteItemModel) onNoteItemClicked;

  NoteListItem({this.noteItem, this.onNoteItemClicked});

  @override
  Widget build(BuildContext context) {
    var dt = noteItem.createdOn;
    var formatter = DateFormat('HH:mm dd/MM/yyyy');
    var noteDate = formatter.format(dt);

    var background = AppColors.colorYellowLight;
    var notes = 'Ghi chú';

    if (noteItem.orderLogType == 1) {
      background = AppColors.colorWhite;
      notes = 'Thay đổi tiền ship, ứng';
    }

    return Container(
      color: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10,
            height: 12,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  noteDate,
                  style: TextStyle(
                    color: AppColors.colorAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                  height: 5,
                ),
                Text(notes,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorBlackFade)),
                SizedBox(
                  width: 10,
                  height: 13,
                ),
                Text(
                  noteItem.notes,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorBlackFade),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Divider(
              height: 1,
              color: AppColors.colorGreyStroke,
            ),
          )
        ],
      ),
    );
  }
}
