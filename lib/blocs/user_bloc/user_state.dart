part of 'user_bloc.dart';

class UserState extends Equatable {
  final List<Map<String, dynamic>> users;

  const UserState({this.users = const []});

  @override
  List<Object> get props => [users];
}
