import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UtilTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPasswordTextField;
  final FormFieldValidator<String> validator;
  final String errorText;
  final double bottomPadding;
  final int maxLength;
  final int errorMaxLines;

  UtilTextFormField(this.labelText, this.controller, {
    this.isPasswordTextField = false,
    this.validator,
    this.errorText,
    this.bottomPadding = 35.0,
    this.maxLength,
    this.errorMaxLines = 3,
    Key key,
  }) : super(key: key);

  @override
  _UtilTextFormFieldState createState() => _UtilTextFormFieldState();
}

class _UtilTextFormFieldState extends State<UtilTextFormField> {
  bool _hidePassword;

  @override
  void initState() {
    super.initState();
    _hidePassword = widget.isPasswordTextField;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      child: TextFormField(
        obscureText: _hidePassword,
        decoration: InputDecoration(
          suffixIcon: _hidePassword
              ? IconButton(
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.grey,
            ),
          )
              : null,
          //contentPadding: EdgeInsets.only(bottom: 3),
          labelText: widget.labelText,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          errorText: widget.errorText,
          errorMaxLines: widget.errorMaxLines,
        ),
        controller: widget.controller,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp('[ ]')),
        ],
        validator: widget.validator,
        maxLength: widget.maxLength,
      ),
    );
  }
}