import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String notes;
  String title;
  String image;
  Timestamp createdAt;
  NoteModel({
    required this.notes,
    required this.title,
    required this.createdAt,
    required this.image,
  });

  NoteModel copyWith({
    String? notes,
    String? title,
    String? image,
    Timestamp? createdAt,
  }) {
    return NoteModel(
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'title': title,
      'image': image,
      'createdAt': createdAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      notes: map['notes'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      title: map['title'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source));

  @override
  String toString() => 'NoteModel(notes: $notes, title: $title, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteModel &&
        other.notes == notes &&
        other.title == title &&
        other.image == image;
  }

  @override
  int get hashCode => notes.hashCode ^ title.hashCode ^ image.hashCode;
}
