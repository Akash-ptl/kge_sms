// import 'package:flutter/material.dart';
//
// class CustomFirstTextField extends StatelessWidget {
//   const CustomFirstTextField({
//     super.key,
//     required this.heading,
//     required this.hintText,
//     this.preIcon,
//     this.sufIcon,
//     required this.controller,
//     this.keyboardType,
//     this.maxLength,
//   });
//
//   final int? maxLength;
//   final String heading;
//   final String hintText;
//   final IconData? preIcon;
//   final IconData? sufIcon;
//   final TextEditingController controller;
//   final TextInputType? keyboardType;
//
//   @override
//   Widget build(BuildContext context) {
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;
//     return Container(
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(w * 0.02)),
//       height: h * 0.055,
//       child: TextField(
//         maxLength: maxLength,
//         keyboardType: keyboardType,
//         controller: controller,
//         decoration: InputDecoration(
//           fillColor: Colors.white,
//           counterText: "",
//           hintText: hintText,
//           hintStyle:
//               const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//           prefixIcon: preIcon != null
//               ? Icon(
//                   preIcon,
//                   color: Colors.grey.shade600,
//                 )
//               : null,
//           suffixIcon: sufIcon != null
//               ? Icon(
//                   sufIcon,
//                   color: Colors.grey.shade600,
//                 )
//               : null,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 18),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.transparent,
//             ),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.transparent,
//               // width: .0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomFirstTextField extends StatefulWidget {
  const CustomFirstTextField({
    super.key,
    required this.heading,
    required this.hintText,
    this.preIcon,
    this.sufIcon,
    required this.controller,
    this.keyboardType,
    this.maxLength,
    this.obscureTextEnabled = false, // new parameter
  });

  final int? maxLength;
  final String heading;
  final String hintText;
  final IconData? preIcon;
  final IconData? sufIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureTextEnabled; // new parameter

  @override
  _CustomFirstTextFieldState createState() => _CustomFirstTextFieldState();
}

class _CustomFirstTextFieldState extends State<CustomFirstTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget
        .obscureTextEnabled; // initialize _obscureText based on obscureTextEnabled
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.02)),
      height: h * 0.055,
      child: TextField(
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          counterText: "",
          hintText: widget.hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
          prefixIcon: widget.preIcon != null
              ? Icon(
                  widget.preIcon,
                  color: Colors.grey.shade600,
                )
              : null,
          suffixIcon: widget
                  .obscureTextEnabled // only show suffix icon if obscureTextEnabled is true
              ? _obscureText
                  ? IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              // width:.0,
            ),
          ),
        ),
      ),
    );
  }
}
