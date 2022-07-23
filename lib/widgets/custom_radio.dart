import 'package:flutter/material.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double size;
  final List<Color> borderColors;
  final List<Color> internalColors;

  const CustomRadioWidget({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 32,
    required this.borderColors,
    required this.internalColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: value != groupValue? [Colors.grey.shade300, Colors.grey.shade300] : borderColors,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Container(
                  height: size - 8,
                  width: size - 8,
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    gradient: LinearGradient(
                      colors: value == groupValue ? internalColors : [
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}