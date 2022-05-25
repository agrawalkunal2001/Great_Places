import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    setState(() {
      _storedImage = File(imageFile!.path);
    });
    final appDirectory = await syspaths
        .getApplicationDocumentsDirectory(); // It is a directory on the device which is reserved for app data.
    final fileName = path.basename(imageFile!.path);
    final savedImage =
        await File(imageFile.path).copy('${appDirectory.path}/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(_storedImage as File,
                  fit: BoxFit.cover, width: double.infinity)
              : Text(
                  "No Image!",
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Take Picture"),
              textColor: Theme.of(context).primaryColor,
              onPressed: _takePicture),
        ),
      ],
    );
  }
}
