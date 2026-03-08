// import 'package:lottie/lottie.dart';
// import 'package:bus_system/core/app_route/route_names.dart';
// import 'package:bus_system/core/utilies/assets/lotties/app_lotties.dart';
// import 'package:bus_system/core/utilies/extensions/app_extensions.dart';
// import 'package:bus_system/core/utilies/sizes/sized_config.dart';
// import 'package:flutter/material.dart';
// import 'package:liquid_swipe/liquid_swipe.dart';

// class OnBoardingScreenBody extends StatefulWidget {
//   @override
//   _OnBoardingScreenBodyState createState() => _OnBoardingScreenBodyState();
// }

// class _OnBoardingScreenBodyState extends State<OnBoardingScreenBody> {
//   final Color primaryColor = Color(0xFF27AE60);
//   final ValueNotifier<int> currentPageNotifier = ValueNotifier(0);
//   late LiquidController liquidController;

//   final pages = [
//     {
//       "title": "Welcome to Puls Care",
//       "description":
//           "Monitor your health and take care of your heart with our smart wrist device that tracks your pulse and analyzes your vital signs.",
//       "image": AppLotties.busLottie, // مثال صورة ساعة ذكية
//     },
//     {
//       "title": "Track Your Vital Signs",
//       "description":
//           "Measure your heart rate, blood pressure, and oxygen levels accurately and effortlessly.",
//       "image": AppLotties.pickLocationLottie, // مثال صورة graph
//     },
//     {
//       "title": "Stay Alert to Risks",
//       "description":
//           "Receive instant alerts if any health risks are detected, along with personalized care suggestions.",
//       "image": AppLotties., // مثال bell+warning
//     },
//     {
//       "title": "Personal Health Guidance",
//       "description":
//           "Get daily tips to maintain a healthy lifestyle, track your activity, and care for your overall wellbeing.",
//       "image": AppLotties.chartLottie, // مثال sun/exercise/water
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     liquidController = LiquidController();
//   }

