import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/model/note_model.dart';
import 'package:flutter_crud/model/submit_model.dart';
import 'package:flutter_crud/ui/create.dart';
import 'package:flutter_crud/ui/update.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/util/string_util.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<NoteModel> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    listNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      appBar: AppBar (title: Text('Catatan'),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Create(),
            ),
          ).then((value) => listNote());
        },
        child: Icon(Icons.add),
      ),
      body: Container (
        margin: EdgeInsets.all(10),
        child: Column (
          children: [
            Container(
              child: isLoading ? Container(
                padding: EdgeInsets.all(10.0),
                child: LinearProgressIndicator(),
              )  : null ,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, position) {
                      return Dismissible(
                        key: Key(notes[position].id),
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder (
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: InkWell(
                              child: Padding (
                                padding: EdgeInsets.all(15),
                                child: Text( notes[position].note, style: TextStyle(fontSize: 16 ), ),
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Update( notes[position] ),
                                  ),
                                ).then((value) => listNote());
                              },
                            ),
                          ),
                        ),
                        onDismissed: (direction){
                          setState(() {
                            deleteNote(notes[position].id);
                            notes.removeAt(position);
                          });
                        },
                      );
                    }
                )
            )
          ],
        ),
      ),
    );
  }

  listNote() async {
    setState(() => isLoading = true );
    var response = await http.get("${StringUtil.baseUrl}data.php");
    if (response.statusCode == 200) {
      var result = ResultModel.fromJson( jsonDecode( response.body ) );
      print("notes ${result.notes.toString()}");
      setState(() {
        notes = result.notes;
        isLoading = false;
      });
    } else Fluttertoast.showToast(msg: "Terjadi kesalahan");
  }

  deleteNote(String id) async {
    final response = await http.post(
        "${StringUtil.baseUrl}delete.php",
        body: {
          "id": id
        }
    );
    if (response.statusCode == 200) {
      var submit = SubmitModel.fromJson( jsonDecode( response.body ) );
      Fluttertoast.showToast(msg: submit.message);
    } else Fluttertoast.showToast(msg: "Terjadi kesalahan");
  }
}
