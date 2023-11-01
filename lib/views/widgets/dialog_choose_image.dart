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
            onPressed: () {
              ref
                  .read(assetNotifierProvider.notifier)
                  .changeImage(idSource, idSelect);
              Navigator.pop(context);
              PaintingBinding.instance.imageCache.clear();
            },
            child: const Text('OK'))
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
                  childAspectRatio: 2.0,
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

                        child: Image.network(
                            '$urlRepo/asset/getImage/${asset.id}'),
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
