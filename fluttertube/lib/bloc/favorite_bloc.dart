import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/models/video.dart';

class FavoriteBloc implements BlocBase {

  Map<String, Video> _favorites = {};

  @override
  void dispose() {
  }



}