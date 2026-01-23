import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/getInstalledApps.dart';
import 'package:scrollkill/models/goalModal.dart';
import 'package:scrollkill/states/settingState.dart';

class NewGoal extends StatefulWidget {
  const NewGoal({super.key, this.onSave, this.onEdit, this.editContent});

  final Future<void> Function(GoalModal schedule)? onSave;
  final Future<void> Function(GoalModal schedule)? onEdit;
  final GoalModal? editContent;

  @override
  State<NewGoal> createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  late DateTime startTime;
  late DateTime endTime;

  bool blockScreen = true;
  bool hardFocus = false;

  final List<String> appsNotAllowed = [];



  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    startTime = now;
    endTime = DateTime(now.year, (now.month+1)%12, now.day, );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingProvider>().loadApps();
    });

    final editContent = widget.editContent;
    if (editContent != null) {
      _titleController = TextEditingController(text: editContent.title);
      _descriptionController = TextEditingController(
        text: editContent.description,
      );
      startTime = editContent.startDate;
      endTime = editContent.endDate;
      appsNotAllowed.addAll(
        editContent.appsNotAllowed.isNotEmpty
            ? editContent.appsNotAllowed
            : [],
      );
      blockScreen = editContent.blockScreen;
      hardFocus = editContent.hardFocus;
    }

  }


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<DateTime> _pickTime(DateTime current) async {
    return await showDatePicker(context: context, firstDate: current,lastDate: startTime) ??
        current;
  }



  void _edit(GoalModal content) async {
    await widget.onEdit!(content);

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _save() async {
    if (_titleController.text.trim().isEmpty) return;

    if (widget.onSave != null) {
      await widget.onSave!(
        GoalModal(
          id: DateTime.now(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: startTime,
          endDate: endTime,
          hardFocus: hardFocus,
          blockScreen: blockScreen,
          appsNotAllowed: appsNotAllowed,
        ),
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editContent = widget.editContent;


    final apps = context.watch<SettingProvider>().apps;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            const SizedBox(height: 18),

            sectionTitle("Schedule Info"),
            sectionCard(
              Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Description (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle("Time Schedule"),
            sectionCard(
              Row(
                children: [
                  Expanded(
                    child: _timePicker(
                      label: "Start",
                      time: startTime,
                      onTap: () async {
                        startTime = await _pickTime(startTime);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _timePicker(
                      label: "End",
                      time: endTime,
                      onTap: () async {
                        endTime = await _pickTime(endTime);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),



            sectionTitle("Behavior"),
            sectionCard(
              Column(
                children: [
                  SwitchListTile(
                    value: blockScreen,
                    onChanged: (v) => setState(() => blockScreen = v),
                    title: const Text("Block Screen"),
                    subtitle: const Text("Prevent app usage during this time"),
                  ),
                  SwitchListTile(
                    value: hardFocus,
                    onChanged: (v) => setState(() => hardFocus = v),
                    title: const Text("Hard Focus"),
                    subtitle: const Text("Disable overrides and exits"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (!blockScreen) _appsNotAllowed(apps, appsNotAllowed),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: editContent != null
                  ? () {
                _edit(
                  GoalModal(
                      id: editContent.id,
                      title: _titleController.text,
                      startDate: startTime,
                      endDate: endTime,
                      hardFocus: hardFocus,
                      blockScreen: blockScreen,
                      description: _descriptionController.text
                  ),
                );
              }
                  : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text("Save Schedule"),
            ),
          ],
        ),
      ),
    );
  }
}



Widget sectionTitle(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  ),
);

Widget sectionCard(Widget child) => Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.grey.shade900,
    borderRadius: BorderRadius.circular(14),
  ),
  child: child,
);

Widget _timePicker({
  required String label,
  required DateTime time,
  required VoidCallback onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "${time.year}-${time.month.toString().padLeft(2, '0')} ${time.day.toString().padLeft(2,"0")}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _appsNotAllowed(List<AppInfo> appList, List<String> appsNotAllowed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("Apps Not Allowed"),
      const SizedBox(height: 12),
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: sectionCard(
          GetInstalledApps(appList: appList, appsNotAllowed: appsNotAllowed),
        ),
      ),
    ],
  );
}
