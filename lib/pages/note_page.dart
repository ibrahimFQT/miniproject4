import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NotePage extends StatefulWidget {
  final Note? note;

  const NotePage({super.key, this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final authorController = TextEditingController();

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
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, "delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: saveNote, // auto save saat back
        ),
        actions: [
          IconButton(
            onPressed: deleteNote,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TITLE =====
            TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: "Judul",
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 10),

            // ===== CONTENT =====
            Expanded(
              child: TextField(
                controller: contentController,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Tulis catatan...",
                  border: InputBorder.none,
                ),
              ),
            ),

            // ===== DIVIDER =====
            Divider(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 6),

            // ===== AUTHOR =====
            TextField(
              controller: authorController,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: const InputDecoration(
                hintText: "Ditulis oleh...",
                border: InputBorder.none,
              ),
            ),

            // const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}