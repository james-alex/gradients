# gradients

Implementations of Flutter's [LinearGradient], [RadialGradient], and
[SweepGradient] with support for the CMYK, HSI, HSL, HSP, HSB, LAB, Oklab,
RGB, and XYZ color spaces.

`gradients` depends on and exposes the [flutter_color_models](https://pub.dev/packages/flutter_color_models) package.

__See:__ [flutter_palette](https://pub.dev/packages/flutter_palette),
a package for generating color palettes.

# Usage

```dart
import 'package:gradients/gradients.dart';
```

The 3 classes in `gradients` can be used interchangeably with Flutter's
[Gradient]s: [LinearGradientPainter], [RadialGradientPainter], and
[SweepGradientPainter].

```dart
final colors = <Color>[Colors.lime, Colors.pink, Colors.purple];
final linearGradient = LinearGradientPainter(colors: colors);
final radialGradient = RadialGradientPainter(colors: colors);
final sweepGradient = SweepGradientPainter(colors: colors);
```

Like [Gradient]s, [GradientPainter]s can be provided to a [BoxDecoration],
or the [createShader] method can be used to paint directly to a [Canvas].

```dart
final widget = Container(
  decoration: BoxDecoration(
    gradient: LinearGradientPainter(
      colors: <Color>[Colors.lime, Colors.pink, Colors.purple],
    ),
  ),
);
```

## Color Spaces

By default, [Color]s are interpolated in the RGB color space; A [colorSpace]
can be provided to set the color space colors will be interpolated in.

```dart
final colors = <Color>[Colors.lime, Colors.pink, Colors.purple];
final oklabGradient = LinearGradientPainter(
  colorSpace: ColorSpace.oklab,
  colors: colors,
);
```

![Oklab Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/oklab.png "Oklab Gradient")

### Color Models

However, if [ColorModel]s are utilized and no [colorSpace] is provided,
the gradient will be interpolated in the color space defined by the starting
color within any pair of colors.

```dart
final colors = <Color>[
  RgbColor(0, 188, 212),
  HsbColor(35, 100, 100),
  OklabColor(0.9, -0.05, 0.033),
  HspColor(175, 100, 50),
];

// This gradient will be interpolated in the RGB color space,
// then the HSB color space, then the Oklab color space.
final gradient = LinearGradientPainter(colors: colors);
```

![Color Models Example Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/exampleA.png "Color Models Example Gradient")

If [invert] is set to `true`, the gradient will be interpolated
in the color space defined by the ending color within any pair
of colors.

```dart
// This gradient will be interpolated in the HSB color space,
// then the Oklab color space, then the HSP color space.
final gradient = LinearGradientPainter(colors: colors, invert: true);
```

![Color Models Inverted Example Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/exampleB.png "Color Models Inverted Example Gradient")

## Output

Below is the same set of colors interpolated in each of the supported
color spaces.

```dart
final colors = <Color>[Colors.lime, Colors.pink, Colors.purple];
```

### CMYK

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.cmyk);
```

![CMYK Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/cmyk.png "CMYK Gradient")

### HSI

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.hsi);
```

![HSI Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/hsi.png "HSI Gradient")

### HSL

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.hsl);
```

![HSL Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/hsl.png "HSL Gradient")

### HSP

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.hsp);
```

![HSP Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/hsp.png "HSP Gradient")

### HSB

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.hsb);
```

![HSB Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/hsb.png "HSB Gradient")

### LAB

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.lab);
```

![LAB Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/lab.png "LAB Gradient")

### Oklab

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.oklab);
```

![Oklab Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/color_spaces/img/oklab.png "Oklab Gradient")

### RGB

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.rgb);
```

![RGB Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/rgb.png "RGB Gradient")

### XYZ

```dart
final gradient = LinearGradientPainter(
    colors: colors, colorSpace: ColorSpace.xyz);
```

![XYZ Gradient](https://raw.githubusercontent.com/james-alex/gradients/master/img/color_spaces/xyz.png "XYZ Gradient")
