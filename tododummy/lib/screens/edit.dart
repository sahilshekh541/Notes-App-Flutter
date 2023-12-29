import 'package:flutter/material.dart';
import 'package:tododummy/models/notes.dart';

class EditPage extends StatefulWidget {
  final Note? note;
  const EditPage({super.key, this.note});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _titletext = TextEditingController();
  TextEditingController _contenttext = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titletext.text = widget.note!.title;
      _contenttext.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade800.withOpacity(.8)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _titletext,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 35)),
                ),
                TextField(
                  controller: _contenttext,
                  maxLines: null,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'type something here ...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, [_titletext.text, _contenttext.text]);
        },
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.save,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
