import 'package:flutter/material.dart';

import '../../../utilities/common/scaffold_builder.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  static String route = 'favorites';
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      route: FavoritesScreen.route,
      body: ListView(),
    );
  }
}
