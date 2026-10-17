import "package:flutter/widgets.dart";

/// The statistics either side of the scramble's picture.
///
/// The picture gets at most two eighths of the row, as the Clock's is the widest and, left to its
/// own width, squeezes the statistics into each other on a phone.
class TimerFooter extends StatelessWidget {
  const TimerFooter({super.key, required this.left, required this.picture, required this.right});

  final Widget left;
  final Widget picture;
  final Widget right;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .stretch,
      children: [
        Expanded(flex: 3, child: left),
        Flexible(flex: 2, child: picture),
        Expanded(flex: 3, child: right),
      ],
    ),
  );
}
