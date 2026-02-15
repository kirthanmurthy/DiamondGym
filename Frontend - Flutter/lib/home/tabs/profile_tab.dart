import 'package:flutter/material.dart';

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
    super.key,
  });

  final TextEditingController profileNameController;
  final TextEditingController profileRestrictionsController;
  final TextEditingController profileHeightController;
  final TextEditingController profileWeightController;
  final VoidCallback onSave;
  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(title: 'Profile'),
          const SizedBox(height: 8),
          InputField(controller: profileNameController, label: 'Name'),
          const SizedBox(height: 8),
          InputField(
            controller: profileRestrictionsController,
            label: 'Dietary restrictions',
          ),
          const SizedBox(height: 8),
          InputField(controller: profileHeightController, label: 'Height'),
          const SizedBox(height: 8),
          InputField(controller: profileWeightController, label: 'Weight'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onSave, child: const Text('Save profile')),
          const SizedBox(height: 20),
          if (profile.isEmpty)
            const Text('Saved profile will display here once you tap Save.'),
          if (!profile.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${profile.name}'),
                Text('Dietary restrictions: ${profile.restrictions}'),
                Text('Height: ${profile.height}'),
                Text('Weight: ${profile.weight}'),
              ],
            ),
        ],
      ),
    );
  }
}
