
 import 'package:intl/intl.dart';

String getDate(String split){
   
DateTime dateTimeNow = DateTime.now();
print(dateTimeNow);
 //var now=DateFormat("MM/dd/yyyy").format(dateTimeNow);
//  print(now);
// List<String> splited=split.split(" ");
// List<String> time=splited[0].split("-");
// List<String> t=splited[1].split(":");
  //  DateTime dateTimeCreatedAt = DateTime(int.tryParse(time[0])
  //   ,int.tryParse(time[1]),int.tryParse(time[2]),int.tryParse(t[0])
  //   ,int.tryParse(t[1])); 
//   print(dateTimeCreatedAt);
try{
String dateFormate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(split));
   DateTime nowdate=DateTime.parse(dateFormate); 
   print("created   "+nowdate.toString());
   print("now    "+dateTimeNow.toString());
final int differenceInDays = dateTimeNow.difference(nowdate).inDays;
if(differenceInDays<0||differenceInDays==0){
   int differenceInHours = dateTimeNow.difference(nowdate).inHours;
   if(differenceInHours<0||differenceInHours==0){
      int differenceInMinut = dateTimeNow.difference(nowdate).inMinutes;
  return "قبل $differenceInMinut دقيقة";
 

   }else{
 return "قبل $differenceInHours ساعة";
   }
  
}else{
  return "قبل $differenceInDays يوم";
}
}catch(_){
  return "حدث خطأ";
}


  // 02/03/2020 09:10:01
  }