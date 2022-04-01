import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/app_colors.dart';
import '../../model/note_model.dart';

class AddNoteBottomSheet extends StatefulWidget {
  const AddNoteBottomSheet({Key? key, this.noteModel, this.id})
      : super(key: key);
  final NoteModel? noteModel;
  final String? id;

  @override
  State<AddNoteBottomSheet> createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  XFile? file;
  NoteModel? get noteModel => widget.noteModel;
  late TextEditingController title =
      TextEditingController(text: noteModel?.title);
  late TextEditingController desc =
      TextEditingController(text: noteModel?.notes);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 31, bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 240,
            height: 28,
            margin: const EdgeInsets.only(top: 34),
            child: const Text(
              'Add Item',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 24,
                  letterSpacing: 0.1),
            ),
          ),
          InkWell(
            onTap: () {
              ImagePicker()
                  .pickImage(source: ImageSource.gallery)
                  .then((value) {
                setState(() {
                  file = value;
                });
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width: 109,
              height: 109,
              child: noteModel != null && file == null
                  ? Image.network(noteModel!.image)
                  : file == null
                      ? Image.asset('assets/image/pick.png')
                      : Image.file(File(file!.path)),
            ),
          ),
          Container(
            width: 358,
            height: 56,
            margin: EdgeInsets.only(top: 22, right: 32),
            child: TextFormField(
                controller: title,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(
                    Icons.call_outlined,
                    color: AppColors.icon,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "input",
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF79747E),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
          ),
          Container(
            width: 358,
            height: 56,
            margin: EdgeInsets.only(top: 22, right: 32),
            child: TextFormField(
                controller: desc,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(
                    Icons.call_outlined,
                    color: AppColors.icon,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "input",
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF79747E),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
          ),
          Container(
            width: 358,
            margin: const EdgeInsets.only(right: 32, top: 22),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              color: AppColors.m3primary,
              height: 40,
              child: const Center(
                  child: Text(
                'Save',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: AppColors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1),
                textAlign: TextAlign.center,
              )),
              onPressed: () async {
                User user = FirebaseAuth.instance.currentUser!;
                if (noteModel == null) {
                  UploadTask task = FirebaseStorage.instance
                      .ref()
                      .child(user.uid)
                      .child(DateTime.now().toString())
                      .putFile(
                        File(file!.path),
                      );
                  TaskSnapshot snapshot = await Future.value(task);
                  String url = await snapshot.ref.getDownloadURL();
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('notes')
                      .add(
                        NoteModel(
                                notes: desc.text,
                                title: title.text,
                                createdAt: Timestamp.now(),
                                image: url)
                            .toMap(),
                      );
                } else {
                  String url = noteModel!.image;
                  if (file != null) {
                    UploadTask task = FirebaseStorage.instance
                        .ref()
                        .child(user.uid)
                        .child(
                          DateTime.now().toString(),
                        )
                        .putFile(File(file!.path));
                    TaskSnapshot snapshot = await Future.value(task);
                    url = await snapshot.ref.getDownloadURL();
                  }
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('notes')
                      .doc(widget.id)
                      .update(
                        noteModel!
                            .copyWith(
                              notes: desc.text,
                              title: title.text,
                              image: url,
                            )
                            .toMap(),
                      );
                }
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
