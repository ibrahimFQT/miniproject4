import 'package:flutter/material.dart';
import '../../models/note_model.dart';

class NoteCard extends StatefulWidget {
  final Note? note;
  const NoteCard({super.key, this.note, required void Function() onEdit, required void Function() onDelete});
  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      authorController.text = widget.note!.author;
    }
  }

  void saveNote() {
    final note = Note(
      title: titleController.text,
      content: contentController.text,
      author: authorController.text,
    );
    Navigator.pop(context, note);
  }

  void deleteNote() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pop(context, "delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: saveNote),
        actions: [IconButton(onPressed: deleteNote, icon: Icon(Icons.delete))],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(
                hint: Text("judul"),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: contentController,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hint: Text("isi"),
                ),
              ),
            ),

            Divider(color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 12),
            TextField(
              controller: authorController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                hint: Text("ditulis oleh"),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}