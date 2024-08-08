import 'package:automate/baseFiles/classes/vehicle.dart';
import 'package:automate/baseFiles/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageAppointmentButton extends StatefulWidget {
  final void Function(String)? navigateToServices;

  const HomePageAppointmentButton({super.key, this.navigateToServices});

  @override
  _HomePageAppointmentButtonState createState() =>
      _HomePageAppointmentButtonState();
}

class _HomePageAppointmentButtonState extends State<HomePageAppointmentButton> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool isUserLoggedIn = userProvider.user != null;
    int appointmentCount = userProvider.appointmentCount;

    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.27,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return isUserLoggedIn
        ? _buildLoggedInButtons(context, appointmentCount)
        : _buildLoginButton(context);
  }

  Widget _buildLoggedInButtons(BuildContext context, int appointmentCount) {
    return Row(
      children: [
        if (appointmentCount > 0)
          _buildAppointmentButton(
              appointmentCount, 'viewAppointments', 'booking(s) planned')
        else
          _buildAppointmentButton(
              0, 'makeAppointment', 'Press to book an appointment'),
        const SizedBox(width: 18),
        homePageVehicleDetailsButton(context),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 4),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.47,
            child: const Center(
              child: Text('Log in to unlock more details',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentButton(int count, String action, String message) {
    return ElevatedButton(
      onPressed: () => widget.navigateToServices?.call(action),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
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
                if (count > 0)
                  Text(
                    '$count',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                if (count > 0) const SizedBox(width: 5),
                Expanded(
                    child: Text(message,
                        style: const TextStyle(fontSize: 14),
                        textAlign:
                            count > 0 ? TextAlign.end : TextAlign.center)),
              ],
            ),
            if (count > 0)
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('press to view',
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                ),
              ),
          ],
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
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            ),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.27,
            child: const Center(
                child:
                    Text('Add a vehicle first', textAlign: TextAlign.center)),
          ),
        );
      } else {
        return ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.27,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      defaultVehicle.make,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    const Icon(Icons.directions_car,
                        size: 32),
                  ],
                ),
                Text(defaultVehicle.model,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('default vehicle',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}
