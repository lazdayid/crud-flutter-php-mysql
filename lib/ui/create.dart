import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/model/submit_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/util/string_util.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {

  String note = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Note")),
      body: Container (
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
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
                child: Text('Simpan', style: TextStyle (color: Colors.white),),
                onPressed: () {
                  addNote( note );
                }
            )
          ],
        ),
      ),
    );
  }

  addNote(String note) async {
    final request = await http.post(
        "${StringUtil.baseUrl}create.php",
        body: {
          "note": note
        }
    );
    var response = json.decode( request.body );
    var submit = SubmitModel.fromJson(response);
    Fluttertoast.showToast(msg: submit.message);
    Navigator.of(context).pop(true);
  }
}
