import 'package:flutter/cupertino.dart';

import '../models/app_models.dart';
import '../widgets/common_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    required this.profileNameController,
    required this.profileRestrictionsController,
    required this.profileHeightController,
    required this.profileWeightController,
    required this.onSave,
    required this.profile,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final TextEditingController profileNameController;
  final TextEditingController profileRestrictionsController;
  final TextEditingController profileHeightController;
  final TextEditingController profileWeightController;
  final VoidCallback onSave;
  final ProfileData profile;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Save your dietary preferences and body stats.',
            style: TextStyle(color: textSecondary),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Your info',
            titleColor: textPrimary,
            background: card,
            border: border,
            child: Column(
              children: [
                InputField(
                  controller: profileNameController,
                  label: 'Name',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 14),
                InputField(
                  controller: profileRestrictionsController,
                  label: 'Dietary restrictions',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 14),
                InputField(
                  controller: profileHeightController,
                  label: 'Height',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 14),
                InputField(
                  controller: profileWeightController,
                  label: 'Weight',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 16),
                GymButton(
                  label: 'Save profile',
                  onPressed: onSave,
                  primary: primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Saved profile',
            titleColor: textPrimary,
            background: card,
            border: border,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.isEmpty)
                  Text(
                    'Saved profile will display here once you tap Save.',
                    style: TextStyle(color: textSecondary),
                  ),
                if (!profile.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${profile.name}',
                        style: TextStyle(color: textPrimary),
                      ),
                      Text(
                        'Dietary restrictions: ${profile.restrictions}',
                        style: TextStyle(color: textPrimary),
                      ),
                      Text(
                        'Height: ${profile.height}',
                        style: TextStyle(color: textPrimary),
                      ),
                      Text(
                        'Weight: ${profile.weight}',
                        style: TextStyle(color: textPrimary),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