//   @override
//   void dispose() {
//     currentPageNotifier.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context); // Initialize SizeConfig for responsive sizing

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           LiquidSwipe(
//             liquidController: liquidController,
//             pages: pages
//                 .asMap()
//                 .entries
//                 .map((entry) => buildPage(context, entry.value, entry.key))
//                 .toList(),
//             fullTransitionValue: 800,
//             enableLoop: false,
//             enableSideReveal: true,
//             waveType: WaveType.liquidReveal,
//             // currentUpdateTypeCallback: currentPageNotifier,
//             onPageChangeCallback: (index) {
//               currentPageNotifier.value = index;
//             },
//             positionSlideIcon: 0.7,
//             slideIconWidget: Container(
//               padding: EdgeInsets.all(SizeConfig.width * 0.02), // 2% من العرض
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(SizeConfig.width * 0.05), // 5% من العرض
//               ),
//               child:
//                   Icon(Icons.arrow_forward_ios, color: Colors.white, size: SizeConfig.width * 0.05), // 5% من العرض
//             ),
//             ignoreUserGestureWhileAnimating: false,
//             // revealCurve: Curves.easeInOutCubic,
//           ),
//           // مؤشر الصفحات في الأسفل محسن مع ValueListenableBuilder للتحديث التلقائي
//           ValueListenableBuilder<int>(
//             valueListenable: currentPageNotifier,
//             builder: (context, currentIndex, child) {
//               return Positioned(
//                 bottom: SizeConfig.height * 0.15, // 15% من الارتفاع
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(pages.length, (index) {
//                     return AnimatedContainer(
//                       duration: Duration(milliseconds: 300),
//                       margin: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.01), // 1% من العرض
//                       width: currentIndex == index ? SizeConfig.width * 0.06 : SizeConfig.width * 0.03, // 6% أو 3% من العرض
//                       height: SizeConfig.height * 0.015, // 1.5% من الارتفاع
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: currentIndex == index
//                               ? [Colors.white, Colors.white.withOpacity(0.8)]
//                               : [Colors.white38, Colors.white24],
//                         ),
//                         borderRadius: BorderRadius.circular(SizeConfig.width * 0.015), // 1.5% من العرض
//                         boxShadow: currentIndex == index
//                             ? [
//                                 BoxShadow(
//                                   color: Colors.white.withOpacity(0.5),
//                                   blurRadius: SizeConfig.width * 0.01, // 1% من العرض
//                                   offset: Offset(0, SizeConfig.height * 0.005), // 0.5% من الارتفاع
//                                 ),
//                               ]
//                             : null,
//                       ),
//                     );
//                   }),
//                 ),
//               );
//             },
//           ),
//           // أزرار التنقل في الأسفل محسنة
//           ValueListenableBuilder<int>(
//             valueListenable: currentPageNotifier,
//             builder: (context, currentIndex, child) {
//               return Positioned(
//                 bottom: SizeConfig.height * 0.04, // 4% من الارتفاع
//                 left: SizeConfig.width * 0.05, // 5% من العرض
//                 right: SizeConfig.width * 0.075, // 7.5% من العرض
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (currentIndex != 0 && currentIndex != pages.length - 1)
//                       GestureDetector(
//                         onTap: () => liquidController.animateToPage(page: 0),
//                         child: Text(
//                           "Skip",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: SizeConfig.width * 0.04, // 4% من العرض
//                             fontWeight: FontWeight.w500,
//                             shadows: [
//                               Shadow(
//                                 offset: Offset(SizeConfig.width * 0.0025, SizeConfig.height * 0.0025), // 0.25% من العرض/الارتفاع
//                                 blurRadius: SizeConfig.width * 0.005, // 0.5% من العرض
//                                 color: Colors.black26,
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     else
//                       SizedBox(width: SizeConfig.width * 0.15), // 15% من العرض
//                     if (currentIndex < pages.length - 1)
//                       GestureDetector(
//                         onTap: () => liquidController.animateToPage(
//                             page: currentIndex + 1),
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 200),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: SizeConfig.width * 0.05, // 5% من العرض
//                               vertical: SizeConfig.height * 0.015), // 1.5% من الارتفاع
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(SizeConfig.width * 0.0625), // 6.25% من العرض
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: SizeConfig.width * 0.02, // 2% من العرض
//                                 offset: Offset(0, SizeConfig.height * 0.01), // 1% من الارتفاع
//                               ),
//                             ],
//                           ),
//                           child: Icon(Icons.arrow_forward_ios,
//                               color: primaryColor, size: SizeConfig.width * 0.05), // 5% من العرض
//                         ),
//                       )
//                     else
//                       ElevatedButton(
//                         onPressed: () {
//                           context.pushReplacementScreen(RouteNames.signInScreen);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: primaryColor,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: SizeConfig.width * 0.1, // 10% من العرض
//                               vertical: SizeConfig.height * 0.01875), // ~1.875% من الارتفاع
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(SizeConfig.width * 0.075)), // 7.5% من العرض
//                           elevation: 8,
//                         ),
//                         child: Text(
//                           "Get Started",
//                           style: TextStyle(
//                               fontSize: SizeConfig.width * 0.045, // 4.5% من العرض
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildPage(BuildContext context, Map<String, String> page, int index) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.075, // 7.5% من العرض
//           vertical: SizeConfig.height * 0.075), // 7.5% من الارتفاع
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             primaryColor,
//             primaryColor.withOpacity(0.9),
//             primaryColor.withOpacity(0.7),
//             primaryColor.withOpacity(0.5),
//           ],
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Text(
//             page["title"]!,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: SizeConfig.width * 0.07, // 7% من العرض
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                   offset: Offset(SizeConfig.width * 0.0025, SizeConfig.height * 0.0025), // 0.25% من العرض/الارتفاع
//                   blurRadius: SizeConfig.width * 0.01, // 1% من العرض
//                   color: Colors.black38,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: SizeConfig.height * 0.35, // 35% من الارتفاع
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.25),
//               borderRadius: BorderRadius.circular(SizeConfig.width * 0.0625), // 6.25% من العرض
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(SizeConfig.width * 0.0625), // 6.25% من العرض
//               child: Lottie.asset(
//                 page["image"]!,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//               left: SizeConfig.width * 0.025, // 2.5% من العرض
//               right: SizeConfig.width * 0.075, // 7.5% من العرض
//             ),
//             child: Text(
//               page["description"]!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: SizeConfig.width * 0.045, // 4.5% من العرض
//                 color: Colors.white,
//                 height: 1.5,
//                 shadows: [
//                   Shadow(
//                     offset: Offset(SizeConfig.width * 0.0025, SizeConfig.height * 0.0025), // 0.25% من العرض/الارتفاع
//                     blurRadius: SizeConfig.width * 0.005, // 0.5% من العرض
//                     color: Colors.black26,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: SizeConfig.height * 0.025), // 2.5% من الارتفاع
//         ],
//       ),
//     );
//   }
// }
