import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/models/vehicle_photo.dart';

class VehicleImage extends StatelessWidget {
  const VehicleImage({
    Key? key,
    required this.base64Image,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String? base64Image;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;
    final image = base64Image;

    if (image != null && image.isNotEmpty) {
      try {
        bytes = base64Decode(image);
      } catch (_) {
        bytes = null;
      }
    }

    if (bytes == null || bytes.isEmpty) {
      return VehicleImagePlaceholder(
        height: height,
        width: width,
        borderRadius: borderRadius,
        message: context.l10n.t('imageLoadError'),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        cacheWidth: _cacheWidthFor(context, width),
        errorBuilder: (context, error, stackTrace) {
          return VehicleImagePlaceholder(
            height: height,
            width: width,
            borderRadius: borderRadius,
            message: context.l10n.t('imageLoadError'),
          );
        },
      ),
    );
  }

  int? _cacheWidthFor(BuildContext context, double targetWidth) {
    if (targetWidth == double.infinity) {
      return (MediaQuery.of(context).size.width *
              MediaQuery.of(context).devicePixelRatio)
          .round();
    }

    return (targetWidth * MediaQuery.of(context).devicePixelRatio).round();
  }
}

class VehiclePhotoFutureImage extends StatelessWidget {
  const VehiclePhotoFutureImage({
    Key? key,
    required this.future,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 16,
  }) : super(key: key);

  final Future<VehiclePhoto> future;
  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VehiclePhoto>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return VehicleImagePlaceholder(
            height: height,
            width: width,
            borderRadius: borderRadius,
            loading: true,
          );
        }

        if (snapshot.hasError || snapshot.data?.image == null) {
          return VehicleImagePlaceholder(
            height: height,
            width: width,
            borderRadius: borderRadius,
            message: context.l10n.t('imageLoadError'),
          );
        }

        return VehicleImage(
          base64Image: snapshot.data!.image,
          height: height,
          width: width,
          borderRadius: borderRadius,
        );
      },
    );
  }
}

class VehicleImagePlaceholder extends StatelessWidget {
  const VehicleImagePlaceholder({
    Key? key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.loading = false,
    this.message,
  }) : super(key: key);

  final double height;
  final double width;
  final double borderRadius;
  final bool loading;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1d1d24) : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.primary,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(.45),
                    size: 34,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message ?? context.l10n.t('imageLoadError'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(.55),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
