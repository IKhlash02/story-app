import 'package:flutter/material.dart';

import 'package:story_app_1/data/model/story_element.dart';

class CardListStory extends StatelessWidget {
  final StoryElement storyElement;

  const CardListStory({
    Key? key,
    required this.storyElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(storyElement.photoUrl), fit: BoxFit.cover),
          ),
        ),
      ]),
    );
  }
}
