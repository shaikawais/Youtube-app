import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

mixin HelperClass {
  static const Color successBaseColor = Color.fromRGBO(212, 237, 218, 1);
  static const Color successTextColor = Color.fromRGBO(22, 92, 46, 1);

  static const Color errorBaseColor = Color.fromRGBO(248, 215, 218, 1);
  static const Color errorTextColor = Color.fromRGBO(127, 41, 45, 1);

  static const Color infoBaseColor = Color.fromRGBO(209, 236, 241, 1);
  static const Color infoTextColor = Color.fromRGBO(51, 103, 131, 1);

  static const Color warningBaseColor = Color.fromRGBO(255, 243, 205, 1);
  static const Color warningTextColor = Color.fromRGBO(210, 157, 77, 1);
  static const Color warningSameUserTextColor = Color.fromRGBO(157, 100, 12, 1.0);

  void _showAlertCard(BuildContext context, String message, Color color, IconData icon,
      IconData overlapIcon, Color iconColor) {
    showOverlayNotification((context) {
      Widget overlapped() {
        const overlap = 0;
        final items = [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(icon, size: 20, color: iconColor),
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(overlapIcon, size: 35, color: iconColor),
          ),
        ];

        List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
            child: items[index],
          );
        });

        return Stack(children: stackLayers);
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10), bottom: Radius.circular(10)),
                    color: color),
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.080,
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    overlapped(),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            color: iconColor,
                            fontSize: 18),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    },
        duration: icon == Icons.info_outline
            ? const Duration(milliseconds: 3000)
            : const Duration(milliseconds: 2500));
  }

  void _showWaringCard(BuildContext context, String message, Color color, IconData icon,
      IconData overlapIcon, Color iconColor) {
    showOverlayNotification((context) {
      Widget overlapped() {
        const overlap = 0;
        final items = [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(icon, size: 25, color: iconColor),
          ),
        ];

        List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
            child: items[index],
          );
        });

        return Stack(children: stackLayers);
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10), bottom: Radius.circular(10)),
                    color: color),
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.080,
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    overlapped(),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            color: iconColor,
                            fontSize: 18),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 3500));
  }

  void _showWaringSameUserCard(BuildContext context, String message, Color color, IconData icon,
      IconData overlapIcon, Color iconColor) {
    showOverlayNotification((context) {
      Widget overlapped() {
        const overlap = 0;
        final items = [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(icon, size: 25, color: iconColor),
          ),
        ];

        List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
            child: items[index],
          );
        });

        return Stack(children: stackLayers);
      }

      return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10), bottom: Radius.circular(10)),
                  color: color,
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.075,
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    overlapped(),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 6000));
  }

  void showSuccess(BuildContext context, String message) {
    Timer.run(() => _showAlertCard(context, message, successBaseColor, CupertinoIcons.check_mark,
        Icons.radio_button_unchecked, successTextColor));
  }

  void showInfo(BuildContext context, String message) {
    Timer.run(() => _showWaringCard(context, message, infoBaseColor, Icons.info_outline,
        Icons.radio_button_unchecked, infoTextColor));
  }

  void showError(BuildContext context, String message) {
    Timer.run(() => _showAlertCard(context, message, errorBaseColor, Icons.close_outlined,
        Icons.radio_button_unchecked, errorTextColor));
  }

  void showWarning(BuildContext context, String message) {
    Timer.run(() => _showWaringCard(context, message, warningBaseColor,
        Icons.warning_amber_outlined, Icons.radio_button_unchecked, warningTextColor));
  }

  void showSameUserWarning(BuildContext context, String message) {
    Timer.run(() => _showWaringSameUserCard(context, message, warningBaseColor,
        Icons.warning_amber_outlined, Icons.radio_button_unchecked, warningSameUserTextColor));
  }
}
