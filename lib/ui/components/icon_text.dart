import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText(this.text,
      {Key key,
      this.icon,
      this.iconSize,
      this.direction = Axis.horizontal,
      this.style,
      this.maxLines,
      this.softWrap,
      this.iconPadding = EdgeInsets.zero,
      this.textAlign,
      this.overflow = TextOverflow.ellipsis,
      this.offstage})
      : assert(direction != null),
        assert(overflow != null),
        super(key: key);

  final String text;
  final Icon icon;
  final double iconSize;
  final Axis direction;
  final bool offstage;

  final EdgeInsetsGeometry iconPadding;
  final TextStyle style;
  final int maxLines;
  final bool softWrap;
  final TextOverflow overflow;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      // 只有文字
      return Text(text ?? '', style: style);
    } else if (text == null || text.isEmpty) {
      // 只有图标
      return Padding(
        padding: iconPadding,
        child: icon,
      );
    } else {
      // 都有
      return RichText(
        text: TextSpan(
          style: style,
          children: [
            WidgetSpan(
              child: IconTheme(
                data: IconThemeData(
                  size: iconSize ?? style?.fontSize ?? 16,
                  color: style?.color,
                ),
                child: Padding(
                  padding: iconPadding,
                  child: icon,
                ),
              ),
            ),
            TextSpan(
              text: text,
            ),
          ],
        ),
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.clip,
        textAlign: textAlign ??
            (direction == Axis.horizontal ? TextAlign.start : TextAlign.center),
      );
    }
  }
}
