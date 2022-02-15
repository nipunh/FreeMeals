import 'package:flutter/material.dart';
import 'package:freemeals/config/stories_data.dart';
import 'package:freemeals/enums/stories_mediaType.dart';
import 'package:freemeals/models/story_model.dart';
import 'package:freemeals/screen/stories_page.dart';
import 'package:freemeals/widgets/animated_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryScreen extends StatefulWidget {
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {

    PageController _pageController;
    AnimationController _animationController;
    VideoPlayerController _videoController;
    int _currIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    final Story firstStory = stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _videoController = VideoPlayerController.network(stories[2].url)
      ..initialize().then((value) => setState(() {}));
    _videoController.play();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();

        setState(() {
          if (_currIndex + 1 < stories.length) {
            _currIndex += 1;
            _loadStory(story: stories[_currIndex]);
          } else {
            _currIndex = 0;
            _loadStory(story: stories[_currIndex]);
          }
        });
      }
    });
  }

  @override
    void dispose(){
      _pageController.dispose();
      _animationController.dispose();
      _videoController?.dispose();
      super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Story story = stories[_currIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: [
            PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: stories.length,
                itemBuilder: (context, i) {
                  final Story story = stories[i];
                  switch (story.media) {
                    case MediaType.image:
                      return CachedNetworkImage(
                        imageUrl: story.url,
                      );
                      break;

                    case MediaType.video:
                      if (_videoController != null &&
                          _videoController.value.isInitialized) {
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController.value.size.width,
                            height: _videoController.value.size.height,
                          ),
                        );
                      }
                      break;
                  }
                  return const SizedBox.shrink();
                }
              ),
              Positioned(
                top: 40,
                left: 10,
                right: 10,
                child: Row(
                  children: stories
                  .asMap()
                  .map((i, e){
                    return MapEntry(i, AnimatedBar(
                      animController : _animationController,
                      position : i,
                      currentIndex : _currIndex,
                    ),
                  );
                  }).values.toList(),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(() {
        if (_currIndex - 1 >= 0) {
          _currIndex -= 1;
          _loadStory(story: stories[_currIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currIndex + 1 < stories.length) {
          _currIndex += 1;
          _loadStory(story: stories[_currIndex]);
        } else {
          _currIndex = 0;
          _loadStory(story: stories[_currIndex]);
        }
      });
    } else {
      if (story.media == MediaType.video) {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
          _animationController.stop();
        } else {
          _videoController.play();
          _animationController.forward();
        }
      }
    }
  }

  void _loadStory({Story story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();

    switch (story.media) {
      case MediaType.image:
        _animationController.duration = story.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        _videoController = null;
        _videoController?.dispose();
        _videoController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (_videoController.value.isInitialized) {
              _animationController.duration = _videoController.value.duration;
              _videoController.play();
              _animationController.forward();
            }
          });
        break;
    }

    if (animateToPage) {
      _pageController.animateToPage(
          _currIndex,
          duration: const Duration(microseconds: 1), 
          curve: Curves.easeInOut
        );
    }
  }
}
