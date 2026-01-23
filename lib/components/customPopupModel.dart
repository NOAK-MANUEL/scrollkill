import 'package:flutter/material.dart';

class CustomPopupModel extends StatelessWidget {
  const CustomPopupModel({super.key, required this.wrapper,required this.currentSchedule, required this.editSchedule , required this.deleteSchedule});

  final dynamic wrapper;
  final dynamic currentSchedule;
  final Future<void> editSchedule;
  final Future<void> Function(DateTime id) deleteSchedule;

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }


  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<String>(
      onSelected: (value) {
        if (value == "edit") {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => wrapper(
              editContent: currentSchedule,
              onEdit: editSchedule,
            ),
          );
        } else if (value == "delete") {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Delete "${_capitalize(currentSchedule.title)}"',
              ),
              content:
              const Text("Are you sure you want to delete this schedule?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          deleteSchedule(currentSchedule.id);
                          Navigator.pop(ctx);
                        },
                        child: const Text("Delete"),
                      ),
                    ),

                    SizedBox(
                      width:100,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: "edit",
          child: Text("Edit"),
        ),
        const PopupMenuItem(
          value: "delete",
          child: Text("Delete"),
        ),
      ],
    );


  }
}
