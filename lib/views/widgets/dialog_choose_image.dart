import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';

class DialogChooseImage extends ConsumerWidget {
  final List<Asset> assets;
  final int idSource;
  const DialogChooseImage(
      {super.key, required this.assets, required this.idSource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int idSelect = ref.watch(idSelectedAsset);

    return AlertDialog(
      actions: [
        TextButton(
            onPressed: idSelect == -1
                ? null
                : () {
                    ref
                        .read(assetNotifierProvider.notifier)
                        .changeImage(idSource, idSelect);
                    ref.invalidate(idSelectedAsset);
                    Navigator.pop(context);
                  },
            child: Text(
              'OK',
              style:
                  TextStyle(color: idSelect == -1 ? Colors.grey : Colors.green),
            )),
        TextButton(
            onPressed: () {
              ref.invalidate(idSelectedAsset);
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ))
      ],
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 0.5,
          height: MediaQuery.of(context).size.height / 0.2,
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Asset asset = assets[index];
                    return GestureDetector(
                      onTap: () =>
                          ref.read(idSelectedAsset.notifier).state = asset.id!,
                      child: Container(
                        decoration: asset.id == idSelect
                            ? const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.red)
                            : null,

                        // generate blues with random shades

                        child: Column(children: [
                          Image.network(
                            '$urlRepo/asset/getImage/${asset.id}',
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.3,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                          // ProgressiveImage.assetNetwork(
                          //   fit: BoxFit.contain,
                          //   blur: 0,
                          //   placeholder: 'assets/images/img_placeholder.jpg',
                          //   thumbnail: 'assets/images/img_thumbnail.jpg',
                          //   image: '$urlRepo/asset/getImage/${asset.id}',
                          //   height: MediaQuery.of(context).size.height * 0.3,
                          //   width: MediaQuery.of(context).size.width * 0.3,
                          // ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                asset.description!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                  childCount: assets.length,
                ),
              )
            ],
          )),
    );
  }
}
