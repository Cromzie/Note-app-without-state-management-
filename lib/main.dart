import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyCrud(),
  ));
}

class MyCrud extends StatefulWidget {
  const MyCrud({Key? key}) : super(key: key);

  @override
  State<MyCrud> createState() => _MyCrudState();
}

class _MyCrudState extends State<MyCrud> {
  bool isSearching = false;
  bool isEditing = false;
  List<String> allMyNotes = [];
  List<String> mySearchedNotes = [];
  TextEditingController notecontroller = TextEditingController();
  int noteIndex = 0;

  void searchFunction(String searchWords) {
    setState(() {
      mySearchedNotes = [];
    });
    if (searchWords != '') {
      var searched = allMyNotes
          .where((element) =>
              element.toLowerCase().contains(notecontroller.text.toLowerCase()))
          .toList();
      setState(() {
        mySearchedNotes.addAll(searched);
      });
    } else {
      setState(() {
        mySearchedNotes = [...allMyNotes];
      });
    }
  }

  void editFunction(int index) {
    setState(() {
      isEditing = !isEditing;
      noteIndex = index;
      var theEdited = allMyNotes[index];
      notecontroller.text = theEdited;
    });
  }

  void deleteNote(int index) {
    setState(() {
      allMyNotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('My First Crud'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: Icon(Icons.search)),
          // IconButton(onPressed: () {}, icon: Icon(Icons.backspace_outlined)),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            maxLength: 1000,
            maxLines: null,
            onChanged: (searchWords) {
              setState(() {
                isSearching ? searchFunction(searchWords) : null;
              });
            },
            controller: notecontroller,
            cursorColor: Colors.lime.shade200,
            cursorWidth: 4.0,
            decoration: InputDecoration(
              hintText: isSearching ? 'Search Note' : 'Input Your Note',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime.shade100)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime.shade100),
                  borderRadius: BorderRadius.all(Radius.circular(2.5))),
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.amberAccent)),
              onPressed: () {
                if (isEditing) {
                  setState(() {
                    allMyNotes[noteIndex] = notecontroller.text;
                    notecontroller.clear();
                    isEditing = false;
                  });
                } else {
                  if (notecontroller.text != '') {
                    setState(() {
                      allMyNotes.add(notecontroller.text);
                      notecontroller.clear();
                    });
                  }
                }
              },
              child: Text(isEditing ? 'Edit Note' : 'Add Note')),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              itemCount:
                  isSearching ? mySearchedNotes.length : allMyNotes.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) => Card(
                child: ListTile(
                  onTap: () {
                    Text(isSearching
                        ? mySearchedNotes[index]
                        : allMyNotes[index]);
                  },
                  tileColor: Colors.lime,
                  title: isSearching
                      ? Text(mySearchedNotes[index])
                      : Text(allMyNotes[index]),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            editFunction(index);
                          },
                          icon: Icon(Icons.edit, color: Colors.white60)),
                      IconButton(
                          onPressed: () {
                            _buildAlert(index);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red.shade200,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildAlert(index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure you would like to delete this note?',
                    style: TextStyle(color: Colors.red),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.amberAccent)),
                        onPressed: () {
                          deleteNote(index);
                          Navigator.pop(context);
                        },
                        child: Text('Yes'),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.amberAccent)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }
}
