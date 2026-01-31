import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Modern profile picture picker with cropping
/// Displays a circular avatar with camera/gallery options
class ProfilePicturePicker extends StatefulWidget {
  const ProfilePicturePicker({
    super.key,
    this.imageUrl,
    this.imageFile,
    required this.onImageSelected,
    this.size = 120,
    this.showEditIcon = true,
    this.backgroundColor,
    this.iconColor,
  });

  final String? imageUrl;
  final File? imageFile;
  final Function(File) onImageSelected;
  final double size;
  final bool showEditIcon;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _showImageSourceSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Draggable handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Title
                const Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Camera option
                _buildImageSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take Photo',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                const SizedBox(height: AppConstants.spacingMD),

                // Gallery option
                _buildImageSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Choose from Gallery',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),

                // Remove photo option (if photo exists)
                if (widget.imageFile != null || widget.imageUrl != null) ...[
                  const SizedBox(height: AppConstants.spacingMD),
                  _buildImageSourceOption(
                    icon: Icons.delete_rounded,
                    label: 'Remove Photo',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Handle photo removal
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      // Crop the image
      final croppedFile = await _cropImage(pickedFile.path);

      if (croppedFile != null && mounted) {
        widget.onImageSelected(File(croppedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<CroppedFile?> _cropImage(String imagePath) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 70,
      maxWidth: 512,
      maxHeight: 512,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Photo',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Crop Profile Photo',
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          resetAspectRatioEnabled: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.showEditIcon ? _showImageSourceSheet : null,
      child: Stack(
        children: [
          // Main circular avatar
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.backgroundColor ?? AppColors.primary,
                  (widget.backgroundColor ?? AppColors.primary).withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? AppColors.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: widget.imageFile != null
                  ? Image.file(
                      widget.imageFile!,
                      fit: BoxFit.cover,
                    )
                  : widget.imageUrl != null
                      ? Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
            ),
          ),

          // Edit button overlay
          if (widget.showEditIcon)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: widget.iconColor ?? AppColors.primary,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: (widget.backgroundColor ?? AppColors.primary).withValues(alpha: 0.1),
      child: Icon(
        Icons.person_rounded,
        size: widget.size * 0.5,
        color: widget.iconColor ?? Colors.white,
      ),
    );
  }
}
