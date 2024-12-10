library;

import 'package:flutter/material.dart';
import 'package:smart_tooltip/smart_tooltip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Tooltip Demo',
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
        centerTitle: true,
        title: const Text(
          'Smart Tooltip Demo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Expanded(
        child: Column(
          children: [
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Column(
                  children: [
                    SmartTooltip(
                      borderColor: Color(0xFF04A777),
                      message: "This is a Right Smart tooltip!",
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      position: TooltipPosition.right,
                      child: Icon(
                        Icons.ac_unit,
                        size: 50,
                        color: Color(0xFF04A777),
                      ),
                    ),
                    Text(
                      "Right Tooltip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const Column(
                  children: [
                    SmartTooltip(
                      borderColor: Color(0xFF04A777),
                      message: "This is a Left Smart tooltip!",
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      position: TooltipPosition.left,
                      child: Icon(
                        Icons.ac_unit,
                        size: 50,
                        color: Color(0xFF04A777),
                      ),
                    ),
                    Text(
                      "Left Tooltip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SmartTooltipWithWidget(
                      // border radius of the tooltip soul be equal to the border radius of the child widget
                      borderRadius: 10,
                      tooltipContent: Container(
                        height: 215,
                        width: 300,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Flutter Developer",
                              style: TextStyle(
                                color: Color(0xFF04A777),
                                fontSize: 12,
                              ),
                            ),
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
                    const Text(
                      "Custom Widget Tooltip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const Column(
                  children: [
                    SmartTooltip(
                      borderColor: Color(0xFF04A777),
                      message: "This is a Top Smart tooltip!",
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      position: TooltipPosition.top,
                      child: Icon(
                        Icons.ac_unit,
                        size: 50,
                        color: Color(0xFF04A777),
                      ),
                    ),
                    Text(
                      "Top Tooltip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const Column(
                  children: [
                    SmartTooltip(
                      borderColor: Color(0xFF04A777),
                      message: "This is a Bottom Smart tooltip!",
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      position: TooltipPosition.bottom,
                      child: Icon(
                        Icons.ac_unit,
                        size: 50,
                        color: Color(0xFF04A777),
                      ),
                    ),
                    Text(
                      "Bottom Tooltip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
