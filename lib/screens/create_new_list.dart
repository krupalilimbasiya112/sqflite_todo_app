import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_login_app/common/colors.dart';
import 'package:sqflite_login_app/common/common_widgets.dart';
import 'package:sqflite_login_app/common/input.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import 'package:sqflite_login_app/modal/task_modal.dart';
import 'package:sqflite_login_app/modal/todo_service.dart';
import '../common/common_text_style.dart';

class CreateNewList extends StatefulWidget {
  const CreateNewList({super.key});

  @override
  State<CreateNewList> createState() => _CreateNewListState();
}

class _CreateNewListState extends State<CreateNewList> {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController remainController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  final ExpansionTileController _remainExpansionTileController = ExpansionTileController();
  final ExpansionTileController _repeatExpansionTileController = ExpansionTileController();
  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String endTime = '7:00 PM';
  String remainTime = '5 minutes early';
  bool isExpanded = false;
  List<String> remainingTime = ["5 minutes early","10 minutes early", "15 minutes early", "20 minutes early","25 minutes early" ,"30 minutes early" ,"35 minutes early" ,"40 minutes early" ,"45 minutes early", "50 minutes early" ,"55 minutes early", "60 minutes early"];
  String repeatTask = "None";
  List<String> repeatTaskList = ["None", "Daily", "Weekly", "Monthly"];
  bool isTaskExpanded = false;
  List<TaskModal> tasks = [];
  // Color selectedColor = Colors.white;

