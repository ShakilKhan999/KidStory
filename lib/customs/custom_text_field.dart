import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  String? hintText;
  String labelText;
  TextEditingController textEditingController;
  TextInputType inputType;
  double? fieldHeight;
  int? maxline;
  int? maxLength;
  String? Function(String?)? validator;
  bool validation;
  Widget? prefixIcon;
  bool isObscure;
  bool readOnly;
  int? minLine;

  // test

  CustomFormField({
    Key? key,
    this.hintText,
    required this.labelText,
    required this.textEditingController,
    required this.inputType,
    this.fieldHeight,
    this.maxline,
    this.validator,
    this.validation = false,
    this.prefixIcon,
    this.isObscure = false,
    this.maxLength,
    this.readOnly = false,
    this.minLine,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: SizedBox(
        height: widget.fieldHeight ?? 48,
        child: TextFormField(
          readOnly: widget.readOnly,
          obscureText:
              widget.isObscure == true ? isObscureText : widget.isObscure,
          cursorHeight: 20.0,
          autovalidateMode: widget.validation
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          validator: widget.validator,
          minLines: widget.minLine ?? 1,
          maxLines: widget.maxline ?? 1,
          controller: widget.textEditingController,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            hintText: widget.hintText,
            labelText: widget.labelText,
            counterText: '',
            hintStyle: TextStyle(
              letterSpacing: 1,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.grey[600],
            ),
            prefixIcon: widget.prefixIcon ??
                const SizedBox(
                  height: 0,
                  width: 0,
                ),
            suffixIcon: widget.isObscure == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    icon: isObscureText == false
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
            labelStyle: const TextStyle(
              letterSpacing: 1,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
            errorStyle: const TextStyle(
              letterSpacing: 1,
              fontSize: 14,
              fontWeight: FontWeight.w100,
              fontStyle: FontStyle.normal,
              color: Colors.red,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.grey[100]!,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.grey[100]!,
                width: 1.5,
              ),
            ),
          ),
          style: const TextStyle(
            letterSpacing: 1,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
          keyboardType: widget.inputType,
        ),
      ),
    );
  }
}
