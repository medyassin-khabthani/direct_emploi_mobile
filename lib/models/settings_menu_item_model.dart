import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
}

final List<MenuItem> menuItems = [
  MenuItem(title: 'Ma recherche', icon: Icons.manage_search_outlined),
  MenuItem(title: 'Ma situation', icon: Icons.backup_table),
  MenuItem(title: 'Mes CV', icon: Icons.feed_outlined),
  MenuItem(title: 'Mes infos personnels', icon: Icons.account_box_outlined),
];