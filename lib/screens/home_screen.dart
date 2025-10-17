// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:sqflite_login_app/common/colors.dart';
// import 'package:sqflite_login_app/common/common_text_style.dart';
// import 'package:sqflite_login_app/database/database_helper.dart';
// import '../common/common_widgets.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime dateTime = DateTime.now();
//     // Map<String,dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: _appBar(),
//           floatingActionButton: Padding(
//             padding: EdgeInsets.only(left: 35.r,),
//             child: CommonWidgets.commonButtons(name: "Create new", widget: Padding(
//               padding: EdgeInsets.only(right: 3.r),
//               child: Icon(Icons.add,color: Colors.white,size: 22.h,),
//             ),boxColor: CommonColor.navyBlueColor,height: 40.h,width: MediaQuery.of(context).size.width/2.9,color: Colors.white,fontWeight: FontWeight.w700,onTap: (){Navigator.pushNamed(context, 'create_new_list');}),
//           ),
//           body: Padding(
//             padding: EdgeInsets.only(left: 10.r,right: 10.r,top: 15.r,bottom: 15.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _dateAndDayTitle(),
//                 Container(
//                   margin: EdgeInsets.only(top: 10.r),
//                   child: DatePicker(
//                     DateTime.now(),
//                     initialSelectedDate: DateTime.now(),
//                     height: 100.h,
//                     width: 80.w,
//                     selectionColor: CommonColor.navyBlueColor,
//                     selectedTextColor: Colors.white,
//                     dateTextStyle: CommonTextStyle.navyTitleTextStyle(fontSize: 22.sp,fontWeight: FontWeight.w500),
//                     dayTextStyle: CommonTextStyle.navyTitleTextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600),
//                     monthTextStyle: CommonTextStyle.navyTitleTextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600),
//                     onDateChange: (date){
//                       dateTime = date;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ),
//       ),
//     );
//   }
//   //---------------------AppBar------------------------
//   _appBar(){
//   return AppBar(
//       backgroundColor: Colors.white,
//       actions: [
//         Padding(
//             padding: EdgeInsets.only(right: 10.r),
//             child: InkWell(
//                 onTap: (){
//                   setState(() {
//                     DatabaseHelper.databaseHelper.logoutUser();
//                   });
//                   Navigator.pushNamed(context, 'login_screen');
//                 },
//                 child: Image.asset("assets/images/profile.png",height: 38.h,width: 38.w,color: Color(0xff00224B),))
//         ),
//       ],
//       title: Text("Todo List", style: CommonTextStyle.navyTitleTextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600),),
//     // centerTitle: true,
//     );
//   }
//   //----------------------------date and days format---------------------------------
//   _dateAndDayTitle(){
//      return Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//          Text(DateFormat.yMMMMd().format(DateTime.now()),style: CommonTextStyle.navyTitleTextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
//          SizedBox(height: 5.h,),
//          Text("Today",style: CommonTextStyle.navyTitleTextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600),),
//        ],
//      );
//   }
// }

