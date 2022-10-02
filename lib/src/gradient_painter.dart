import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:powers/powers.dart';

/// The base class for [LinearGradientPainter], [RadialGradientPainter],
/// and [SweepGradientPainter].
///
/// {@template gradients.GradientPainter}
///
/// [LinearGradientPainter], [RadialGradientPainter], and [SweepGradientPainter]
/// can be used interchangeably in [BoxDecoration]s, or can be used to build
/// a [Shader] to paint directly onto a [Canvas]. __See:__ [createShader].
///
/// {@endtemplate}
abstract class GradientPainter implements Gradient {
  const GradientPainter._();

  /// The color space the colors of the gradient will be interpolated in.
  ColorSpace? get colorSpace;

  /// If `false`, the colors will be interpolated in the color space defined
  /// by the starting color within any pairing, however if `true`, the colors
  /// will be interpolated in the space defined by the ending color.
  ///
  /// __Note:__ [invert] will have no effect on the resulting gradient
  /// if [colorSpace] is defined.
  bool get invert;

  /// Defines the number of steps to generate in relation to
  /// the number of device pixels the gradient spans.
  double get density;
}

/// A 2D linear gradient.
///
/// {@macro gradients.GradientPainter}
class LinearGradientPainter extends LinearGradient implements GradientPainter {
  /// A 2D linear gradient.
  ///
  /// __See:__ [LinearGradient]
  const LinearGradientPainter({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
    this.colorSpace,
    this.invert = false,
    this.density = 0.075,
  })  : assert(density > 0.0 && density <= 1.0),
        assert(stops == null || stops.length == colors.length),
        super(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          transform: transform,
        );

  @override
  final ColorSpace? colorSpace;

  @override
  final bool invert;

  @override
  final double density;

  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) {
    final startPoint = begin.resolve(textDirection).withinRect(rect);
    final endPoint = end.resolve(textDirection).withinRect(rect);
    final span = ((startPoint.dx - endPoint.dx).squared() +
            (startPoint.dy - endPoint.dy).squared())
        .sqrt();
    final size = (span * devicePixelRatio * density).ceil();

    if (size < colors.length) {
      return super.createShader(rect, textDirection: textDirection);
    }

    return ui.Gradient.linear(
      startPoint,
      endPoint,
      colors.augment(size,
          colorSpace: colorSpace, stops: stops, invert: invert),
      buildStops(size),
      tileMode,
      resolveTransform(rect, textDirection),
    );
  }

  @override
  LinearGradientPainter scale(double factor) {
    return LinearGradientPainter(
      begin: begin,
      end: end,
      colors: colors
          .map<Color>((Color color) => Color.lerp(null, color, factor)!)
          .toList(),
      stops: stops,
      tileMode: tileMode,
      transform: transform,
      colorSpace: colorSpace,
      density: density,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LinearGradientPainter &&
        begin == other.begin &&
        end == other.end &&
        listEquals<Color>(colors, other.colors) &&
        listEquals<double>(stops, other.stops) &&
        tileMode == other.tileMode &&
        transform == other.transform &&
        colorSpace == other.colorSpace &&
        invert == other.invert &&
        density == other.density;
  }

  @override
  int get hashCode => hashValues(begin, end, hashList(colors), hashList(stops),
      tileMode, transform, colorSpace, invert, density);
}

/// A 2D radial gradient.
///
/// {@macro gradients.GradientPainter}
class RadialGradientPainter extends RadialGradient implements GradientPainter {
  /// A 2D radial gradient.
  ///
  /// __See:__ [RadialGradient]
  const RadialGradientPainter({
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    AlignmentGeometry? focal,
    double focalRadius = 0.0,
    GradientTransform? transform,
    this.colorSpace,
    this.invert = false,
    this.density = 0.125,
  }) : super(
          center: center,
          radius: radius,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          focal: focal,
          focalRadius: focalRadius,
          transform: transform,
        );

  @override
  final ColorSpace? colorSpace;

  @override
  final bool invert;

