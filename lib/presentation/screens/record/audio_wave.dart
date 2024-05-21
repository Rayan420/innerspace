import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/data/controller/recording/audi_recording_controller.dart';

class AudioWave extends StatefulWidget {
  const AudioWave({super.key});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final ScrollController scrollController = ScrollController();
  List<double> amplitudes = [];
  late StreamSubscription<double> amplitudeSubscription;

  double wavesMaxHeight = 50;
  final double minimumAmpl = -50;

  @override
  void initState() {
    super.initState();
    amplitudeSubscription =
        context.read<AudioRecorderController>().amplitudeStream.listen((amp) {
      setState(() {
        amplitudes.add(amp);
      });

      if (scrollController.positions.isNotEmpty) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            curve: Curves.linear, duration: const Duration(milliseconds: 160));
      }
    });
  }

  @override
  void dispose() {
    amplitudeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: wavesMaxHeight,
      child: ListView.builder(
        controller: scrollController,
        itemExtent: 6,
        itemCount: amplitudes.length,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          double amplitude = amplitudes[index].clamp(minimumAmpl + 1, 0);
          double amplPercentage = 1 - (amplitude / minimumAmpl).abs();
          double waveHeight = wavesMaxHeight * amplPercentage;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: waveHeight),
                duration: const Duration(milliseconds: 120),
                curve: Curves.decelerate,
                builder: (context, animatedWaveHeight, child) {
                  return SizedBox(
                      height: animatedWaveHeight, width: 8, child: child);
                },
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: tSecondaryColor,
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
          );
        },
      ),
    );
  }
}
