import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/url.dart';

class DialogDetailImage extends StatelessWidget {
  final int id;
  final String description;
  const DialogDetailImage({
    super.key,
    required this.id,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Image image = Image.network('$urlRepo/asset/getImage/$id');
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Center(child: image),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: SingleChildScrollView(
              child: Expanded(
                child: Text(
                  softWrap: true,
                  description,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
