// // widgets/nearest_pickup_card.dart
// import 'package:bus_system/core/utilies/colors/app_colors.dart';
// import 'package:bus_system/core/utilies/extensions/app_extensions.dart';
// import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class NearestPickupCard extends StatelessWidget {
//   const NearestPickupCard({super.key});

//   static const String nearestPickup = "City Stars - Nasr City";
//   static const String distance = "650 m";
//   static const String nextBusTime = "07:20 AM";

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(26.w),
//       decoration: BoxDecoration(
//         gradient: AppColors.cardGradient,
//         borderRadius: BorderRadius.circular(40.r), // .r لو عندك extension للـ radius
//         border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryBlue.withOpacity(0.15),
//             blurRadius: 65.sp,
//             offset: Offset(0, 25.h),
//           ),
//           // ... باقي الـ shadow
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.star_rounded, size: 40.sp, color: AppColors.kPrimaryColor),
//               SizedBox(width: 14.w),
//               Text("Nearest Pickup", style: AppTextStyles.title22PrimaryW700),
//             ],
//           ),
//           SizedBox(height: 18.h),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(
//               nearestPickup,
//               style: AppTextStyles.title28PrimaryBold, // ← لو ضفناها
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             "$distance away • Next bus $nextBusTime",
//             style: AppTextStyles.title16Secondary,
//           ),
//           SizedBox(height: 26.h),
//           const BookRideButton(),
//         ],
//       ),
//     ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9));
//   }
// }

// class BookRideButton extends StatelessWidget {
//   const BookRideButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 19.h),
//         decoration: BoxDecoration(
//           gradient: AppColors.primaryGradient,
//           borderRadius: BorderRadius.circular(40.r),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.kPrimaryColor.withOpacity(0.4),
//               blurRadius: 25.sp,
//               offset: Offset(0, 12.h),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Book Ride Now 🚀",
//               style: AppTextStyles.title17PrimaryW500?.copyWith(color: Colors.white) 
//                   ?? const TextStyle(/* fallback */),
//             ),
//             SizedBox(width: 10.w),
//             Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24.sp),
//           ],
//         ),
//       ),
//     );
//   }
// }