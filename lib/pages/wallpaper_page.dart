import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/pages/full_screen.dart';

class WallerPaper extends StatefulWidget {
  const WallerPaper({super.key});

  @override
  State<WallerPaper> createState() => _WallerPaperState();
}

class _WallerPaperState extends State<WallerPaper> {
  List images = [];

  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    setState(() {
      page++;
    });
    String api = "https://api.pexels.com/v1/curated?per_page=80";
    var url = Uri.parse(api);
    final res = await http.get(url, headers: {
      "Authorization":
          "YJ71A6RdQgM8EfnrhWn55ZvTDvT2N9BeZycWo4bWWF7UoJ3dT4htFTVM"
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result["photos"];
        log(images[0].toString());
      });
    });
  }

  loadmore() async {
    String api = "https://api.pexels.com/v1/curated/?page=$page&per_page=80";
    var url = Uri.parse(api);
    final res = await http.get(url, headers: {
      "Authorization":
          "YJ71A6RdQgM8EfnrhWn55ZvTDvT2N9BeZycWo4bWWF7UoJ3dT4htFTVM"
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result["photos"]);
        log(images[0].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                var image = images[index]["src"]["tiny"];
                return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FullScreen(
                          imageUrl: images[index]["src"]["large2x"],
                          name: images[index]["photographer"],
                        );
                      }));
                    },
                    child: Image.network(image, fit: BoxFit.cover));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              loadmore();
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              fixedSize: Size(MediaQuery.of(context).size.width, 60),
            ),
            child: const Text(
              "Load More",
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
