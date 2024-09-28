import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/bloc/cubit/theme_switch_cubit.dart';
import 'package:vocabnotes/view/widgets/search_field.dart';
import 'package:vocabnotes/app/routes.dart';
import 'package:vocabnotes/bloc/save_to_library/save_to_library_bloc.dart';
import 'package:vocabnotes/bloc/word_information/word_information_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabnotes/view/widgets/word_information.dart';

class LookupScreen extends StatefulWidget {
  const LookupScreen({super.key});

  @override
  State<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends State<LookupScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordInformationBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context),
            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                        FilledButton(
                            onPressed: () async {
                              await _signinWithGoogle();
                            },
                            child: const Text('Login with Google')),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<ThemeSwitchCubit, ThemeMode>(
                    builder: (context, state) {
                      return ListTile(
                        leading: const Icon(HugeIcons.strokeRoundedMoon02),
                        title: const Text('Dark mode'),
                        trailing: Switch(
                          value: state == ThemeMode.dark,
                          onChanged: (value) {
                            context.read<ThemeSwitchCubit>().themeSwitching();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _signinWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Look up'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SearchField(
          textEditingController: _textEditingController,
          hintText: 'Look up a word or phrase online',
          onSubmit: (value) {
            navigateTo(
              appRoute: AppRoute.lookupWordInformation,
              context: context,
              replacement: false,
              data: value,
            );
          },
        ),
      ),
    );
  }
}
