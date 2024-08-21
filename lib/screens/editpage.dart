import 'dart:io';

import 'package:blog_app/modelclass/fatchblog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../modelclass/fatchblog1.dart';
import '../reporsitory/reporsitory.dart';
class EditPage extends StatefulWidget {
  final String id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Apiservice apiservice = Apiservice();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  XFile? image;
  XFile? video;
  ImagePicker picker = ImagePicker();
  VideoPlayerController? _videoPlayerController;

  bool _isUploading = false; // Loading state variable
  List<fatchone>? userProfile;


  @override
  void initState() {
    fatchblog();
    super.initState();
  }

  Future<void> fatchblog() async {
    var iid = widget.id;
    var response = await apiservice.fetchBlogDataById(id: iid.toString());

    print('API Response: $response'); // Debug print to check the raw response

    if (response != null && response is fatchone) {
      setState(() {
        userProfile = [response]; // Wrap in a list if needed
        if (userProfile != null && userProfile!.isNotEmpty) {
          var firstBlog = userProfile![0].blog;
          _titleController.text = firstBlog?.title ?? '';
          _descriptionController.text = firstBlog?.description ?? '';
        }
      });
    } else {
      print('Unexpected response type or null data.');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        video = pickedVideo;
        _initializeVideoPlayer(pickedVideo.path);
      });
    }
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    _videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {}); // Refresh UI when the video player is initialized
        _videoPlayerController?.play();
      });
  }

  Future<void> _editBlogPost() async {
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      // Display a message if title or description is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Description are required")),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Start loading
    });

    try {
      // Create blog post with or without an image or video
      await apiservice.updateBlogPost(
        id: widget.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: image != null ? image!.path : '',
        video: video != null ? video!.path : '',
      );

      // Clear text fields and media after uploading
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        image = null;
        video = null;
        _videoPlayerController?.dispose();
        _videoPlayerController = null;
        _isUploading = false; // Stop loading
      });

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload. Please try again.")),
      );
      setState(() {
        _isUploading = false; // Stop loading
      });
    }

  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Update"),
      ),
      body: _isUploading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator when uploading
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                    color: Colors.white70,
                    child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),)),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 16.0),

                  // Image Picker Button
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("select Image"),
                  ),
                  SizedBox(height: 16.0),

                  // Display the selected image preview
                  if (image != null)
                    Image.file(
                      File(image!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 16.0),

                  // Video Picker Button
                  ElevatedButton(
                    onPressed: _pickVideo,
                    child: Text("select Video"),
                  ),
                  SizedBox(height: 16.0),

                  // Display the selected video preview
                  if (video != null && _videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  SizedBox(height: 16.0),

                  // Upload Button
                  ElevatedButton(
                    onPressed: _editBlogPost,
                    child: Text("update"),
                  ),
                ],
              ),
            ),
                    ),
                  ),
          ),
    );
  }
}