/////////////////////////////////////////////////////////////////////////////////
/// Flutter Advanced Custom Tooltip Example
/// Source Code: Just for testing not for production
library;

import 'package:flutter/material.dart';

import '../SmartTooltipWithWidget.dart';
import '../smartTooltip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Tooltip Demo',
      home: TooltipDemoScreen(),
    );
  }
}

class TooltipDemoScreen extends StatefulWidget {
  const TooltipDemoScreen({super.key});

  @override
  State<TooltipDemoScreen> createState() => _TooltipDemoScreenState();
}

class _TooltipDemoScreenState extends State<TooltipDemoScreen> {
  List<bool> isVisible = [true, true, true, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: Colors.black12,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isVisible[0] = !isVisible[0];
              });
            },
            icon: const Icon(Icons.remove_red_eye, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isVisible[1] = !isVisible[1];
              });
            },
            icon: const Icon(Icons.remove_red_eye, color: Colors.red),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isVisible[2] = !isVisible[2];
              });
            },
            icon: const Icon(Icons.remove_red_eye, color: Colors.green),
          ),
        ],
        title: const Text('Custom Tooltip Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Stack(
              children: [
                // Visibility(
                //   visible: isVisible[3],
                //   child: const CustomTooltip(
                //     borderColor: Color(0xFF04A777),
                //     message: "This is a Right custom tooltip!",
                //     backgroundColor: Color.fromARGB(255, 0, 0, 0),
                //     textStyle: TextStyle(
                //       color: Colors.white,
                //     ),
                //     position: TooltipPosition.right,
                //     child: Icon(
                //       Icons.ac_unit,
                //       size: 50,
                //       color: Color(0xFF04A777),
                //     ),
                //   ),
                // ),
                // Visibility(
                //   visible: isVisible[2],
                //   child: const CustomTooltip(
                //     borderColor: Color(0xFF04A777),
                //     message: "This is a Left custom tooltip!",
                //     backgroundColor: Color.fromARGB(255, 0, 0, 0),
                //     textStyle: TextStyle(
                //       color: Colors.white,
                //     ),
                //     position: TooltipPosition.left,
                //     child: Icon(
                //       Icons.ac_unit,
                //       size: 50,
                //       color: Color(0xFF04A777),
                //     ),
                //   ),
                // ),
                // Visibility(
                //   visible: isVisible[1],
                //   child: const CustomTooltip(
                //     borderColor: Color(0xFF04A777),
                //     message: "This is a Top custom tooltip!",
                //     backgroundColor: Color.fromARGB(255, 0, 0, 0),
                //     textStyle: TextStyle(
                //       color: Colors.white,
                //     ),
                //     position: TooltipPosition.top,
                //     child: Icon(
                //       Icons.ac_unit,
                //       size: 50,
                //       color: Color(0xFF04A777),
                //     ),
                //   ),
                // ),
                // Visibility(
                //   visible: isVisible[0],
                //   child: const CustomTooltip(
                //     borderColor: Color(0xFF04A777),
                //     message: "This is a Bottom custom tooltip!",
                //     backgroundColor: Color.fromARGB(255, 0, 0, 0),
                //     textStyle: TextStyle(
                //       color: Colors.white,
                //     ),
                //     position: TooltipPosition.bottom,
                //     child: Icon(
                //       Icons.ac_unit,
                //       size: 50,
                //       color: Color(0xFF04A777),
                //     ),
                //   ),
                // ),

                SmartTooltipWithWidget(
                  borderRadius: 20,
                  tooltipContent: Container(
                    height: 215,
                    width: 300,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Socials",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.abc_outlined,
                                  color: Colors.pink,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.abc_outlined,
                                  color: Colors.blue[900],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.abc_outlined,
                                  color: Colors.green[600],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.abc_outlined,
                                  color: Colors.blue[800],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: Color(0xFF04A777),
                                    width: 2,
                                  ),
                                ),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://media.licdn.com/dms/image/v2/D4D03AQGydAZQyXtTng/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1732221355286?e=1739404800&v=beta&t=kI0MjYSVuGdyr0lgRbYozkQ1bWQrn6MOY-9KZ24XcAY"),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 5,
                                right: 15,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF04A777),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Talha Attique",
                        ),
                        const Text(
                          "Flutter Developer",
                          style: TextStyle(
                            color: Color(0xFF04A777),
                            fontSize: 12,
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     border: Border.all(
                        //       color: Colors.grey,
                        //       width: 1,
                        //     ),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.message,
                        //           color: Colors.grey[700],
                        //           size: 20,
                        //         ),
                        //         Text(
                        //           "Send Message",
                        //           style: GoogleFonts.roboto(
                        //             fontSize: 12,
                        //             color: Colors.grey[700],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  borderColor: const Color(0xFF04A777),
                  position: TooltipPosition.top,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://media.licdn.com/dms/image/v2/D4D03AQGydAZQyXtTng/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1732221355286?e=1739404800&v=beta&t=kI0MjYSVuGdyr0lgRbYozkQ1bWQrn6MOY-9KZ24XcAY"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
