import 'package:flutter/material.dart';

/// A widget that displays an image from a local asset or a network image.
class AppImage extends StatelessWidget {
  const AppImage(
    this.path,{
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.errorBuilder,
    this.frameBuilder = _defaultFrameBuilder,
    this.fit = BoxFit.cover,
    super.key,
  });

  /// The path of the image to display.
  final String path;

  /// The fit of the image.
  final BoxFit fit;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The width of the image to cache.
  final int? cacheWidth;

  /// The height of the image to cache.
  final int? cacheHeight;

  /// The builder to display when the image fails to load.
  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace)? errorBuilder;

  /// The builder to display when the image is loading.
  final Widget Function(BuildContext context, Widget child, int? frameInformation, bool wasSynchronouslyLoaded)? frameBuilder;

  @override
  Widget build(BuildContext context) => path.toLowerCase().startsWith('http') 
    ? Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: errorBuilder,
        frameBuilder: frameBuilder,
      )
    : Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
      frameBuilder: frameBuilder,
    );

  /// The default frame builder to display when the image is loading.
  static Widget _defaultFrameBuilder(BuildContext context, Widget child, int? frameInformation, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child; // If loaded instantly, show directly
    }
    return AnimatedOpacity(
      opacity: frameInformation == null ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: child,
    );
  }

  /// Builds a DecorationImage from a path (local or network)
  static DecorationImage buildDecorationImage(String path, {
    Map<String, String>? headers,
    BoxFit? fit,
    ColorFilter? colorFilter,
    void Function(Object, StackTrace?)? onError,
    double opacity = 1.0,
    double scale = 1.0,
    FilterQuality filterQuality = FilterQuality.medium,
    AlignmentGeometry alignment = Alignment.center,
    bool matchTextDirection = false,
  }) => DecorationImage(
        image: path.toLowerCase().startsWith('http') 
          ? NetworkImage(path, headers:headers) 
          : AssetImage(path) as ImageProvider,
        fit: fit,
        opacity: opacity,
        scale: scale,
        filterQuality: filterQuality,
        colorFilter: colorFilter,
        alignment: alignment,
        onError: onError,
        matchTextDirection: matchTextDirection,
      );

}