import 'package:equatable/equatable.dart';


abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final String name;
  final String imageUrl;
  final String currentwork;
  final String job;

  ProfileLoadedState({
    required this.name,
    required this.imageUrl,
    required this.currentwork,
    required this.job,
  });

  @override
  List<Object?> get props => [name, imageUrl, currentwork, job];
}


class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState(this.error);

  @override
  List<Object?> get props => [error];
}