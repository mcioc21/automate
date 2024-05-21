import 'package:flutter/material.dart';

Widget homePageAppointmentButton(BuildContext context, int userState) {
  if (userState == 2) {
    return ElevatedButton(
      onPressed: () {
        // Action for button press
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      )),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.27,
        child: const Text('Placeholder', textAlign: TextAlign.center),
      ),
    );
  } else {
    if (userState == 1) {
      return ElevatedButton(
        onPressed: () {
          // Action for button press
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        )),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.27,
          child: const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child:
                Text('No appointments made yet', textAlign: TextAlign.center),
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          // Action for button press
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        )),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.27,
            child: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('Login to make an appointment',
                  textAlign: TextAlign.center),
            )),
      );
    }
  }
}

Widget homePageVehicleDetailsButton(BuildContext context, int userState) { //TO DO
  return ElevatedButton(
    onPressed: () {
      // Action for button press
    },
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    )),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.27,
      child: const Text('Vehicle details', textAlign: TextAlign.center),
    ),
  );
}
