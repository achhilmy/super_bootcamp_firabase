import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'image_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  ImagesCubit() : super(ImagesState());

  Future<void> uploadImage({required String path}) async {
    ///Image ref pada storage
    final imageRef = FirebaseStorage.instance.ref().child('images');

    try {
      ///state dalam keadaan loading
      emit(const ImagesState(isLoading: true));

      final randomID = "${Random().nextInt(99) * 256}";

      final uploadTask = imageRef.child(randomID).putFile(File(path));

      uploadTask.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            final progrees = 100 * (event.bytesTransferred / event.totalBytes);
            emit(ImagesState(isLoading: true, uploadProgress: progrees / 100));

            break;
          case TaskState.success:
            event.ref.getDownloadURL().then((value) =>
                emit(ImagesState(isLoading: false, linkGambar: value)));
            break;
          case TaskState.error:
            emit(ImagesState(errorMessage: e.toString()));
            break;
          case TaskState.canceled || TaskState.paused:
            break;
        }
      });
    } catch (e) {
      emit(ImagesState(errorMessage: e.toString()));
    }
  }
}
