import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocabnotes/bloc/theme_switch_cubit/theme_switch_cubit.dart';
import 'package:vocabnotes/data/authentication_service.dart';
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
                    child: StreamBuilder(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                FilledButton(
                                    onPressed: () async {
                                      await AuthenticationService().signOut();
                                    },
                                    child: const Text('Log out')),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              FilledButton(
                                  onPressed: () async {
                                    try {
                                      UserCredential? userCredential =
                                          await AuthenticationService()
                                              .signInWithGoogle();
                                      if (userCredential!.user != null) {
                                        // Đăng nhập thành công, chuyển hướng người dùng đến màn hình chính
                                        print(
                                            'Đăng nhập thành công: ${userCredential.user!.displayName}');
                                      }
                                    } catch (e) {
                                      // Xử lý lỗi đăng nhập
                                      print('Lỗi đăng nhập: $e');
                                    }
                                  },
                                  child: const Text('Login with Google')),
                            ],
                          );
                        }),
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
