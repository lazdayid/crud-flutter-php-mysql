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
  bool isLoading = false;

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
                color: isLoading ? Colors.grey : Colors.blue,
                minWidth: 200,
                shape: RoundedRectangleBorder (
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text( isLoading ? 'Menyimpan..' : 'Simpan' , style: TextStyle (color: Colors.white),),
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

    setState(() => isLoading = true );

    final response = await http.post(
        "${StringUtil.baseUrl}create.php",
        body: {
          "note": note
        }
    );

    if (response.statusCode == 200) {
      var submit = SubmitModel.fromJson( jsonDecode( response.body ) );
      Fluttertoast.showToast(msg: submit.message);
      Navigator.of(context).pop(true);
    } else Fluttertoast.showToast(msg: "Terjadi kesalahan");
  }
}
