import 'package:flutter/material.dart';
import 'package:noteapp/models/note_model.dart';

class NoteCard extends StatefulWidget {
  final Note? note;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NoteCard({
    super.key,
    this.note,
    this.onEdit,
    this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onEdit,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.note?.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Text(
                  widget.note?.content ?? "",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.note?.author ?? "",
                style: Theme.of(context).textTheme.bodySmall,
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}