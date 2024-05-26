import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({
    super.key,
    required this.hasFile,
    this.photoFile,
    this.photoUrl,
  });

  final bool hasFile;
  final dynamic photoFile, photoUrl;

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    bool isWeb = kIsWeb;
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: 30,
        left: 50,
        right: 50,
        bottom: 10,
      ),
      height: width * 0.4,
      decoration: widget.hasFile
          ? BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: isWeb
                    ? NetworkImage(widget.photoUrl)
                    : FileImage(widget.photoFile),
                fit: BoxFit.fitHeight,
              ),
            )
          : BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
      child: widget.hasFile
          ? Container()
          : const Icon(Icons.add_a_photo_rounded, size: 35),
    );
  }
}
