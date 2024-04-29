import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class FullScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  const FullScreen({super.key, required this.imageUrl, required this.name});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    int location = WallpaperManagerFlutter.HOME_SCREEN;
    await WallpaperManagerFlutter()
        .setwallpaperfromFile(File(widget.imageUrl), location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await setWallpaper();
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              fixedSize: Size(MediaQuery.of(context).size.width, 60),
            ),
            child: const Text(
              "Set as wallpaper",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
