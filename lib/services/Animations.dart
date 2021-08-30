import 'package:flutter/material.dart';

class Animations {
  static fromLeft(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return SlideTransition(
      child: _child,
      position: Tween<Offset>(end: Offset.zero, begin: Offset(1.0, 0.0))
          .animate(_animation),
    );
  }



  static fromRight(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return SlideTransition(
      child: _child,
      position: Tween<Offset>(end: Offset.zero, begin: Offset(-1.0, 0.0))
          .animate(_animation),
    );
  }

  static fromTop(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return SlideTransition(
      child: _child,
      position: Tween<Offset>(end: Offset.zero, begin: Offset(0.0, -1.0))
          .animate(_animation),
    );
  }

  static fromBottom(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return SlideTransition(
      child: _child,
      position: Tween<Offset>(end: Offset.zero, begin: Offset(0.0, 1.0))
          .animate(_animation),
    );
  }

  static grow(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return ScaleTransition(
      child: _child,
      scale: Tween<double>(end: 1.0, begin: 0.0).animate(CurvedAnimation(
          parent: _animation,
          curve: Interval(0.00, 0.50, curve: Curves.linear))),
    );
  }

  static shrink(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return ScaleTransition(
      child: _child,
      scale: Tween<double>(end: 1.0, begin: 1.2).animate(CurvedAnimation(
          parent: _animation,
          curve: Interval(0.50, 1.00, curve: Curves.linear))),
    );
  }
}
