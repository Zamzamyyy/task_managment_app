import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';
import '../db/db_Helper.dart';
import '../models/task.dart';
import '../themes/notifications.dart';
import '../themes/theme_toggle.dart';
import '../themes/themes.dart';
import '../widgets/add_task_bar.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  String _formatDayOfWeek(DateTime date) {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 30),
          _showTasks(),
        ],
      ),
    );
  }

  Widget _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if (task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat("HH:mm").format(date);
              notifyHelper.scheduledNotification(
                int.parse(myTime.split(':')[0]),
                int.parse(myTime.split(':')[1]),
                task,
              );
              return _buildTaskAnimation(task, index);
            }

            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return _buildTaskAnimation(task, index);
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  Widget _buildTaskAnimation(Task task, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        child: FadeInAnimation(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showBottomSheet(context, task),
                child: TaskTile(task),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            if (task.isCompleted != 1)
              _bottomSheetButton(
                label: 'Task Completed',
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                color: primaryClr,
                context: context,
              ),
            const SizedBox(height: 8),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                setState(() {
                  _taskController.delete(task);
                  _taskController.getTasks();
                });
                Get.back();
              },
              color: pinkClr,
              context: context,
            ),
            const SizedBox(height: 25),
            _bottomSheetButton(
              label: 'Close',
              onTap: () => Get.back(),
              color: Colors.black,
              context: context,
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetButton({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: isClose ? Colors.red : color,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      child: EasyDateTimeLinePicker.itemBuilder(
        firstDate: DateTime(2025, 1, 1),
        lastDate: DateTime(2030, 3, 18),
        focusedDate: _selectedDate,
        itemExtent: 64.0,
        itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
          return InkResponse(
            onTap: onTap,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: isSelected ? primaryClr : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryClr : Colors.grey.shade400,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDayOfWeek(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? 'Activated Dark Theme'
                : 'Activated Light Theme',
          );
          ThemeServices().switchTheme(); // ✅ No incorrect call here now
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
        ),
      ),
      actions: const [
        Icon(CupertinoIcons.person, size: 20),
        SizedBox(width: 10),
      ],
    );
  }
}
