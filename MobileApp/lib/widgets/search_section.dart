import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';

import '../screens/filters_screen.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({Key? key}) : super(key: key);

  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 65,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
              color: isDark ? const Color(0xff1d1d24) : AppColors.lightSurface,
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
                        hintText: context.l10n.t('searchHint')),
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
