import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/filters_screen.dart';

class SearchSection extends StatefulWidget {
  SearchSection({Key? key}) : super(key: key);

  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 65,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
              color: const Color(0xffedeeef),
              borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: SvgPicture.asset("assets/search.svg"),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .07,
                  width: MediaQuery.of(context).size.width * .65,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Search for Honda Pilot 7-Passenger"),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, FiltersScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SvgPicture.asset("assets/filter.svg"),
          ),
        )
      ],
    );
  }
}