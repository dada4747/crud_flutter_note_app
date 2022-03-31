import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';
import '../../model/note_model.dart';
import 'bottom_sheet.dart';

class ListBuilder extends StatelessWidget {
  const ListBuilder(
      {Key? key,
      required this.title,
      required this.desc,
      required this.image,
      required this.time})
      : super(key: key);
  final String title;
  final String desc;
  final String image;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
        ),
        child: Image.network(
          image,
          fit: BoxFit.fill,
          // height: 80,
        ),
      ),
      Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 16),
              child: Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.descColor,
                    letterSpacing: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4, bottom: 16),
              child: Text(
                desc,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.descColor,
                    letterSpacing: 0.25),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => AddNoteBottomSheet(
                      noteModel: NoteModel(
                          image: image,
                          title: title,
                          notes: desc,
                          createdAt: time),
                    ));
          },
          child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 20, top: 20, left: 235
                  // left: 200,
                  ),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.iconBackColor),
              child: Center(
                child: SizedBox(
                    width: 18,
                    height: 18,
                    child: Image.asset('assets/image/icon.png')),
              )),
        )
      ]),
    ]);
  }
}
