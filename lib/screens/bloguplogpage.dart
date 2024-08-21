import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../reporsitory/reporsitory.dart';

class BlogUploadPage extends StatefulWidget {
  const BlogUploadPage({super.key});

  @override
  State<BlogUploadPage> createState() => _BlogUploadPageState();
}

class _BlogUploadPageState extends State<BlogUploadPage> {
  Apiservice apiservice = Apiservice();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  XFile? image;
  XFile? video;
  ImagePicker picker = ImagePicker();
  VideoPlayerController? _videoPlayerController;

  bool _isUploading = false; // State variable to manage the loading indicator

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

  Future<void> _uploadBlog() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      // Display a message if title or description is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Description are required")),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Set the loading state to true
    });

    // Create blog post with or without an image or video
    var data = await apiservice.createBlogPost(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      image: image != null
          ? image!.path
          : '', // Pass image path if image is selected
      video: video != null
          ? video!.path
          : '', // Pass video path if video is selected
    );

    setState(() {
      _isUploading = false; // Set the loading state to false
      _titleController.clear();
      _descriptionController.clear();
      image = null;
      video = null;
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
    });
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
        title: Text("Upload Blog"),
      ),
      body: Container(
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
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Select Image"),
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
                    child: Text("Select Video"),
                  ),
                  SizedBox(height: 16.0),

                  // Display the selected video preview
                  if (video != null &&
                      _videoPlayerController != null &&
                      _videoPlayerController!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  SizedBox(height: 16.0),

                  // Show CircularProgressIndicator if uploading
                  if (_isUploading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  SizedBox(height: 16.0),

                  // Upload Button
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : _uploadBlog, // Disable button if uploading
                    child: Text("Upload"),
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
