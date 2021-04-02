import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ResultModel {

  List<NoteModel> notes;

  ResultModel({this.notes});

  factory ResultModel.fromJson(Map<String, dynamic> map) {
    var listNote = (map['notes'] as List<dynamic>).map((list) => NoteModel.fromJson(list)).toList();
    return ResultModel( notes: listNote );
  }

  @override
  String toString() {
    return 'ResultModel{notes: $notes}';
  }
}

class NoteModel {

  String id;
  String note;

  NoteModel(this.id, this.note);

  NoteModel.fromJson(Map<String, dynamic> map) : id = map['id'], note = map['note'];

  @override
  String toString() {
    return 'NoteModel{id: $id, note: $note}';
  }
}