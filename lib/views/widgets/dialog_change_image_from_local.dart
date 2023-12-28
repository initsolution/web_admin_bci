import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';

// ignore: must_be_immutable
class DialogChangeImageFromLocal extends ConsumerWidget {
  final int idAsset;
  final int idTask;
  DialogChangeImageFromLocal(
      {super.key, required this.idAsset, required this.idTask});

  FilePickerResult? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  pickFile();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    margin: const EdgeInsets.only(
                      left: 183.00,
                      top: 10.00,
                      right: 113.00,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(
                        5.00,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (result != null) {
                    ref
                        .read(assetNotifierProvider.notifier)
                        .changeImageFromLocal(
                            idAsset, result!.files.first.bytes, idTask);
                    Navigator.pop(context);
                  }
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    margin: const EdgeInsets.only(
                      left: 183.00,
                      top: 10.00,
                      right: 113.00,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(
                        5.00,
                      ),
                    ),
                    child: const Icon(
                      Icons.upload,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void pickFile() async {
    result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Get E-Sign',
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) {
        if (status == FilePickerStatus.done) {
          debugPrint('finish pick');
          // ref.read(backgroundIsDonePickFile.notifier).state = true;
          // context
          //     .read<BackgroundBloc>()
          //     .add(SetStatusPickFileBackground(statusPick: true));
        }
      },
      allowedExtensions: ['jpg'],
    );
  }
}
