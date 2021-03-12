import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/model/submit_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/util/string_util.dart';

class Update extends StatelessWidget {

  String id;
  String note;

  Update(this.id, this.note);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Edit")),
      body: Container (
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              initialValue: note,
              decoration: InputDecoration (
                border: InputBorder.none,
                hintText: 'Tulis catatan..',
              ),
              minLines: 3,
              maxLines: 5,
              onChanged: (String text){
                note = text;
              },
            ),
            MaterialButton(
                color: Colors.blue,
                minWidth: 200,
                shape: RoundedRectangleBorder (
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Simpan Perubahan', style: TextStyle (color: Colors.white),),
                onPressed: () {
                  updateNote( context, id, note);
                }
            )
          ],
        ),
      ),
    );
  }

  updateNote(BuildContext context, String id, String note) async {
    final request = await http.put(
        "${StringUtil.baseUrl}update.php",
        body: {
          "id": id,
          "note": note
        }
    );
    var response = json.decode( request.body );
    var submit = SubmitModel.fromJson(response);
    Fluttertoast.showToast(msg: submit.message);
    Navigator.of(context).pop(true);
  }
}
