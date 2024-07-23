import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? streamSubscription;

  UserBloc() : super(const UserState()) {
    on<UserFetch>((event, emit) {
      final col = db.collection('users');

      streamSubscription = col.snapshots().listen((data) {
        add(UserUpdated(
          users: data.docs.map((e) => e.data()).toList(),
        ));
      });
    });

    on<UserAdded>((event, emit) async {
      await db.collection('users').add({
        'nama': event.nama,
        'umur': event.umur,
      });
    });

    on<UserUpdated>((event, emit) {
      emit(UserState(users: event.users));
    });
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
