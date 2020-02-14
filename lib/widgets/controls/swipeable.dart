import 'package:flutter/material.dart';

typedef void SwipeResult();

class Swipeable extends StatelessWidget {
  final SwipeResult onRightSwipe;
  final SwipeResult onLeftSwipe;
  final Widget child;
  final int threshold;

  const Swipeable({Key key, this.onRightSwipe, this.onLeftSwipe, this.child, this.threshold = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String swipeDirection = "";
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > threshold) {
          swipeDirection = "right";
        } else if (details.delta.dx < -threshold) {
          swipeDirection = "left";
        }
      },
      onHorizontalDragEnd: (details) {
        if (swipeDirection == "right") {
          swipeDirection = "";
          onRightSwipe();
        } else if (swipeDirection == "left") {
          swipeDirection = "";
          onLeftSwipe();
        }
      },
      child: child,
    );
  }
}
