import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icone;
  final String? erro;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    required this.icone,
    this.erro,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo),
        ),
        prefixIcon: Icon(icone),
        contentPadding: EdgeInsets.all(10),
        errorText: erro,
      ),
    );
  }
}
