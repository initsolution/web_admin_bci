import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_profile_employee.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var username =
        ref.watch(userDataProvider.select((value) => value.username));
    String token = ref.watch(userDataProvider.select((value) => value.token));
    Employee employee = Employee.fromMap(JwtDecoder.decode(token)['employee']);
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          Future(() => ref
              .read(employeeNotifierProvider.notifier)
              .getOneEmployee(employee.nik!));

          return const SizedBox(child: DialogProfileEmployee());
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        // decoration: BoxDecoration(
        //   color: kPrimaryColor,
        //   borderRadius: const BorderRadius.all(Radius.circular(10)),
        //   // border: Border.all(color: Colors.white),
        // ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/ic_profile.png",
              height: 30,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                child: Text(
                  username,
                  style: const TextStyle(color: Colors.white),
                )),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
