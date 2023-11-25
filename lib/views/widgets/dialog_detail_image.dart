import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';
import 'package:flutter_web_ptb/providers/asset_state.dart';
import 'package:collection/collection.dart';

class DialogDetailImage extends StatelessWidget {
  final int id;
  const DialogDetailImage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Image image = Image.network('$urlRepo/asset/getImage/$id');
    return AlertDialog(
      content: SizedBox(width: image.width, height: image.height, child: image),
    );
  }
}