  @override
  final double density;

  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) {
    final radius = this.radius * rect.shortestSide;
    final size = (radius * devicePixelRatio * density).ceil();

    if (size < colors.length) {
      return super.createShader(rect, textDirection: textDirection);
    }

    return ui.Gradient.radial(
      center.resolve(textDirection).withinRect(rect),
      radius,
      colors.augment(size,
          colorSpace: colorSpace, stops: stops, invert: invert),
      buildStops(size),
      tileMode,
      resolveTransform(rect, textDirection),
      focal?.resolve(textDirection).withinRect(rect),
      focalRadius * rect.shortestSide,
    );
  }

  @override
  RadialGradient scale(double factor) {
    return RadialGradientPainter(
      center: center,
      radius: radius,
      colors: colors
          .map<Color>((Color color) => Color.lerp(null, color, factor)!)
          .toList(),
      stops: stops,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colorSpace: colorSpace,
      density: density,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is RadialGradientPainter &&
        center == other.center &&
        radius == other.radius &&
        listEquals<Color>(colors, other.colors) &&
        listEquals<double>(stops, other.stops) &&
        tileMode == other.tileMode &&
        focal == other.focal &&
        focalRadius == other.focalRadius &&
        transform == other.transform &&
        colorSpace == other.colorSpace &&
        invert == other.invert &&
        density == other.density;
  }

  @override
  int get hashCode => hashValues(
      center,
      radius,
      hashList(colors),
      hashList(stops),
      tileMode,
      focal,
      focalRadius,
      transform,
      colorSpace,
      invert,
      density);
}

/// A 2D sweep gradient.
///
/// {@macro gradients.GradientPainter}
class SweepGradientPainter extends SweepGradient implements GradientPainter {
  /// A 2D sweep gradient.
  ///
  /// __See:__ [SweepGradient]
  const SweepGradientPainter({
    AlignmentGeometry center = Alignment.center,
    double startAngle = 0.0,
    double endAngle = math.pi * 2,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
    this.colorSpace,
    this.invert = false,
    this.density = 0.075,
  }) : super(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          transform: transform,
        );

  @override
  final ColorSpace? colorSpace;

  @override
  final bool invert;

  @override
  final double density;

  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) {
    final fullPi = math.pi * 2;
    final slice =
        (endAngle.clamp(0, fullPi) - startAngle.clamp(0, fullPi)) / fullPi;
    final span =
        (rect.longestSide.squared() + rect.shortestSide.squared()).sqrt();
    final size = (span * slice * devicePixelRatio * density).ceil();

    if (size < colors.length) {
      return super.createShader(rect, textDirection: textDirection);
    }

    return ui.Gradient.sweep(
      center.resolve(textDirection).withinRect(rect),
      colors.augment(size,
          colorSpace: colorSpace, stops: stops, invert: invert),
      buildStops(size),
      tileMode,
      startAngle,
      endAngle,
      resolveTransform(rect, textDirection),
    );
  }

  @override
  SweepGradientPainter scale(double factor) {
    return SweepGradientPainter(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      colors: colors
          .map<Color>((Color color) => Color.lerp(null, color, factor)!)
          .toList(),
      stops: stops,
      tileMode: tileMode,
      transform: transform,
      colorSpace: colorSpace,
      density: density,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SweepGradientPainter &&
        center == other.center &&
        startAngle == other.startAngle &&
        endAngle == other.endAngle &&
        listEquals<Color>(colors, other.colors) &&
        listEquals<double>(stops, other.stops) &&
        tileMode == other.tileMode &&
        transform == other.transform &&
        colorSpace == other.colorSpace &&
        invert == other.invert &&
        density == other.density;
  }

  @override
  int get hashCode => hashValues(center, startAngle, endAngle, hashList(colors),
      hashList(stops), tileMode, transform, colorSpace, invert, density);
}

extension _BuildStops on GradientPainter {
  /// Evenly distributes the stops from `0.0` to `1.0`.
  List<double> buildStops(int size) {
    final slice = 1 / size;
    return List<double>.generate(size, (index) => index * slice);
  }

  /// Resolves the transform applied to the shader.
  Float64List? resolveTransform(Rect bounds, TextDirection? textDirection) {
    return transform?.transform(bounds, textDirection: textDirection)?.storage;
  }

  /// Returns the number of device pixels for each logical
  /// pixel for the screen this view is displayed on.
  double get devicePixelRatio =>
      WidgetsBinding.instance.window.devicePixelRatio;
}
