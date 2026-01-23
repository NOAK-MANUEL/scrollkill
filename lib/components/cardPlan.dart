

import 'package:flutter/material.dart';
import 'package:scrollkill/components/customPopupModel.dart';

class CardPlan extends StatelessWidget {
  const CardPlan({super.key,required this.currentSchedule, required this.wrapper, required this.editSchedule,required this.deleteSchedule});
  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
  final dynamic wrapper;
  final Future<void> Function(DateTime id) deleteSchedule;
  final Future<void> editSchedule;
  String getInterval(int period) {
    switch (period) {
      case 0:
        return ("S");
      case 1:
        return ("M");
      case 2:
        return ("T");
      case 3:
        return ("W");
      case 4:
        return ("T");
      case 5:
        return ("F");

      default:
        return ("S");
    }
  }


  final dynamic currentSchedule;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentSchedule.hardFocus)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.lock,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                /// TITLE
                Expanded(
                  child: Text(
                    _capitalize(currentSchedule.title),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                CustomPopupModel(wrapper: wrapper, currentSchedule: currentSchedule, editSchedule: editSchedule, deleteSchedule: deleteSchedule)
              ],
            ),

            /// DESCRIPTION
            if (currentSchedule.description != null) ...[
              const SizedBox(height: 4),
              Text(
                currentSchedule.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ],

            const SizedBox(height: 12),

            /// DATE RANGE
            if(currentSchedule.startDate)
                Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),


                Expanded(
                  child: Text(
                    "From ${currentSchedule.startDate.format(context)} "
                        "to ${currentSchedule.endDate.format(context)} "
                        "${currentSchedule.periods.isEmpty ? "• Tomorrow" : ""}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),

            /// PERIOD CHIPS
            if (currentSchedule.periods != null &&  currentSchedule.periods.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: currentSchedule.periods
                    .map(
                      (period) => Chip(
                    label: Text(getInterval(period)),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  ),
                )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
