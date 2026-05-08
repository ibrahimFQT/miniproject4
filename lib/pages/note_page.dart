import 'package:flutter/material.dart';
import 'package:note_apk/models/note_models.dart';

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

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      authorController.text = widget.note!.author;
    }
  }

  // ✅ SAVE
  void saveNote() {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    if (!mounted) return;

    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    final now = DateTime.now().toIso8601String();

    final note = Note(
      title: titleController.text,
      content: contentController.text,
      author: authorController.text,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );

    Navigator.pop(context, note);
  }

  // ✅ DELETE
  void deleteNote() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus catatan ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (confirm == true) {
      Navigator.pop(context, widget.note);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _isSaving) return;

        setState(() {
          _isSaving = true;
        });

        final navigator = Navigator.of(context);

        saveNote();

        navigator.pop();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note == null ? "Tambah Note" : "Edit Note",
          ),
          actions: [
            if (widget.note != null)
              IconButton(
                onPressed: deleteNote,
                icon: const Icon(Icons.delete),
              ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Judul",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: "Isi",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),

              const SizedBox(height: 16),

              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: "Author",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : saveNote,
                  child: Text(
                    _isSaving ? "Menyimpan..." : "Simpan",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}