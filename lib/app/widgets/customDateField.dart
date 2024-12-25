import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatefulWidget {
  const CustomDateField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd/MM/yyyy',
    this.onDateSelected,
    this.decoration,
    this.errorStyle,
    this.labelStyle,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;
  final Function(DateTime)? onDateSelected;
  final InputDecoration? decoration;
  final TextStyle? errorStyle;
  final TextStyle? labelStyle;

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  String? _errorText;
  final FocusNode _focusNode = FocusNode();
  late final DateFormat _dateFormatter;

  @override
  void initState() {
    super.initState();
    _dateFormatter = DateFormat(widget.dateFormat);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateDate(widget.controller.text);
    }
  }

  Future<void> _showDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFCBA948),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = _dateFormatter.format(picked);
        _errorText = null;
      });
      widget.onDateSelected?.call(picked);
    }
  }

  void _validateDate(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = "${widget.label} est obligatoire";
      });
      return;
    }

    try {
      final date = _dateFormatter.parse(value);
      if (widget.firstDate != null && date.isBefore(widget.firstDate!)) {
        setState(() {
          _errorText = "La date doit être après ${_dateFormatter.format(widget.firstDate!)}";
        });
        return;
      }
      if (widget.lastDate != null && date.isAfter(widget.lastDate!)) {
        setState(() {
          _errorText = "La date doit être avant ${_dateFormatter.format(widget.lastDate!)}";
        });
        return;
      }
      setState(() {
        _errorText = null;
      });
    } catch (e) {
      setState(() {
        _errorText = "Format de date invalide (${widget.dateFormat})";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.labelStyle ??
              const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: _validateDate,
          keyboardType: TextInputType.datetime,
          decoration: (widget.decoration ?? const InputDecoration())
              .copyWith(
                errorText: _errorText,
                errorStyle: widget.errorStyle,
                hintText: widget.hintText ?? widget.dateFormat,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _showDatePicker,
                  color: const Color(0xFFCBA948),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Color(0xFFCBA948),
                  ),
                ),
              ),
        ),
      ],
    );
  }
}