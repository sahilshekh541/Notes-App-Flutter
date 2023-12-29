import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tododummy/constants/colors.dart';
import 'package:tododummy/models/notes.dart';
import 'package:tododummy/screens/edit.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isfiltered = false;
  List<Note> filterednotes = [];

  randombackgreoundcolor() {
    Random random = Random();
    return backgroundcolor[random.nextInt(backgroundcolor.length)];
  }

  deletenote(int index) {
    setState(() {
      Note note = samplenotes[index];
      samplenotes.remove(note);
      filterednotes.removeAt(index);
    });
  }

  List<Note> filter(List<Note> notes) {
    if (isfiltered) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((a, b) => b.modifiedTime.compareTo(a.modifiedTime));
    }
    isfiltered = !isfiltered;
    return notes;
  }

  onsearchtextchanged(String searchtext) {
    setState(() {
      filterednotes = samplenotes
          .where((note) =>
              note.title.toLowerCase().contains(searchtext.toLowerCase()) ||
              note.content.toLowerCase().contains(searchtext.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    filterednotes = samplenotes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notes',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade800.withOpacity(.8)),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      filter(filterednotes);
                    });
                  },
                  icon: const Icon(
                    Icons.sort_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: onsearchtextchanged,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 22,
                ),
                filled: true,
                fillColor: Colors.grey.shade800,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    )),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 21),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ))),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filterednotes.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              note: filterednotes[index],
                            ),
                          ));

                      if (result != null) {
                        setState(() {
                          filterednotes[index] = Note(
                              id: filterednotes[index].id,
                              title: result[0],
                              content: result[1],
                              modifiedTime: DateTime.now());
                          filterednotes = samplenotes;
                        });
                      }
                    },
                    child: Card(
                      color: randombackgreoundcolor(),
                      margin: const EdgeInsets.only(bottom: 20),
                      shadowColor: Colors.white,
                      elevation: 3,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(top: 10, left: 20, right: 10),
                        title: RichText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: '${filterednotes[index].title}\n',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: samplenotes[index].content,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ])),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 5),
                          child: Text(
                            "Edited:${DateFormat('EEE MMM d, yyyy h:mm a').format(filterednotes[index].modifiedTime)}",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              final result = await showDialog(
                                  context: context,
                                  builder: (_) => confirmationdilouge());

                              if (result) {
                                deletenote(index);
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                            )),
                      ),
                    ),
                  );
                }),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => const EditPage()));

          if (result != null) {
            setState(() {
              samplenotes.add(Note(
                  id: samplenotes.length,
                  title: result[0],
                  content: result[1],
                  modifiedTime: DateTime.now()));
              filterednotes = samplenotes;
            });
          }
        },
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class confirmationdilouge extends StatelessWidget {
  const confirmationdilouge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      title: const Text(
        'Are you sure you Want to delete ?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      icon: const Icon(
        Icons.info,
        size: 40,
        color: Colors.white,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'No',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )
          ],
        )
      ],
    );
  }
}
