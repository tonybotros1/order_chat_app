import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class OrderDetailsCardWidgets extends StatelessWidget {
  OrderDetailsCardWidgets(
      {super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    var screenWidth = Get.width;

    return Column(
      children: [
        Container(
          width: screenWidth,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 0, 5),
                child: Text(
                  '${title}',
                  style: TextStyle(
                      color: Colors.grey,
                      // fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: Text(
                  '$value',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}



// Container(
//       height: 100,
//       child: Card(
//         color: Color(0xff576574),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         elevation: 7,
//         margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//         child: Container(
//           padding: EdgeInsets.all(10),
//           width: screenWidth,
//           decoration: BoxDecoration(),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 '${title}',
//                 style: TextStyle(
//                     color: Color(0xffc8d6e5),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 '$value',
//                 style: TextStyle(
//                     color: Color(0xffc8d6e5),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );