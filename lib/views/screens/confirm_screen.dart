import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/upload_video_controller.dart';
import '../widgets/text_input_field.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  bool _isUploading = false;

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setVolume(0.5);
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    _songController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    setState(() {
      _isUploading = true;
    });
    try {
      var uploadResult = await uploadVideoController.uploadVideo(
          _songController.text, _captionController.text, widget.videoPath);
      print("Video uploaded: $uploadResult");
      _showUploadCompleteDialog();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
      print("Error uploading video: ${e.toString()}");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showUploadCompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Complete"),
          content: const Text("Your video has been successfully uploaded."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: VideoPlayer(controller),
                ),
                const SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          lableText: 'Song name',
                          controller: _songController,
                          icon: Icons.music_note,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          lableText: 'Caption',
                          controller: _captionController,
                          icon: Icons.closed_caption,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _handleUpload,
                        child: const Text(
                          'Share!',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isUploading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
