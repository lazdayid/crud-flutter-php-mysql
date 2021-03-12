class NoteModel {
  
  String id;
  String note;
  NoteModel(this.id, this.note);
  NoteModel.fromJson(Map<String, dynamic> map) : id = map['id'], note = map['note'];

}