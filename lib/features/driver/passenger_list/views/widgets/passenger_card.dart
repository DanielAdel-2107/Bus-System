import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/driver/passenger_list/models/passenger_model.dart';
import 'package:flutter/material.dart';

class PassengerCard extends StatelessWidget {
  final PassengerModel passenger;

  const PassengerCard({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    final bool isMale = passenger.isMale;
    final Color genderColor = isMale ? const Color(0xFF38BDF8) : const Color(0xFFF472B6); // Sleek cyan/blue vs chic pink
    final IconData genderIcon = isMale ? Icons.face_rounded : Icons.face_3_rounded;

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: Offset(0, SizeConfig.height * 0.008),
          ),
          BoxShadow(
            color: genderColor.withOpacity(0.08),
            blurRadius: 30,
            offset: Offset(0, SizeConfig.height * 0.012),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Section - Seat Number (The Ticket Stub)
              Container(
                width: SizeConfig.width * 0.22,
                color: genderColor.withOpacity(0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_seat_rounded,
                      color: genderColor.withOpacity(0.6),
                      size: SizeConfig.height * 0.03,
                    ),
                    SizedBox(height: SizeConfig.height * 0.008),
                    Text(
                      "Seat",
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(fontSize: 12),
                        fontWeight: FontWeight.w700,
                        color: genderColor.withOpacity(0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "${passenger.seatNumber}",
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(fontSize: 28),
                        fontWeight: FontWeight.w900,
                        color: genderColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              // Dotted Separator Line
              SizedBox(
                width: SizeConfig.width * 0.05,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(12, (index) {
                    return Container(
                      width: 2,
                      height: SizeConfig.height * 0.005,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),

              // Right Section - Passenger Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    SizeConfig.height * 0.025,
                    SizeConfig.width * 0.04,
                    SizeConfig.height * 0.025,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(genderIcon, size: SizeConfig.height * 0.024, color: Colors.grey.shade400),
                          SizedBox(width: SizeConfig.width * 0.02),
                          Expanded(
                            child: Text(
                              passenger.name,
                              style: TextStyle(
                                fontSize: getResponsiveFontSize(fontSize: 18),
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E293B), // Premium Slate color
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.height * 0.012),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone_in_talk_rounded,
                              size: SizeConfig.height * 0.015,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: SizeConfig.width * 0.02),
                          Expanded(
                            child: Text(
                              passenger.phoneNumber,
                              style: TextStyle(
                                fontSize: getResponsiveFontSize(fontSize: 14),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          // Premium Call Action Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(SizeConfig.height * 0.012),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.kPrimaryColor.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.call_rounded,
                                  color: Colors.white,
                                  size: SizeConfig.height * 0.024,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
