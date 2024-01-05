import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';

// ignore: must_be_immutable
class DialogChangeImageFromLocal extends ConsumerStatefulWidget {
  final int idAsset;
  final int idTask;
  final String description;
  const DialogChangeImageFromLocal(
      {super.key,
      required this.idAsset,
      required this.idTask,
      required this.description});

  @override
  ConsumerState<DialogChangeImageFromLocal> createState() =>
      _DialogChangeImageFromLocalState();
}

class _DialogChangeImageFromLocalState
    extends ConsumerState<DialogChangeImageFromLocal> {
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          width: 530,
          height: 660,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  pickFile();
                },
                child: result != null
                    ? Container(
                        height: 500.0,
                        width: 500.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.00),
                        ),
                        child: Image.memory(result!.files.first.bytes!),
                      )
                    : Container(
                        height: 500.0,
                        width: 500.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.00),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Expanded(
                    child: Text(
                      softWrap: true,
                      widget.description,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 530,
                height: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    if (result != null) {
                      ref
                          .read(assetNotifierProvider.notifier)
                          .changeImageFromLocal(widget.idAsset,
                              result!.files.first.bytes, widget.idTask);
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.upload,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     if (result != null) {
              //       ref
              //           .read(assetNotifierProvider.notifier)
              //           .changeImageFromLocal(widget.idAsset,
              //               result!.files.first.bytes, widget.idTask);
              //       Navigator.pop(context);
              //     }
              //   },
              //   child: Container(
              //     width: 500.0,
              //     height: 40,
              //     decoration: BoxDecoration(
              //       color: Colors.lightBlue,
              //       borderRadius: BorderRadius.circular(5.00),
              //     ),
              //     child: const Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.upload,
              //           size: 20,
              //           color: Colors.white,
              //         ),
              //         SizedBox(width: 10),
              //         Text(
              //           'Upload',
              //           style: TextStyle(color: Colors.white),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          )),
    );
  }

  Future<void> pickFile() async {
    await FilePicker.platform.pickFiles(
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
    ).then((value) {
      if (value != null) {
        setState(() {
          result = value;
        });
      }
    });
  }
}
