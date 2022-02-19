import 'package:cc/round.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CountTime extends StatefulWidget {
  const CountTime({Key? key}) : super(key: key);

  @override
  _CountTimeState createState() => _CountTimeState();
}

class _CountTimeState extends State<CountTime> with TickerProviderStateMixin {
  late AnimationController controller;
  bool isplaying = false;
  String get countText {
    Duration count = controller.duration! * controller.value;
    print(controller.duration! * controller.value);
    print("C $controller.duration!");
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;
  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
      // controller.duration = const Duration(
      //   hours: 0,
      //   minutes: 0,
      //   seconds: 0,
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isplaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 190, 32, 106),
      body: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: size.height*0.45,
                    width: size.width*0.78,
                    child: CircularProgressIndicator(
                      backgroundColor: const Color.fromARGB(255, 185, 93, 124),
                      value: progress,
                      strokeWidth: 6,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: size.height*0.4,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: controller.duration!,
                            onTimerDurationChanged: ((value) {
                              setState(() {
                                controller.duration = value;
                              });
                            }),
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: const TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      controller.stop();
                      setState(() {
                        isplaying = false;
                      });
                    } else {
                      controller.reverse(
                        from: controller.value == 0 ? 1.0 : controller.value,
                      );
                      setState(() {
                        isplaying = true;
                      });
                    }
                  },
                  child: RoundButton(
                    iconData: isplaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.reset();
                    setState(() {
                      isplaying = false;
                    });
                  },
                  child: const RoundButton(
                    iconData: Icons.stop,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
