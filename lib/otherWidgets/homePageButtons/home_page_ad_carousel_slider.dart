import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget homePageAdCarouselSlider(BuildContext context, void Function(String)? navigateToServices) {
  return CarouselSlider(
    options: CarouselOptions(
      height: MediaQuery.of(context).size.height * 0.25,
      animateToClosest: true,
      autoPlay: true,
      autoPlayCurve: Curves.ease,
      autoPlayInterval: const Duration(seconds: 15),
      enableInfiniteScroll: true,
      autoPlayAnimationDuration: const Duration(seconds: 2),
      viewportFraction: 1,
    ),
    items: [
      'assets/ZUBER.png',
      'assets/detailing_ad.png',
    ].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Material(
                color: Colors.transparent, // Use transparent to keep the image visible
                child: InkWell(
                  onTap: () {
                    if(i == 'assets/ZUBER.png') {
                      navigateToServices?.call('choosePartner');
                    } else if(i == 'assets/detailing_ad.png') {
                      navigateToServices?.call('chooseDiscount');
                    }
                  },
                  child: Image.asset(
                    i,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}