import 'package:flutter/material.dart';
import 'package:mazar/features/menu/domain/enums/drawer_state_enun.dart';

class CustomDrawerController {
  Function? open;
  Function? close;
  late Function toggle;
  late Function isOpen;
  ValueNotifier<DrawerState>? stateNotifier;
}
