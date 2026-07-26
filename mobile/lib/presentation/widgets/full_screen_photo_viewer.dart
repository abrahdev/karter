import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FullScreenPhotoViewer extends StatefulWidget {
  final List<String> paths;
  final int initialIndex;
  final String heroTag;

  const FullScreenPhotoViewer({
    super.key,
    required this.paths,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  State<FullScreenPhotoViewer> createState() => _FullScreenPhotoViewerState();
}

class _FullScreenPhotoViewerState extends State<FullScreenPhotoViewer> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context);
              }
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.paths.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) => Center(
                child: Hero(
                  tag: i == widget.initialIndex ? widget.heroTag : 'photo_${widget.paths[i]}',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(
                      File(widget.paths[i]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    SharePlus.instance.share(ShareParams(files: [XFile(widget.paths[_currentIndex])]));
                  },
                ),
                if (widget.paths.length > 1)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.paths.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
