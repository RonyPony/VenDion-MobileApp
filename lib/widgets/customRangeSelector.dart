import 'package:flutter/material.dart';

class CustomRangeSelect extends StatefulWidget {
  const CustomRangeSelect(
      {Key? key, required Null Function(RangeValues valores) onChange, required this.min, required this.max})
      : super(key: key);
      final double min;
      final double max;

  @override
  State<CustomRangeSelect> createState() => _CustomRangeSelectState();
}

class _CustomRangeSelectState extends State<CustomRangeSelect> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: _currentRangeValues,
          max: widget.max,
          
          divisions: 100,
          activeColor: Color(0xffff5b00),
          min: widget.min,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        Row(
          children: [
            Text(
              "US.${_currentRangeValues.start.round()}  -  US. ${_currentRangeValues.end}",
              style: TextStyle(
                color: Color(0xff8c9199),
                fontSize: 14,
                fontFamily: "Lato",
                fontWeight: FontWeight.w500,
              ),
            ),
            
          ],
        )
      ],
    );
  }
}
