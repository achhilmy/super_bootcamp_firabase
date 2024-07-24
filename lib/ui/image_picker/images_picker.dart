import 'package:firebase_superbootcamp/blocs/images_cubit/image_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image?.path != null) {
      context.read<ImagesCubit>().uploadImage(path: image!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Storage"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: BlocBuilder<ImagesCubit, ImagesState>(
          builder: (context, state) {
            return ListView(
              children: [
                Visibility(
                    visible: state.linkGambar != null,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        state.linkGambar ?? '',
                        loadingBuilder: (context, child, chunk) {
                          final loaded = (chunk?.cumulativeBytesLoaded ?? 0);
                          final expected = (chunk?.expectedTotalBytes ?? 0);

                          if (loaded < expected) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                value: loaded / expected,
                              ),
                            );
                          }
                          return child;
                        },
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: AnimatedSwitcher(
                    duration: Duration(seconds: 2),
                    child: state.isLoading
                        ? CircularProgressIndicator(
                            value: state.uploadProgress,
                            backgroundColor: Colors.grey,
                          )
                        : ElevatedButton.icon(
                            onPressed: () async {
                              await pickImage();
                            },
                            label: Text("Upload Images"),
                            icon: Icon(Icons.image_rounded),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SelectableText.rich(TextSpan(children: [
                    TextSpan(text: "Link Hasil Upload"),
                    TextSpan(
                      text: state.linkGambar ?? "",
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ])),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