import 'package:animate_do/animate_do.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite_login_app/common/colors.dart';
import 'package:sqflite_login_app/common/common_text_style.dart';
import 'package:sqflite_login_app/common/input.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import 'package:sqflite_login_app/firebase_helper/fcm_notification_helper.dart';
import 'package:sqflite_login_app/firebase_helper/local_notification_helper.dart';
import 'package:sqflite_login_app/modal/todo_service.dart';
import 'package:sqflite_login_app/screens/create_new_list.dart';
import '../common/common_widgets.dart';
import '../modal/task_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<SliderDrawerState> sliderDrawerKey = GlobalKey<SliderDrawerState>();
  DateTime selectedDate = DateTime.now();
  List<TaskModal> tasks = [];
  bool isLoading = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remainController = TextEditingController();
  String updatedText = '';
  String descUpdatedText = '';
  String remainUpdatedText = '';
  String remainTime = '5 minutes early';
  bool isExpanded = false;
  List<String> remainingTime = ["5 minutes early","10 minutes early", "15 minutes early", "20 minutes early","25 minutes early" ,"30 minutes early" ,"35 minutes early" ,"40 minutes early" ,"45 minutes early", "50 minutes early" ,"55 minutes early", "60 minutes early"];

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds:  2),(){_loadTasksForDate(selectedDate);});
    Future.delayed(Duration(seconds:  2),(){loadTodo();});
    // TodoService.todoService.getAllTask();
    FcmNotificationHelper.fcmNotificationHelper.initFcm();


    LocalNotificationHelper.localNotificationHelper.initLocalNotifications();
  }

  loadTodo()async{
    setState(() {
      isLoading = true;
    });

    try{
      tasks = await TodoService.todoService.getAllTask();
      setState(() {
        isLoading = false;
      });
    }catch (e){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading tasks: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("Error loading tasks: $e");
    }
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    try {
      String dateString = DateFormat.yMd().format(date);
      List<TaskModal>? fetchedTasks = await DatabaseHelper.databaseHelper.getTasks(dateString);

      setState(() {
        tasks = fetchedTasks!;
        isLoading = false;
    });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading tasks: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("Error loading tasks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          // appBar: _appBar(),
          body: SliderDrawer(
            key: sliderDrawerKey,
            appBar: SliderAppBar(
              config: SliderAppBarConfig(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Todo List", style: CommonTextStyle.textStyle(fontSize: 23.sp, fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),),
                  ],
                ),
              ),
            ),
            sliderOpenSize: 185,
            slider: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.r),
                  child: InkWell(
                    onTap: () {
                      // DatabaseHelper.databaseHelper.logoutUser ();
                      // Navigator.pushNamedAndRemoveUntil(context, 'login_screen', (route) => false);
                      LocalNotificationHelper.localNotificationHelper.showSimpleNotification(id: "Todo App", title: "This is Todo App");
                    },
                    child: Image.asset("assets/images/profile.png", height: 80.h, width: 80.w, color: const Color(0xff00224B),),
                  ),
                ),
                SizedBox(height: 10.h,),
                Text("Krupali", style: CommonTextStyle.textStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),),
              ],
            ),
              child:  Padding(
              padding: EdgeInsets.only(left: 10.r, right: 10.r, top: 0.r, bottom: 15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _taskStatusCard(),
                  SizedBox(height: 15.h,),
                  _dateAndDayTitle(),
                  _selectedDateAndDay(),
                  SizedBox(height: 10.h),
                  Expanded(
                    child:
                    isLoading ? Center(child: CircularProgressIndicator(color: CommonColor.navyBlueColor)) : tasks.isEmpty
                        ? Center(child: _emptyTaskTitleAndImage())
                        : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        TaskModal task = tasks[index];
                        print("taskkk: ${task.toMap()}");
                        // DateTime date = DateFormat.jm().parse(task.startTime.toString());
                        DateTime date = DateFormat.Hm().parse(task.startTime.toString());
                        final myTime = DateFormat("HH:mm").format(date);
                        print("Mytime: $myTime");
                         // LocalNotificationHelper.localNotificationHelper.scheduleNotification(
                         //    int.parse(myTime.toString().split(":")[0]),
                         //    int.parse(myTime.toString().split(":")[1]),
                         //    task);  n
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: _buildTaskCard(task, index)))
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
          floatingActionButton: _createNewTaskFloatingActionButton(),

        ),
      ),
    );
  }

  // -------------------- individual task card with details ----------------------
  Widget _buildTaskCard(TaskModal task, int index,) {
    bool isCompleted = task.isCompleted == 1;
    // Color? taskColor = task.color;
    // print("-----taskColor-----: ${taskColor}");

    return GestureDetector(
      onTap: (){
        _showModalBottomSheet(context, task, index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.r),
        height: 161,
        decoration: BoxDecoration(
          // color: taskColor,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,),],
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        child: Row(
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                // color: taskColor,
                color: Colors.white38
              ),
              child:  Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        task.title ?? updatedText, style: CommonTextStyle.textStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.black,),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (task.description?.isNotEmpty == true)
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Flexible(
                          child: Text(
                            task.description!,
                            style: CommonTextStyle.textStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black,),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    if (task.startTime?.isNotEmpty == true || task.endTime?.isNotEmpty == true)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 15.5.h, color: Colors.black),
                            SizedBox(width: 4.w),
                            Text(
                              "${task.startTime ?? ''} - ${task.endTime ?? ''}",
                              style: CommonTextStyle.textStyle(fontSize: 13.5.sp, color: Colors.black,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    if (task.remind != null && task.remind!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Row(
                          children: [
                            Icon(Icons.notifications, size: 17.h, color: Colors.black),
                            SizedBox(width: 4.w),
                            Text(
                              "Remind: ${task.remind}",
                              style: CommonTextStyle.textStyle(fontSize: 13.sp, color: Colors.black,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    if (task.repeat?.isNotEmpty == true)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Row(
                          children: [
                            Icon(Icons.repeat, size: 16.h, color: Colors.black),
                            SizedBox(width: 4.w),
                            Text(
                              "Repeat: ${task.repeat}",
                              style: CommonTextStyle.textStyle(fontSize: 13.sp, color: Colors.black,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),

                  ],
                ),
              ),
            ),
            SizedBox(
              width: 40,
              // color: Colors.black,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 0.9,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10.w),
                  RotatedBox(
                      quarterTurns: 3,
                    child:  Text(task.isCompleted == 1 ? "COMPLETED" : "TODO",style: CommonTextStyle.textStyle(color: Colors.black,fontWeight: FontWeight.w600),) ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

  //---------------------AppBar------------------------
  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: Container(),
      leadingWidth: 0,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15.r),
          child: InkWell(
            onTap: () {
              // DatabaseHelper.databaseHelper.logoutUser ();
              // Navigator.pushNamedAndRemoveUntil(context, 'login_screen', (route) => false);
              LocalNotificationHelper.localNotificationHelper.showSimpleNotification(id: "Todo App", title: "This is Todo App");

            },
            child: Image.asset(
              "assets/images/profile.png",
              height: 38.h,
              width: 38.w,
              color: const Color(0xff00224B),
            ),
          ),
        ),
      ],
      title: Text(
        "Todo List",
        style: CommonTextStyle.textStyle(fontSize: 23.sp, fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),
      ),
      // centerTitle: true,
    );
  }

  //----------------------------date and days format-------------------------------
  _dateAndDayTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMMd().format(selectedDate), 
          style: CommonTextStyle.textStyle(fontSize: 18.sp, fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),
        ),
        SizedBox(height: 5.h),
        Text(
          _getDayTitle(selectedDate),
          style: CommonTextStyle.textStyle(fontSize: 22.sp, fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),
        ),
      ],
    );
  }

  //----------------------------selectedDate and days------------------------------
  _selectedDateAndDay(){
    return Container(
      margin: EdgeInsets.only(top: 10.r),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: selectedDate,
        height: 100.h,
        width: 80.w,
        selectionColor: CommonColor.navyBlueColor,
        selectedTextColor: Colors.white,
        dateTextStyle: CommonTextStyle.textStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
        dayTextStyle: CommonTextStyle.textStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
        monthTextStyle: CommonTextStyle.textStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
          // _loadTasksForDate(date);
          loadTodo();
        },
      ),
    );
  }

  //----------------------------empty task title and image-------------------------
  _emptyTaskTitleAndImage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        // Image.asset("assets/images/note.png",height: 70.h,width: 70.w,color: CommonColor.navyBlueColor,),
        FadeIn(
          child: Lottie.asset(
            'assets/images/Notes Document.json',
            height: 160,
            width: 150,
            animate: isLoading ? false: true,
            fit: BoxFit.cover,
          ),
        ),
        // SizedBox(height: 16.h),
        Text("No tasks for this date.", style: CommonTextStyle.textStyle(fontSize: 19.sp,fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),),
        SizedBox(height: 8.h),
        Text("'Create new' to add one!", style: CommonTextStyle.textStyle(fontSize: 15.sp,fontWeight: FontWeight.w700,color: Colors.grey
        ),),
      ],
    );
  }
  
  //---------------------------show task status card-------------------------------
  _showModalBottomSheet(BuildContext context, TaskModal task,int index) async{
    // Color? taskColor = task.color;
    // print("taskColor: ${taskColor}");
    String dateString = DateFormat.yMd().format(selectedDate);
      return showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.only(top: 6.r),
          height: task.isCompleted == 1 ? MediaQuery.of(context).size.height * 0.32: MediaQuery.of(context).size.height * 0.40,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 4.h,
                width: 120.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.r)),color: Colors.grey.shade400),
              ),
              SizedBox(height: 25.h,),
              task.isCompleted == 1
              ? Container() :
              _bottomSheetButtons(
                onTap: () async{
                  // await DatabaseHelper.databaseHelper.completedTaskStatus(task.id ?? 0);
                  await TodoService.todoService.updateTakStatus(task, index);
                  final taskIndex = tasks.indexWhere((element) => element.id == task.id);
                  if(taskIndex != -1){
                    setState(() {
                      tasks[taskIndex].isCompleted = 1;
                    });
                  }
                  // await DatabaseHelper.databaseHelper.getTasks(dateString);
                  Navigator.pop(context);
                },
                label: "Task Completed",
                color: CommonColor.navyBlueColor,
                border: Border.all(style: BorderStyle.none),
                textColor: Colors.white,
              ),
              _bottomSheetButtons(
                onTap: () async{
                  Navigator.pop(context);
                  _showEditBottomSheet(task,index);
                },
                label: "Edit Task",
                color: CommonColor.navyBlueColor,
                border: Border.all(style: BorderStyle.none),
                textColor: Colors.white,
              ),
              SizedBox(height: 0.h,),
              _bottomSheetButtons(onTap: (){
                // DatabaseHelper.databaseHelper.deleteTask(task.id ?? 0);
                TodoService.todoService.deleteTask(index);
                setState(() {
                  tasks.removeAt(index);
                });
                Navigator.pop(context);
                },label: "Delete",color: Colors.red.shade500, border: Border.all(style: BorderStyle.none),textColor: Colors.white),
              SizedBox(height: 15.h,),
              _bottomSheetButtons(onTap: (){Navigator.pop(context);},label: "Cancel",color: Colors.transparent,border: Border.all(color: CommonColor.navyBlueColor),textColor: CommonColor.navyBlueColor),
            ],
          ),
        );
      });
  }

  _showEditBottomSheet(TaskModal task,int index)async{
    titleController = TextEditingController(text: task.title ?? '');
    descriptionController = TextEditingController(text: task.description ?? '');
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  height: 4.h,
                  width: 120.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.r)),color: Colors.grey.shade400),
                ),
                SizedBox(height: 18.h,),
                Text("Edit Task",style: CommonTextStyle.textStyle(fontWeight: FontWeight.w700,fontSize: 20.sp),),
                CommonInputField(
                    controller: titleController,
                    hintText: "Enter title",
                    title: "Title",
                ),
                SizedBox(height: 15.h,),
                CommonInputField(
                  controller: descriptionController,
                  hintText: "Enter description",
                  title: "description",
                ),
                SizedBox(height: 35.h,),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: CommonWidgets.commonButtons(
                    name: "Edit task",
                    widget: Container(),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    boxColor: CommonColor.navyBlueColor,
                    width: MediaQuery.of(context).size.width,
                    height: 45.h,
                    onTap: () async{
                     setState(() {
                       task.title = titleController.text;
                       task.description = descriptionController.text;
                     });
                      print("task.title: ${task.title}");
                      print("task.description: ${task.description}");
                      await TodoService.todoService.updateTakStatus(task,index);
                      Navigator.pop(context, task);
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  //----------------------------bottomSheet buttons-------------------------------
  _bottomSheetButtons({
    required String label,
    required GestureTapCallback onTap,
    required Color color,
    required Color textColor,
    bool isCloseSheet = false,
    required Border border,
  }) {

    return Padding(
      padding:  EdgeInsets.only(left: 15.r,right: 15.r,top: 15.r),
      child: CommonWidgets.commonButtons(name: label, widget: Container(),boxColor: isCloseSheet ? Colors.red.shade500 : color,color: textColor,fontWeight: FontWeight.w700,fontSize: 16.sp,width: MediaQuery.of(context).size.width,height: 45.h,onTap: onTap,border: border),
    );
  }

  //----------------------------get date------------------------------------------
  String _getDayTitle(DateTime date) {
    // if (date.difference(DateTime.now()).inDays == 1) return "Today";
    // if (date.difference(DateTime.now()).inDays == 1) return "Tomorrow";
    return DateFormat.EEEE().format(date);
  }

  //----------------------------create new task floatingAction button--------------
  _createNewTaskFloatingActionButton(){
    return Padding(
      padding: EdgeInsets.only(left: 35.r),
      child: CommonWidgets.commonButtons(
        name: "Create new",
        widget: Padding(
          padding: EdgeInsets.only(right: 3.r),
          child: Icon(Icons.add, color: Colors.white, size: 22.h),
        ),
        boxColor: CommonColor.navyBlueColor,
        height: 40.h,
        width: MediaQuery.of(context).size.width / 2.9,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        onTap: () {
          // Navigator.pushNamed(context, 'create_new_list').then((_) {
          //   _loadTasksForDate(selectedDate);
          // });
          Navigator.push(context, CupertinoPageRoute(builder: (context){ return CreateNewList();})).then((_){
            // _loadTasksForDate(selectedDate);
            loadTodo();
          });
        },
      ),
    );
  }
}