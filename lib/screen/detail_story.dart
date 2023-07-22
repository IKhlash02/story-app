import 'package:flutter/material.dart';

import 'package:story_app_1/data/model/story_element.dart';

class DetailStory extends StatelessWidget {
  final StoryElement storyElement;
  final Function() isMap;
  const DetailStory({
    Key? key,
    required this.storyElement,
    required this.isMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 27,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  storyElement.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Image.network(storyElement.photoUrl),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storyElement.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    storyElement.description,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          if (storyElement.lat != null)
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    isMap();
                  },
                  child: const Text("Lokasi")),
            )
        ],
      )),
    );
  }
}
