import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/university/pickup_management/models/pickup_model.dart';
import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_cubit.dart';
import 'package:bus_system/features/university/pickup_management/views/widgets/location_picker_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:latlong2/latlong.dart';

class AddEditPickupSheet extends StatefulWidget {
  final PickupPoint? pickup;

  const AddEditPickupSheet({super.key, this.pickup});

  @override
  State<AddEditPickupSheet> createState() => _AddEditPickupSheetState();
}

class _AddEditPickupSheetState extends State<AddEditPickupSheet> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  double? _latitude;
  double? _longitude;
  String? _selectedLine;

  final List<String> _lines = ['Mokattam', 'Nasr City', '6 October'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pickup?.name ?? '');
    _addressController =
        TextEditingController(text: widget.pickup?.address ?? '');
    _latitude = widget.pickup?.latitude;
    _longitude = widget.pickup?.longitude;
    _selectedLine = widget.pickup?.lineName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerMap(
          initialLocation: _latitude != null && _longitude != null
              ? LatLng(_latitude!, _longitude!)
              : null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.width * 0.08,
        right: SizeConfig.width * 0.08,
        top: SizeConfig.height * 0.02,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + SizeConfig.height * 0.04,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.04),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.pickup == null
                        ? Icons.add_location_rounded
                        : Icons.edit_location_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pickup == null ? 'New Point' : 'Update Point',
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(fontSize: 24),
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Provide location details below',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.04),
            _buildLineSelection(),
            SizedBox(height: SizeConfig.height * 0.025),
            _buildCreativeTextField(
              label: 'Hub Name',
              controller: _nameController,
              hint: 'e.g. Science Building North',
              icon: Icons.business_rounded,
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            _buildLocationSection(),
            SizedBox(height: SizeConfig.height * 0.025),
            _buildCreativeTextField(
              label: 'Full Address / Landmarks',
              controller: _addressController,
              hint: 'e.g. Near the main gate fountain',
              maxLines: 2,
              icon: Icons.location_on_rounded,
            ),
            SizedBox(height: SizeConfig.height * 0.05),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  elevation: 12,
                  shadowColor: AppColors.kPrimaryColor.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.pickup == null
                        ? Icons.add_rounded
                        : Icons.save_rounded),
                    const SizedBox(width: 8),
                    Text(
                      widget.pickup == null
                          ? 'Create Location'
                          : 'Save Changes',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(fontSize: 18),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutQuad)
                .fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildLineSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Bus Line',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLine,
              isExpanded: true,
              hint: Text(
                'Select Bus Line',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.kPrimaryColor),
              items: _lines.map((String line) {
                return DropdownMenuItem<String>(
                  value: line,
                  child: Text(
                    '$line Line',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLine = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Coordinates',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        GestureDetector(
          onTap: _pickLocation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.map_rounded,
                    color: AppColors.kPrimaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _latitude == null || _longitude == null
                        ? 'Select Location on Map'
                        : '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _latitude == null
                          ? Colors.grey.shade400
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.kPrimaryColor, size: 20),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: AppColors.kPrimaryColor.withOpacity(0.3), width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ),
      ],
    );
  }

  void _submit() {
    final name = _nameController.text;
    final address = _addressController.text;

    if (name.isNotEmpty &&
        _latitude != null &&
        _longitude != null &&
        address.isNotEmpty &&
        _selectedLine != null) {
      if (widget.pickup == null) {
        context.read<ManagePickupCubit>().addPickup(PickupPoint(
              name: name,
              latitude: _latitude!,
              longitude: _longitude!,
              address: address,
              lineName: _selectedLine,
            ));
      } else {
        context.read<ManagePickupCubit>().updatePickup(widget.pickup!.copyWith(
              name: name,
              latitude: _latitude!,
              longitude: _longitude!,
              address: address,
              lineName: _selectedLine,
            ));
      }
      Navigator.pop(context);
    }
  }
}
