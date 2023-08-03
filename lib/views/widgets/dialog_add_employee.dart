import 'package:flutter/material.dart';

class DialogAddEmployee extends StatelessWidget {
  DialogAddEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Employee'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('NIK'),
              const TextField(
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Please type your NIK',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('NAME'),
              const TextField(
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Please type your NAME',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('EMAIL'),
              const TextField(
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Please type your EMAIL',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Password'),
              const TextField(
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Please type your Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Phone Number'),
              const TextField(
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Please type your Phone Number',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Role'),
                        getDropdownRole(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Active'),
                        getDropdownActive(),
                      ],
                    ),
                  ),
                ],
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
      // actions: [ElevatedButton(onPressed: null, child: Text('Save'))],
    );
  }

  Widget getDropdownRole() {
    var initialVal = "Maker";
    var func;
    return DropdownButton(
      value: initialVal,
      onChanged: (value) =>
          func, // =========== Here the error occurs ==========================
      items: <String>['Maker', 'Verifikator', 'Admin']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget getDropdownActive() {
    String? initialVal = "Vendor";
    var func;
    return DropdownButton(
      value: initialVal,
      onChanged: (value) {
        debugPrint(value);
      }, // =========== Here the error occurs ==========================
      items: <String>['Vendor', 'Internal']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
