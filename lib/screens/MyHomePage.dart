import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:video_player/video_player.dart';
import '../modelclass/fatchblog.dart';
import '../reporsitory/reporsitory.dart';
import 'editpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Apiservice apiservice = Apiservice();
  late Future<fatchblog?> _futureBlogData;

  @override
  void initState() {
    super.initState();
    _futureBlogData = apiservice.fetchBlogData(); // Fetch data when the widget is initialized
  }

  Future<void> _deleteBlogPost(String id, int index) async {
    try {
      await apiservice.deleteBlogPost(id);
      setState(() {
        _futureBlogData = apiservice.fetchBlogData();
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete blog post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('blog data'),
      ),
      backgroundColor: Colors.grey,
      body: FutureBuilder<fatchblog?>(
        future: _futureBlogData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final blogData = snapshot.data!;
            return ListView.builder(
              itemCount: blogData.studentData?.length ?? 0,
              itemBuilder: (context, index) {
                final student = blogData.studentData![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Buttons
                        if (student.imagepath != null)
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: Image.network(
                              student.imagepath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(height: 10),
                        if (student.videopath != null)
                          AspectRatio(
                            aspectRatio: 16 / 9, // Adjust as needed
                            child: VideoPlayerWidget(
                              videoPath: student.videopath!,
                            ),
                          ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Text(
                            student.title ?? 'No title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            student.description ?? 'No description',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _deleteBlogPost(student.sId ?? '', index);
                              },
                              child:Icon(Icons.delete),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(id: student.sId!),
                                  ),
                                );
                              },
                              child: Icon(Icons.edit),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}



class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false; // Track whether video is playing

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = _controller.value.isPlaying; // Start with paused state
          _controller.setLooping(true); // Set looping after initialization
        });
      }).catchError((error) {
        print('Error initializing video player: $error');
      });

    _controller.addListener(() {
      if (_controller.value.hasError) {
        print('VideoPlayer error: ${_controller.value.errorDescription}');
      }
      setState(() {
        _isPlaying = _controller.value.isPlaying; // Update the play/pause state based on video playback
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Get screen size
    final buttonSize = screenSize.width * 0.15; // Set button size as 15% of screen width

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: _togglePlayPause, // Toggle play/pause on video tap
            child: VideoPlayer(_controller),
          ),
          if (!_isPlaying)
            Center(
              child: GestureDetector(
                onTap: _togglePlayPause, // Toggle play/pause on icon tap
                child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // Background color with opacity
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: buttonSize * 0.5, // Icon size is half the button size
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 8, // Ensure the progress indicator is at the bottom
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5), // Background color with opacity
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}