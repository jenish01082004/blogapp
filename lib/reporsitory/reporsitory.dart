import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelclass/fatchblog.dart';
import '../modelclass/fatchblog1.dart';

class Apiservice {
  Future<fatchblog?> fetchBlogData() async {
    final url = "http://192.168.1.63:3000/blog/fatch"; // Your API endpoint
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body);
        return fatchblog.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }


  Future<void> deleteBlogPost(String id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.63:3000/blog/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete blog post');
    }
  }



  Future<void> createBlogPost({
    required String title,
    required String description,
    String? image,
    String? video,
  }) async {
    try {
      final url = Uri.parse("http://192.168.1.63:3000/blog/insert");
      print("Call>>>>>>>uploading");

      var request = http.MultipartRequest("POST", url);
      request.fields.addAll({
        'title': title,
        'description': description,
      });

      if (image != null) {
        var imageFile = await http.MultipartFile.fromPath('photo', image);
        request.files.add(imageFile);
      }

      if (video != null) {
        var videoFile = await http.MultipartFile.fromPath('video', video);
        request.files.add(videoFile);
      }

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 201) { // Assuming 201 Created for successful post
        print('Blog post created successfully');
      } else {
        print('Error: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }



  Future<void> updateBlogPost({
    required String id,
    required String title,
    required String description,
    String? image,
    String? video,
  }) async {
    try {
      final url = Uri.parse("http://192.168.1.63:3000/blog/$id");
      print("Call>>>>>>>uploading");

      var request = http.MultipartRequest("PUT", url);
      request.fields.addAll({
        'title': title,
        'description': description,
      });

      if (image != null) {
        var imageFile = await http.MultipartFile.fromPath('photo', image);
        request.files.add(imageFile);
      }

      if (video != null) {
        var videoFile = await http.MultipartFile.fromPath('video', video);
        request.files.add(videoFile);
      }

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) { // Assuming 200 OK for successful update
        print('Blog post updated successfully');
      } else {
        print('Error: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }


  // Example fetchBlogDataById method in apiservice
  Future<fatchone?> fetchBlogDataById({required String id}) async {
    final url = "http://192.168.1.63:3000/blog/fatch/$id"; // Update URL if needed
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return fatchone.fromJson(jsonData);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }



}
