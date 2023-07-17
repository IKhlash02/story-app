// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:story_app_1/data/model/story_element.dart';
import 'package:story_app_1/provider/list_story_provider.dart';
import 'package:story_app_1/result_state.dart';
import 'package:story_app_1/widget/card_list_story.dart';

import '../provider/auth_provider.dart';
import '../widget/flag_icon_widget.dart';

class ListStory extends StatefulWidget {
  final Function() onLogout;
  final Function() isAddStory;
  final Function(StoryElement) onTapped;

  const ListStory({
    Key? key,
    required this.onLogout,
    required this.isAddStory,
    required this.onTapped,
  }) : super(key: key);

  @override
  State<ListStory> createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    print("sedang di buat baru");
    super.initState();

    final provider = context.read<ListStoryProvider>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (provider.pageItems != null) {
          provider.fechtListstory();
        }
      }
    });

    if (context.read<AuthProvider>().isLoggedIn == true) {
      Future.microtask(() {
        provider.fechtListstory();
      });
    }
  }

  @override
  void dispose() {
    print("sedang di dispose");
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          const FlagIconWidget(),
          IconButton(
              onPressed: () async {
                final authRead = context.read<AuthProvider>();
                final result = await authRead.logout();
                if (result) widget.onLogout();
              },
              icon: authWatch.isLoadingLogout
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<ListStoryProvider>(
            builder: (context, value, child) {
              if (value.state == ResultState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (value.state == ResultState.hasData) {
                final storyData = value.result;
                return ListView.builder(
                  controller: scrollController,
                  itemCount:
                      storyData.length + (value.pageItems != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == storyData.length && value.pageItems != null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () => widget.onTapped(storyData[index]),
                      child: CardListStory(
                        storyElement: storyData[index],
                      ),
                    );
                  },
                );
              } else if (value.state == ResultState.noData) {
                return Center(
                  child: Material(
                    child: Text(value.message),
                  ),
                );
              } else if (value.state == ResultState.error) {
                return Center(
                  child: Material(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      child: Text(value.message),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.isAddStory();
          },
          child: const Icon(Icons.add)),
    );
  }
}
