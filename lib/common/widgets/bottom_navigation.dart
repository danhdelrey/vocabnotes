import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:vocabnotes/common/screens/learning_screen.dart';
import 'package:vocabnotes/features/library/presentation/screens/library_screen.dart';
import 'package:vocabnotes/features/lookup/presentation/screens/lookup_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      onTap: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedSearch02),
          label: 'Look up',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedNote),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedStudyLamp),
          label: 'Learning',
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const LookupScreen();
      case 1:
        return const LibraryScreen();
      default:
        return const LearningScreen();
    }
  }
}
