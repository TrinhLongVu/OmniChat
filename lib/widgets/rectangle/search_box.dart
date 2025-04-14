import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController ctrlr;
  final String placeholder;
  final Function onSearch;
  final FocusNode? focusNod;

  const SearchBox({
    super.key,
    required this.ctrlr,
    required this.placeholder,
    required this.onSearch,
    this.focusNod,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNod,
      controller: ctrlr,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffB0B0B0).withValues(alpha: 0.1),
        hintText: placeholder,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black.withValues(alpha: 0.6),
        ),
        suffixIcon:
            ctrlr.text.isEmpty
                ? null
                : IconButton(
                  onPressed: () => {ctrlr.clear(), onSearch(ctrlr.text)},
                  icon: Icon(Icons.clear),
                  color: Colors.black.withValues(alpha: 0.6),
                ),
      ),
      onChanged: (value) => onSearch(value),
    );
  }
}
