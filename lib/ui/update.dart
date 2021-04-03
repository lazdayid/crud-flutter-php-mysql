import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/model/note_model.dart';
import 'package:flutter_crud/model/submit_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/util/api_util.dart';

class Update extends StatefulWidget {

  NoteModel data;
  Update(this.data);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Edit")),
      body: Container (
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.data.note,
              decoration: InputDecoration (
                border: InputBorder.none,
                hintText: 'Tulis catatan..',
              ),
              minLines: 3,
              maxLines: 5,
              onChanged: (String text){
                widget.data.note = text;
              },
            ),
            MaterialButton(
                color: isLoading ? Colors.grey : Colors.blue,
                minWidth: 200,
                shape: RoundedRectangleBorder (
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(isLoading ? 'Menyimpan Perubahan..' : 'Simpan Perubahan', style: TextStyle (color: Colors.white),),
                onPressed: () {
                  updateNote( context );
                }
            )
          ],
        ),
      ),
    );
  }

  updateNote(BuildContext context) async {

    setState(() => isLoading = true );
    final response = await http.put(
        ApiUtil.baseUrl("update.php"),
        body: {
          "id": widget.data.id,
          "note": widget.data.note
        }
    );

    if (response.statusCode == 200) {
      var submit = SubmitModel.fromJson( jsonDecode( response.body ) );
      Fluttertoast.showToast(msg: submit.message);
      Navigator.of(context).pop(true);
    } else Fluttertoast.showToast(msg: "Terjadi kesalahan");

  }

}
