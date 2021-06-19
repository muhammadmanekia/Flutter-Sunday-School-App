// class User {
//   int id;
//   String name;
// }
// class Student {
//   int id;
//   String giveName;
//   String lastName;

//   load(Map<String, dynamic> studentMap) {
//     id = studentMap["id"];
//     givenName = studentMap["givenName"];
//     lastName = studentMap["lastName"];
//   }

//   List<Student> buildList(String studentsJson) {

//     List<Map<String, dynamic>> studentMapList = new List();

//     for(var studentMap in studentMapList) {
//       Student student = new Student();
//       student.load(studentMap);
//       studentMapList.add(student);
//     }

//     return studentMapList;

//   }
// }
// class Point {
//   int id;
//   int studentId;
//   String sessionDate;
//   String sessionType;
//   String sessionDetails;
//   int value;
// }