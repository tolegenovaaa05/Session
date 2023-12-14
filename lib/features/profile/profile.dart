
import 'package:cyber_news/features/login_page/login_page.dart';
import 'package:cyber_news/features/profile/profile_bloc/profile_bloc.dart';
import 'package:cyber_news/features/profile/profile_bloc/profile_event.dart';
import 'package:cyber_news/features/profile/profile_bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Center(
            child: Text(
              'My Profile',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: ProfileBuild(),
      ),
    );
  }
}

class ProfileBuild extends StatelessWidget {
  const ProfileBuild({Key? key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(FetchProfileData());
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(state.imageUrl),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Current Work:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.currentwork,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Job Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.job,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 50),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      icon: Icon(Icons.exit_to_app),
                      label: Text('Sign Out'),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileErrorState) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
