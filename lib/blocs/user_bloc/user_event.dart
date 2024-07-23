part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserFetch extends UserEvent {}

class UserAdded extends UserEvent {
  final String nama;
  final int umur;

  const UserAdded({required this.nama, required this.umur});

  @override
  List<Object> get props => [nama, umur];
}

class UserUpdated extends UserEvent {
  final List<Map<String, dynamic>> users;
  const UserUpdated({required this.users});
  @override
  List<Object> get props => [users];
}
