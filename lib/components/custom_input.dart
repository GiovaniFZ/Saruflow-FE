import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;
  final TextInputType type;
  final bool obscureText;
  final TextEditingController? controller; // <-- novo

  const CustomInput({
    super.key,
    required this.label,
    this.color = const Color(0x00D5D4D4),
    this.textColor = Colors.black,
    this.type = TextInputType.text,
    this.obscureText = false,
    this.controller, // <-- novo
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextEditingController _controller;
  late bool _ownController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownController = false;
    } else {
      _controller = TextEditingController();
      _ownController = true;
    }
  }

  @override
  void dispose() {
    if (_ownController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text(widget.label)),
        TextField(
          controller: _controller,
          keyboardType: widget.type,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: widget.textColor),
            filled: true,
            fillColor: widget.color,
          ),
          onTap: () async {
            final isDate = widget.type == TextInputType.datetime;
            if (!isDate) return;
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              _controller.text = "${picked.day}/${picked.month}/${picked.year}";
            }
          },
        ),
      ],
    );
  }
}
