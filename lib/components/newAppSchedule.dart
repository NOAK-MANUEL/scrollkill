import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/getInstalledApps.dart';
import 'package:scrollkill/models/appSchedule.dart';
import 'package:scrollkill/states/settingState.dart';
import 'package:scrollkill/models/periodList.dart';

class NewAppSchedule extends StatefulWidget {
  const NewAppSchedule({super.key, this.onSave, this.onEdit, this.editContent});

  final Future<void> Function(AppSchedule schedule)? onSave;
  final Future<void> Function(AppSchedule schedule)? onEdit;
  final AppSchedule? editContent;

  @override
  State<NewAppSchedule> createState() => _NewAppScheduleState();
}

class _NewAppScheduleState extends State<NewAppSchedule> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  late TimeOfDay startTime;
  late TimeOfDay endTime;



  final List<int> selectedDays = [];
  String appAllowed = "";

  final List<PeriodListType> days = const [
    PeriodListType(index: 0, type: "S"),
    PeriodListType(index: 1, type: "M"),
    PeriodListType(index: 2, type: "T"),
    PeriodListType(index: 3, type: "W"),
    PeriodListType(index: 4, type: "T"),
    PeriodListType(index: 5, type: "F"),
    PeriodListType(index: 6, type: "S"),
  ];

  @override
  void initState() {
    super.initState();

    final now = TimeOfDay.now();
    startTime = now;
    endTime = TimeOfDay(hour: (now.hour + 1) % 24, minute: now.minute);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingProvider>().loadApps();
    });

    final editContent = widget.editContent;
    if (editContent != null) {
      _titleController = TextEditingController(text: editContent.title);
      _descriptionController = TextEditingController(
        text: editContent.description,
      );
      startTime = editContent.startDate!;
      endTime = editContent.endDate!;
      selectedDays.addAll(editContent.periods!);
      appAllowed = editContent.app;

    }

  }


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<TimeOfDay> _pickTime(TimeOfDay current) async {
    return await showTimePicker(context: context, initialTime: current) ??
        current;
  }

  void _toggleDay(int index) {
    setState(() {
      selectedDays.contains(index)
          ? selectedDays.remove(index)
          : selectedDays.insert(index,index);
    });
  }

  void _edit(AppSchedule content) async {
    await widget.onEdit!(content);

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _save() async {
    if (_titleController.text.trim().isEmpty) return;

    if (widget.onSave != null) {
      await widget.onSave!(
        AppSchedule(
          id: DateTime.now(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: startTime,
          endDate: endTime,
          periods: selectedDays,
          app: appAllowed

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
                      label: "Open At",
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
                      label: "Close At",
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

            sectionTitle("Repeat"),
            sectionCard(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: days.map((day) {
                    return _dayChip(
                      context,
                      label: day.type,
                      selected: selectedDays.contains(day.index),
                      onTap: () => _toggleDay(day.index),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle("Target App(this is the app you are targeting"),

            sectionCard(_appTarget(apps, appAllowed)),

            const SizedBox(height: 24),


            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: editContent != null
                  ? () {
                _edit(
                  AppSchedule(
                      id: editContent.id,
                      title: _titleController.text,
                      periods: selectedDays,
                      startDate: startTime,
                      endDate: endTime,
                      app: appAllowed,

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

Widget _dayChip(
    BuildContext context, {
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).primaryColor,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Text(label),
    ),
  );
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
  required TimeOfDay time,
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
              "${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _appTarget(List<AppInfo> appList, String appTarget) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("Apps Not Allowed"),
      const SizedBox(height: 12),
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: sectionCard(
          GetInstalledApps(appList: appList, app: appTarget),
        ),
      ),
    ],
  );
}
