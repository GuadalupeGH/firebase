import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    Key? key,
    required this.productDocument,
  }) : super(key: key);
  final DocumentSnapshot productDocument;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final _card = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: FadeInImage(
            placeholder: AssetImage('assets/activity_indicator.gif'),
            //image: NetworkImage(productDocument['imgpro']),
            image: NetworkImage(productDocument['imgpro']),
            fit: BoxFit.contain,
            fadeInDuration: Duration(milliseconds: 100),
            height: 200.0,
          ),
        ),
        Opacity(
          opacity: .4,
          child: Container(
            height: 55.0,
            color: Colors.black,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    productDocument['cveprod'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    // Card(
    //   clipBehavior: Clip.antiAlias,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(24),
    //   ),
    //   child: Column(
    //     children: [
    //       Stack(
    //         alignment: Alignment.center,
    //         children: [
    //           Ink.image(
    //             image: NetworkImage(
    //               productDocument['imgpro'],
    //             ),
    //             height: 240,
    //             fit: BoxFit.contain,
    //           ),
    //           Positioned(
    //             bottom: 0,
    //             right: 0,
    //             left: 0,
    //             child: Opacity(
    //               opacity: .4,
    //               child: Container(
    //                 height: 55.0,
    //                 color: Colors.black,
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       margin: EdgeInsets.only(left: 15),
    //                       child: Text(productDocument['cveprod'],
    //                           style: TextStyle(
    //                               color: Colors.white,
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 24)),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );

    return Container(
      margin: EdgeInsets.all(15.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.6),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: _card,
      ),
    );
  }
}
