import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'There are no tasks yet,\nPress the button\nTo add New Task',
            textAlign: TextAlign.center,
            style: AppFonts.bodyRegular,
          ),
          const SizedBox(height: 24),
          Image.asset(AppAssets.noTasksPng, height: 210),
        ],
      ),
    );
  }
}
