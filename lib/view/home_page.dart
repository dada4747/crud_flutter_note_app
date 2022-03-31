import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../constant/app_colors.dart';
import '../model/note_model.dart';
import 'widget/bottom_sheet.dart';
import 'widget/list_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ListView(physics: const NeverScrollableScrollPhysics(), children: <
          Widget>[
        PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            centerTitle: true,
            leadingWidth: 40,
            titleSpacing: 0.0,
            title: const Padding(
              padding:
                  EdgeInsets.only(left: 61, top: 18, right: 64, bottom: 18),
              child: SizedBox(
                child: Center(
                  child: Text(
                    "ITEMS",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                height: 28,
                width: 296,
              ),
            ),
            backgroundColor: AppColors.background,
          ),
        ),
        StreamBuilder<QuerySnapshot<NoteModel>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('notes')
              .orderBy('createdAt', descending: true)
              .withConverter<NoteModel>(
                fromFirestore: (s, o) => NoteModel.fromMap(s.data()!),
                toFirestore: (v, o) => v.toMap(),
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return SizedBox(
                height: 748,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 22, left: 19, right: 18),
                        height: 80,
                        width: 384,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.white,
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 16,
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                              )
                            ]),
                        child: Slidable(
                          direction: Axis.horizontal,
                          dragStartBehavior: DragStartBehavior.down,
                          closeOnScroll: true,
                          startActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const BehindMotion(),
                            closeThreshold: 0.1,
                            openThreshold: 0.1,
                            children: [
                              InkWell(
                                onTap: () {
                                  snapshot.data!.docs[index].reference.delete();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12)),
                                    color: AppColors.redDelete,
                                  ),
                                  width: 106,
                                  height: 80,
                                  child: const Icon(Icons.delete),
                                ),
                              )
                            ],
                          ),
                          child: ListBuilder(
                            title: snapshot.data!.docs[index].data().title,
                            desc: snapshot.data!.docs[index].data().notes,
                            image: snapshot.data!.docs[index].data().image,
                            time: snapshot.data!.docs[index].data().createdAt,
                          ),
                        ),
                      );
                    }),
              );
            }
            return Container();
          },
        ),
      ]),
      Positioned(
          bottom: 29,
          right: 30,
          child: Container(
              height: 69,
              width: 69,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 16,
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                )
              ]),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: AppColors.addBottonColor,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      elevation: 0,
                      clipBehavior: Clip.none,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                      ),
                      builder: (context) => const AddNoteBottomSheet());
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ))),
    ]));
  }
}
