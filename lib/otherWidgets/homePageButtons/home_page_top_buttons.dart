import 'package:automate/homeOptions/classes/vehicle.dart';
import 'package:automate/baseFiles/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageAppointmentButton extends StatefulWidget {
  final void Function(String)? navigateToServices;

  const HomePageAppointmentButton({super.key, this.navigateToServices});

  @override
  _HomePageAppointmentButtonState createState() => _HomePageAppointmentButtonState();
}

class _HomePageAppointmentButtonState extends State<HomePageAppointmentButton> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds before showing the button content
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    int userState = userProvider.user != null ? 1 : 0;
    int appointmentCount = userProvider.appointmentCount;

    if (isLoading) {
      // Show loading indicator initially
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.27,
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (appointmentCount == 1) {
      // Show button with appointment count
      return _buildAppointmentButton(appointmentCount, 'viewAppointments', 'booking\n planned');
    } else if (appointmentCount > 1) {
      // Show button with appointment count
      return _buildAppointmentButton(appointmentCount, 'viewAppointments', 'booking(s)\n planned');
    } else if (appointmentCount == 0 && userState == 1) {
      // Show button to book an appointment
      return _buildAppointmentButton(0, 'makeAppointment', 'Press to book an appointment');
    } else {
      // Default case for guest or no action
      return _buildNoActionNeededButton();
    }
  }

  Widget _buildAppointmentButton(int count, String action, String message) {
    return ElevatedButton(
      onPressed: () => widget.navigateToServices?.call(action),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        )
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.27,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(count > 0) Text(
                  '$count',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                if(count > 0) const SizedBox(width: 5),
                if(count > 0)
                Expanded(child: Text(message, style: const TextStyle(fontSize: 14), textAlign: TextAlign.end)),
                if(count == 0)
                Expanded(child: Text(message, style: const TextStyle(fontSize: 14), textAlign: TextAlign.center)),
              ],
            ),
            if(count > 0)
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('press to view', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoActionNeededButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent)
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.27,
        child: const Center(
          child: Text('Login to make an appointment', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

// Widget that uses defaultVehicle

Widget homePageVehicleDetailsButton(BuildContext context) {
  return Consumer<UserProvider>(
    builder: (context, userProvider, child) {
      Vehicle? defaultVehicle = userProvider.defaultVehicle;
      if (defaultVehicle == null) {
        return ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addVehiclePage'); // Assuming '/addVehiclePage' is the route to add a new vehicle
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            )),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.27,
            child: const Center(child: Text('Add a vehicle first', textAlign: TextAlign.center)),
          ),
        );
      } else {
        return ElevatedButton(
          onPressed: () {
            // Actions to see more details or manage the vehicle
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            )),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.27,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  defaultVehicle.make,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                Expanded(child: Text(defaultVehicle.model, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
              ],
            ),
          ),
        );
      }
    },
  );
}
