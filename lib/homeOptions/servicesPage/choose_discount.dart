import 'package:automate/homeOptions/servicesPage/discount_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:automate/baseFiles/app_theme.dart';
import 'package:automate/baseFiles/classes/discount.dart';

class DiscountsPage extends StatelessWidget {
  const DiscountsPage({super.key});

  Future<List<Discount>> loadDiscounts() async {
    final jsonString = await rootBundle.loadString('assets/discounts.json');
    return Discount.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 8.0), child:
    Scaffold(
      appBar: AppBar(
        title: const Text("Discounts"),
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.snow,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Discount>>(
        future: loadDiscounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DiscountViewPage(discount: snapshot.data![index]),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            snapshot.data![index].shortDescription,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No discounts found.'));
          }
        },
      ),
    )
    );
  }
}
