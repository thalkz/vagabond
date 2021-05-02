import 'package:flutter/material.dart';

class FadeInNetworkImage extends StatelessWidget {
  const FadeInNetworkImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded ?? false) {
          return child;
        } else {
          return AnimatedOpacity(
            child: child,
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }
}

class DebugNetworkImage extends StatelessWidget {
  const DebugNetworkImage({
    required this.url,
    required this.text,
  });

  final String url;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded ?? false) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: child,
              ),
              Center(child: Text(text))
            ],
          );
        } else {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                child: AnimatedOpacity(
                  child: child,
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
              ),
              Center(child: Text(text))
            ],
          );
        }
      },
    );
  }
}
