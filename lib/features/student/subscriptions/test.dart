// import 'package:bus_system/core/utilies/assets/lotties/app_lotties.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:lottie/lottie.dart';

// class AppColors {
//   AppColors._();

//   static const Color primaryBlue = Color(0xFF0D4C73);
//   static const Color kPrimaryColor = Color(0xFF27AE60);
//   static const Color kSecondaryColor = Color(0xFF81C784);
//   static const Color background = Color(0xFFF8FAFC);
//   static const Color cardBg = Colors.white;
//   static const Color textPrimary = primaryBlue;
//   static const Color textSecondary = Color(0xFF64748B);

//   static const LinearGradient primaryGradient = LinearGradient(
//     colors: [primaryBlue, Color(0xFF1E88E5)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
// }

// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});

//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   String selectedPlan = "Yearly";

//   final List<Map<String, dynamic>> plans = [
//     {
//       "name": "Monthly",
//       "period": "1 Month",
//       "price": "450",
//       "oldPrice": "",
//       "save": "",
//       "icon": Icons.calendar_today_rounded,
//       "color": AppColors.kSecondaryColor,
//       "popular": false,
//       "features": [
//         "Unlimited trips",
//         "Live GPS tracking",
//         "Chat with driver",
//         "Cancel anytime",
//       ],
//     },
//     {
//       "name": "Semester",
//       "period": "3 Months",
//       "price": "1250",
//       "oldPrice": "1350",
//       "save": "Save 100 EGP",
//       "icon": Icons.school_rounded,
//       "color": AppColors.kPrimaryColor,
//       "popular": false,
//       "features": [
//         "All Monthly features",
//         "Priority seat selection",
//         "Trip history & reports",
//         "Free pickup & drop-off",
//       ],
//     },
//     {
//       "name": "Yearly",
//       "period": "12 Months",
//       "price": "4200",
//       "oldPrice": "5400",
//       "save": "Save 1200 EGP • Best Value",
//       "icon": Icons.emoji_events_rounded,
//       "color": Color(0xFFFFC107),
//       "popular": true,
//       "features": [
//         "All Semester features",
//         "VIP Support",
//         "Free university merch",
//         "2 months free",
//         "Exclusive student events",
//       ],
//     },
//   ];

//   void _showPaymentSuccess() {
//     final plan = plans.firstWhere((p) => p["name"] == selectedPlan);
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           padding: const EdgeInsets.all(32),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(36),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.25),
//                 blurRadius: 30,
//                 offset: Offset(0, 15),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Lottie.asset(
//                 AppLotties.paymentLottie,
//                 width: 160,
//                 height: 160,
//                 repeat: false,
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 "Payment Successful!",
//                 style: GoogleFonts.cairo(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 "${plan["name"]} Plan Activated",
//                 style: GoogleFonts.cairo(
//                   fontSize: 18,
//                   color: AppColors.kPrimaryColor,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Enjoy your rides to campus",
//                 style: GoogleFonts.cairo(
//                   fontSize: 15,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kPrimaryColor,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   "Go to Home",
//                   style: GoogleFonts.cairo(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedPlanData = plans.firstWhere((p) => p["name"] == selectedPlan);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Column(
//         children: [
//           // Header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(20, 44, 20, 28),
//             decoration: BoxDecoration(
//               gradient: AppColors.primaryGradient,
//               borderRadius: const BorderRadius.vertical(
//                 bottom: Radius.circular(36),
//               ),
//             ),
//             child: SafeArea(
//               bottom: false,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.18),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.directions_bus_rounded,
//                       size: 36,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Choose Your Plan",
//                           style: GoogleFonts.cairo(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             height: 1.15,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Safe & comfortable rides to campus at the best prices",
//                           style: GoogleFonts.cairo(
//                             fontSize: 15,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Column(
//                 children: [
//                   Text(
//                     "Select the perfect subscription for you",
//                     style: GoogleFonts.cairo(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   ...plans.map((plan) {
//                     final isSelected = selectedPlan == plan["name"];
//                     return GestureDetector(
//                       onTap: () => setState(() => selectedPlan = plan["name"]),
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 280),
//                         margin: const EdgeInsets.only(bottom: 16),
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: AppColors.cardBg,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: isSelected
//                                 ? plan["color"]
//                                 : Colors.transparent,
//                             width: isSelected ? 2.8 : 1,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: isSelected
//                                   ? plan["color"].withOpacity(0.28)
//                                   : Colors.black.withOpacity(0.05),
//                               blurRadius: 18,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: plan["color"].withOpacity(0.12),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     plan["icon"],
//                                     color: plan["color"],
//                                     size: 28,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   plan["name"],
//                                   style: GoogleFonts.cairo(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 if (plan["popular"])
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 14,
//                                       vertical: 6,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       gradient: AppColors.primaryGradient,
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                     child: const Text(
//                                       "BEST VALUE",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "${plan["price"]} EGP",
//                                   style: GoogleFonts.cairo(
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     color: plan["color"],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 4),
//                                   child: Text(
//                                     plan["period"],
//                                     style: GoogleFonts.cairo(
//                                       fontSize: 15,
//                                       color: AppColors.textSecondary,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             if (plan["save"].isNotEmpty)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 4),
//                                 child: Text(
//                                   plan["save"],
//                                   style: GoogleFonts.cairo(
//                                     color: Colors.green.shade700,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                             const SizedBox(height: 20),
//                             ...plan["features"].map(
//                               (f) => Padding(
//                                 padding: const EdgeInsets.only(bottom: 10),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Icon(
//                                       Icons.check_circle,
//                                       color: AppColors.kPrimaryColor,
//                                       size: 20,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                       child: Text(
//                                         f,
//                                         style: GoogleFonts.cairo(
//                                           fontSize: 15.5,
//                                           height: 1.4,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),

//       // Sticky Pay Button
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 16,
//               offset: const Offset(0, -6),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           top: false,
//           child: SizedBox(
//             height: 58,
//             child: ElevatedButton(
//               onPressed: _showPaymentSuccess,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.kPrimaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 "Pay ${selectedPlanData["price"]} EGP Now",
//                 style: GoogleFonts.cairo(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }