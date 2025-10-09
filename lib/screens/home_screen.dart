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

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_login_app/common/colors.dart';
import 'package:sqflite_login_app/common/common_text_style.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import '../common/common_widgets.dart';
import '../common/input.dart';
import '../modal/task_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  List<TaskModal> tasks = [];
  bool isLoading = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remainController = TextEditingController();
  final ExpansionTileController _remainExpansionTileController = ExpansionTileController();
  String updatedText = '';
  String descUpdatedText = '';
  String remainUpdatedText = '';
  String remainTime = '5 minutes early';
  bool isExpanded = false;
  List<String> remainingTime = ["5 minutes early","10 minutes early", "15 minutes early", "20 minutes early","25 minutes early" ,"30 minutes early" ,"35 minutes early" ,"40 minutes early" ,"45 minutes early", "50 minutes early" ,"55 minutes early", "60 minutes early"];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds:  2),(){_loadTasksForDate(selectedDate);});
  }

  // Load tasks for a specific date from the database
  // Future<void> _loadTasksForDate(DateTime date) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     // Format date as 'yMd' to match your addTaskList() usage
  //     String dateString = DateFormat.yMd().format(date);
  //     List<TaskModal> fetchedTasks = await DatabaseHelper.databaseHelper.getTasks(dateString);
  //     print("fetchedTasksfetchedTasks: $fetchedTasks");
  //
  //     setState(() {
  //       tasks = fetchedTasks;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error loading tasks: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     print("Error loading tasks: $e");
  //   }
  // }
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
          backgroundColor: Colors.white,
          appBar: _appBar(),
          floatingActionButton: Padding(
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
                Navigator.pushNamed(context, 'create_new_list').then((_) {
                  _loadTasksForDate(selectedDate);
                });
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 10.r, right: 10.r, top: 0.r, bottom: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _taskStatusCard(),
                SizedBox(height: 15.h,),
                _dateAndDayTitle(),
                Container(
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
                      _loadTasksForDate(date);
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: CommonColor.navyBlueColor))
                      : tasks.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/note.png",height: 70.h,width: 70.w,color: CommonColor.navyBlueColor,),
                        SizedBox(height: 16.h),
                        Text("No tasks for this date.", style: CommonTextStyle.textStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),),
                        SizedBox(height: 8.h),
                        Text("'Create new' to add one!", style: CommonTextStyle.textStyle(fontSize: 14.sp,fontWeight: FontWeight.w700,color: Colors.grey
                        ),),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      TaskModal task = tasks[index];
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: _buildTaskCard(task, index)
                              )
                          )
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- individual task card with details ----------------------
  Widget _buildTaskCard(TaskModal task, int index,) {
    bool isCompleted = task.isCompleted == 1;
    Color? taskColor = task.color;

    return GestureDetector(
      onTap: (){
        _showModalBottomSheet(context, task, index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.r),
        height: 161,
        decoration: BoxDecoration(
          color:taskColor,
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,),],
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        child: Row(
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                color: taskColor,
              ),
              child:  Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                task.title ?? updatedText, style: CommonTextStyle.textStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.white,),
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
                                    style: CommonTextStyle.textStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white,),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        )],
                    ),
                    if (task.startTime?.isNotEmpty == true || task.endTime?.isNotEmpty == true)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 15.5.h, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(
                              "${task.startTime ?? ''} - ${task.endTime ?? ''}",
                              style: CommonTextStyle.textStyle(fontSize: 13.5.sp, color: Colors.white,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    if (task.remind != null && task.remind!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Row(
                          children: [
                            Icon(Icons.notifications, size: 17.h, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(
                              "Remind: ${task.remind}",
                              style: CommonTextStyle.textStyle(fontSize: 13.sp, color: Colors.white,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    if (task.repeat?.isNotEmpty == true)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Row(
                          children: [
                            Icon(Icons.repeat, size: 16.h, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(
                              "Repeat: ${task.repeat}",
                              style: CommonTextStyle.textStyle(fontSize: 13.sp, color: Colors.white,fontWeight: FontWeight.w600),
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
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.w
                    ,),
                  RotatedBox(
                      quarterTurns: 3,
                    child:  Text(task.isCompleted == 1 ? "COMPLETED" : "TODO",style: CommonTextStyle.textStyle(color: Colors.white,fontWeight: FontWeight.w600),) ),
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
              DatabaseHelper.databaseHelper.logoutUser ();
              Navigator.pushNamedAndRemoveUntil(context, 'login_screen', (route) => false);
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
  
  //---------------------------show task status card-------------------------------
  _showModalBottomSheet(BuildContext context, TaskModal task,int index) async{
    String dateString = DateFormat.yMd().format(selectedDate);
      return showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.only(top: 6.r),
          height: task.isCompleted == 1 ? MediaQuery.of(context).size.height * 0.24: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 4.h,
                width: 120.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.r)),color: Colors.grey.shade400),
              ),
              SizedBox(height: 30.h,),
              task.isCompleted == 1
              ? Container() :
              _bottomSheetButtons(
                onTap: () async{
                  await DatabaseHelper.databaseHelper.completedTaskStatus(task.id ?? 0);
                  final taskIndex = tasks.indexWhere((element) => element.id == task.id);
                  if(taskIndex != -1){
                    setState(() {
                      tasks[taskIndex].isCompleted = 1;
                    });
                  }
                  await DatabaseHelper.databaseHelper.getTasks(dateString);
                  Navigator.pop(context);
                },
                label: "Task Completed",
                color: CommonColor.navyBlueColor,
                border: Border.all(style: BorderStyle.none),
                textColor: Colors.white,
              ),
              SizedBox(height: 0.h,),
              _bottomSheetButtons(onTap: (){
                DatabaseHelper.databaseHelper.deleteTask(task.id ?? 0);
                print("tasppppp=====");
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

  // Helper to get "Today", "Tomorrow", etc.
  String _getDayTitle(DateTime date) {
    // if (date.isToday()) return "Today"; // Add extension if needed: date.isToday() => date.difference(DateTime.now()).inDays == 0
    if (date.difference(DateTime.now()).inDays == 1) return "Tomorrow";
    return DateFormat.EEEE().format(date); // e.g., "Monday"
  }
}