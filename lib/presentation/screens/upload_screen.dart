import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'workspace_screen/work_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Upload directory'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                  ),
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(allowMultiple: true);
                    if (result != null) {
                      List<File> files = result.paths.map((path) => File(path!)).toList();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const WorkScreen()));
                    } else {
                      // User canceled the picker
                    }
                  },
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                  ),
                  child: const Text('Upload image'),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const WorkScreen()));
                    } else {}
                  },
                )),
          ],
        ),
      ),
    );
  }
}
