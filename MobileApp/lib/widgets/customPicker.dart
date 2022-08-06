// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

const double _kItemExtent = 32.0;

class CustomPicker extends StatefulWidget {
  const CustomPicker(
      {Key? key,
      required this.placeHolder,
      required this.options,
      required this.onChange})
      : super(key: key);
  final String placeHolder;
  final Function onChange;
  final List<String> options;
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int _selectedFruit = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 260,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: Color(0xffff5b00).withOpacity(.5),
              
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CupertinoPageScaffold(
          backgroundColor: const Color(0xffff5b00),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Color(0xffff5b00),
              fontSize: 20,
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.placeHolder + " ",
                      style: const TextStyle(color: Colors.white,fontSize: 18),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,

                      // Display a CupertinoPicker with list of fruits.
                      onPressed: () => _showDialog(
                        CupertinoPicker(
                          // magnification: 2,
                          // squeeze:1,
                          // useMagnifier: true,
                          itemExtent: _kItemExtent,
  
                          // looping: true,
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            widget.onChange(selectedItem);
                            setState(() {
                              _selectedFruit = selectedItem;
                            });
                          },
                          children: List<Widget>.generate(widget.options.length,
                              (int index) {
                            return Center(
                              child: Text(
                                widget.options[index].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      // This displays the selected fruit name.
                      child: Row(
                        children: [
                          Text(
                            widget.options[_selectedFruit],
                            style:  TextStyle(
                              fontSize: 18.0,
                              color: Colors.white.withOpacity(0.8)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset("assets/arrowDown.svg",color: Colors.white,),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
