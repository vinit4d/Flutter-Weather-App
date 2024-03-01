
import 'package:flutter/material.dart';

import '../theme/theme_config.dart';

class CButton extends StatelessWidget {

  Widget title;
  Function? onTap;
  Color? color;

  TextStyle? titleStyle;
  CButton({super.key, required this.title,required this.onTap,this.color, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      style:
      ElevatedButton.styleFrom(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),

        ),
        primary:color??ThemeConfig.colors.appColor, // Background color
      ),
      child:
      title
      ,
      onPressed: () {onTap!();},
    );
  }
}