  //  addTaskList() async {
  //   TaskModal taskModal = TaskModal(
  //     title: titleController.text,
  //     description: descriptionController.text,
  //     isCompleted: 0,
  //     date: DateFormat.yMd().format(selectedDate),
  //     startTime: startTime,
  //     endTime: endTime,
  //     // color: selectedColor,
  //     remind: remainTime,
  //     repeat: repeatTask,
  //   );
  //   print("taskModal: ${taskModal.endTime}");
  //   print("taskModal: ${taskModal.startTime}");
  //   print("taskModal: ${taskModal.title}");
  //   print("taskModal: ${taskModal.description}");
  //   // print("taskModal: ${taskModal.color}");
  //   print("taskModal: ${taskModal.remind}");
  //   print("taskModal: ${taskModal.repeat}");
  //
  //   int? result = await DatabaseHelper.databaseHelper.addTask(taskModal);
  //
  //   print("resultttttt: $result");
  //
  //   if(result != null){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added successfully...",style: CommonTextStyle.whiteTitleTextStyle(fontWeight: FontWeight.w600,fontSize: 14.sp),),backgroundColor: CommonColor.navyBlueColor,));
  //   }else{
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added failed...",style: CommonTextStyle.whiteTitleTextStyle(fontWeight: FontWeight.w600,fontSize: 14.sp),),backgroundColor: Colors.red,));
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    loadTodo();
    super.initState();
  }
  loadTodo()async{
    tasks = await TodoService.todoService.getAllTask();
    setState(() {

    });
  }
  Color selectedColor = Colors.white;

  Future<dynamic> addTaskList() async {

    TaskModal taskModal = TaskModal(
      title: titleController.text,
      description: descriptionController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime ?? '',
      endTime: endTime ?? '',
      // color: selectedColor,
      remind: remainTime,
      repeat: repeatTask ?? '',
      isTaskCompleted: false
    );

    print("taskModal map (with optional id): ${taskModal.toMap()}");

    // int? result = await DatabaseHelper.databaseHelper.addTask(taskModal);
     TodoService.todoService.addTask(taskModal);
    // print("Final result (row ID): $result");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added successfully", style: CommonTextStyle.textStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: Colors.white),), backgroundColor: CommonColor.navyBlueColor,),);
    // loadTodo();
    Navigator.pushNamed(context, 'home_screen',arguments: taskModal);
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    // if (result != null ) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added successfully! (ID: $result)", style: CommonTextStyle.textStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: Colors.white),), backgroundColor: CommonColor.navyBlueColor,),);
    //   Navigator.pushNamed(context, 'home_screen',arguments: taskModal);
    //   titleController.clear();
    //   descriptionController.clear();
    //   dateController.clear();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add task. Please try again.", style: CommonTextStyle.textStyle(fontWeight: FontWeight.w600, fontSize: 14.sp,color: Colors.white),), backgroundColor: Colors.red,),);
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _createNewTaskInputFiled()
    );
  }
  //---------------------------appbar-----------------------
  _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      leading: CommonWidgets.commonIcons(icon: CupertinoIcons.back,color: CommonColor.navyBlueColor,size: 23.h,onTap: (){Navigator.pop(context);}),
      title: Text("Create new task", style: CommonTextStyle.textStyle(fontSize: 20.sp,fontWeight: FontWeight.w700,color: CommonColor.navyBlueColor),),
      centerTitle: true,
    );
  }

  //--------------------------getDateTime-------------------
  _getDateTime() async{
   final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2121)
    );
    setState(() {
      selectedDate = dateTime!;
    });
  }

  //------------------get Start and end date----------------
  _getStartAndEndDate({required bool isStartTime }) async{
    var pickTime = await _showTimePicker();
    String formatTime = pickTime.format(context);

    if(pickTime == null){
      print("Wrong Selected Timing");
    }else if(isStartTime == true){
     setState(() {
       startTime = formatTime;
       print("startTime: $startTime");
     });
    }else if(isStartTime == false){
      setState(() {
        endTime = formatTime;
        print("endTime: $endTime");
      });
    }
  }

  //------------------------get time------------------------
  _showTimePicker(){
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: int.parse(startTime.split(":")[0]),
            minute: int.parse(startTime.split(":")[1].split(" ")[0]),
        )
    );
  }

  //--------------show all task input filed-----------------
  _createNewTaskInputFiled(){
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          children: [
            CommonInputField(
                controller: titleController,
                title: "Title",
                hintText: "Enter title",
              validator: (val){
                  if(val!.isEmpty){
                    return "please enter the first title...";
                  }
                  return null;
              },
            ),
            SizedBox(height: 12.h,),
            CommonInputField(
                controller: descriptionController,
                title: "Description",
                hintText: "Enter description",
              validator: (val){
                  if(val!.isEmpty){
                    return "please enter the first description...";
                  }
                  return null;
              },
            ),
            SizedBox(height: 12.h,),
            CommonInputField(
              title: "Date",
              hintText: DateFormat.yMd().format(selectedDate),
              suffixIcon: CommonWidgets.commonIconButton(onPressed: (){_getDateTime();},icon: Icons.calendar_today,color: CommonColor.navyBlueColor),
            ),
            SizedBox(height: 12.h,),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child:  CommonInputField(
                    title: "Start Date",
                    hintText: startTime,
                    suffixIcon: CommonWidgets.commonIconButton(onPressed: (){_getStartAndEndDate(isStartTime: true);},icon: Icons.watch_later_outlined,color: CommonColor.navyBlueColor,size: 23.h),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: CommonInputField(
                    title: "End Date",
                    hintText: endTime,
                    suffixIcon: CommonWidgets.commonIconButton(onPressed: (){_getStartAndEndDate(isStartTime: false);},icon: Icons.watch_later_outlined,color: CommonColor.navyBlueColor,size: 23.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h,),
            CommonInputField(
              controller: remainController,
              title: "Remind",
              hintText: "Select remind timing",
              suffixIcon: ExpansionTile(
                controller: _remainExpansionTileController,
                collapsedIconColor: CommonColor.navyBlueColor,
                iconColor: CommonColor.navyBlueColor,
                collapsedShape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
                onExpansionChanged: (bool value) {
                  setState(() {
                    isExpanded = value;
                  });
                },
                minTileHeight: 2.h,
                tilePadding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 15.r),
                title: Text(remainTime, style: CommonTextStyle.textStyle(fontSize: 15.sp, fontWeight: FontWeight.w400,color: CommonColor.navyBlueColor),),
                children:[
                  Column(
                    children: remainingTime.map((time) {
                      return Padding(
                        padding: EdgeInsets.only(left: 15.r, bottom: 10.r),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              remainTime = time;
                              _remainExpansionTileController.collapse();
                              isExpanded = false;
                            });
                          },
                          child: Row(
                            children: [
                              Text(time, style: CommonTextStyle.textStyle(fontSize: 15.sp, fontWeight: FontWeight.w600,color: CommonColor.navyBlueColor),),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            CommonInputField(
              controller: repeatController,
              title: "Repeat",
              hintText: "Select task routines",
              suffixIcon: ExpansionTile(
                controller: _repeatExpansionTileController,
                title: Text(repeatTask,style: CommonTextStyle.textStyle(fontSize: 15.sp, fontWeight: FontWeight.w600,color: CommonColor.navyBlueColor),),
                minTileHeight: 2.h,
                tilePadding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 15.r),
                collapsedIconColor: CommonColor.navyBlueColor,
                iconColor: CommonColor.navyBlueColor,
                collapsedShape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
                onExpansionChanged: (bool value){
                  setState(() {
                    isTaskExpanded = value;
                  });
                },
                children: [
                  Column(
                    children: repeatTaskList.map((item){
                      return Padding(
                        padding: EdgeInsets.only(left: 15.r, bottom: 10.r),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              repeatTask = item;
                              _repeatExpansionTileController.collapse();
                              isTaskExpanded = false;
                            });
                          },
                          child: Row(
                            children: [
                              Text(item, style: CommonTextStyle.textStyle(fontSize: 15.sp, fontWeight: FontWeight.w600,color: CommonColor.navyBlueColor))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            Padding(
              padding: EdgeInsets.only(left: 14.r,right: 14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Color",style: CommonTextStyle.textStyle(fontWeight: FontWeight.w700,fontSize: 16.sp,color: CommonColor.navyBlueColor),),
                  SizedBox(height: 6.h,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Wrap(
                          children: Colors.primaries.map((color){
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 7.r),
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.all(Radius.circular(5.r))
                                ),
                                child: selectedColor == color ? CommonWidgets.commonIcons(icon: Icons.check,color: Colors.white) : Container(),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 28.h,),
            Padding(
              padding: EdgeInsets.only(left: 14.r,right: 14.r),
              child: CommonWidgets.commonButtons(
                name: "Add",
                widget: Container(),
                boxColor: Color(0xff00224B),
                height: 42.h,
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                onTap: (){
                  if(key.currentState!.validate()){
                    key.currentState!.save();
                    addTaskList();
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
