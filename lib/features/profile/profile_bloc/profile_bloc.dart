import 'package:bloc/bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<FetchProfileData>(_fetchProfileData);
  }

  void _fetchProfileData(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('profile')
              .doc('vFjRn9ASN5nOBDTjq90j')
              .get();

      // Extracting fields from the snapshot
      final name = snapshot['name'];
      final imageUrl = snapshot['profile_url'];
      final currentwork = snapshot['current_work'];
      final job = snapshot['job'];

      // Emitting ProfileLoadedState with extracted data
      emit(ProfileLoadedState(
        name: name,
        imageUrl: imageUrl,
        currentwork: currentwork,
        job: job,
      ));
    } catch (error) {
      emit(ProfileErrorState('Failed to fetch profile data'));
    }
  }
}


