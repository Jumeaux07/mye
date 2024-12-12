import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';

class TagTextField extends StatefulWidget {
  final void Function(List<String> tags) onTagsChanged;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  const TagTextField({
    Key? key,
    required this.onTagsChanged,
    this.hintText,
    this.hintStyle,
    this.textStyle,
  }) : super(key: key);

  @override
  _TagTextFieldState createState() => _TagTextFieldState();
}

class _TagTextFieldState extends State<TagTextField> {
  final TextEditingController _controller = TextEditingController();
  final ProfileDetailController _profile_detail_controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    String text = _controller.text;

    // Vérifie si le dernier caractère est un espace ou une virgule
    if (text.isNotEmpty && (text.endsWith(' ') || text.endsWith(','))) {
      // Nettoie et ajoute le tag
      String newTag = text.substring(0, text.length - 1).trim();

      if (newTag.isNotEmpty &&
          !_profile_detail_controller.tags.contains(newTag)) {
        setState(() {
          _profile_detail_controller.tags.add(newTag);
          _controller.clear();
        });

        // Appelle le callback avec la liste mise à jour des tags
        widget.onTagsChanged(_profile_detail_controller.tags);
      }
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _profile_detail_controller.tags.remove(tag);
    });
    widget.onTagsChanged(_profile_detail_controller.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage des tags existants
            if (_profile_detail_controller.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _profile_detail_controller.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                    deleteIcon: Icon(Icons.close, size: 18),
                  );
                }).toList(),
              ),

            // Champ de texte pour la saisie
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText ??
                    'Entrez vos tags (espace ou virgule pour valider)',
                hintStyle: widget.hintStyle,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                focusColor: Color(0xFFCBA948),
                hoverColor: Color(0xFFCBA948),
              ),
              style: widget.textStyle,
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}