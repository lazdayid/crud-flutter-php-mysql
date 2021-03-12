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

  @override
  void initState() {
    getNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      appBar: AppBar (title: Text('Crud Flutter'),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Create(),
            ),
          ).then((value) => getNote());
        },
        child: Icon(Icons.add),
      ),
      body:Container (
        margin: EdgeInsets.all(10),
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
                            builder: (context) => Update(notes[position].id, notes[position].note),
                          ),
                        ).then((value) => getNote());
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
        ),
      ),
    );
  }

  getNote() async {
    var request = await http.get("${StringUtil.baseUrl}data.php");
    var response = json.decode( request.body );
    var data = (response['notes'] as List)
        .map((notes) => NoteModel.fromJson(notes)).toList();
    data.forEach((element) { print(element.note); });
    setState(() {
      notes = data;
    });
  }

  deleteNote(String id) async {
    final request = await http.post(
        "${StringUtil.baseUrl}delete.php",
        body: {
          "id": id
        }
    );
    var response = json.decode( request.body );
    var submit = SubmitModel.fromJson(response);
    Fluttertoast.showToast(msg: submit.message);
    getNote();
  }
}
