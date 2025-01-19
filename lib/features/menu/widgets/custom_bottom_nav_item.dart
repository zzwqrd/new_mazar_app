import 'package:flutter/material.dart';

BottomNavigationBarItem buildBottomNavigationBarItem(
    {String? label, required String icon, required bool isActive}) {
  return BottomNavigationBarItem(
    label: label ?? "",
    icon: Container(
      decoration: BoxDecoration(
        // color: isActive ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 9.8),
      child: Image(
        image: AssetImage(icon),
        width: 25,
      ),
    ),
    activeIcon: Container(
      decoration: BoxDecoration(
        // color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 9.8),
      child: Image(
        image: AssetImage(icon),
        width: 25,
      ),
    ),
  );
}
