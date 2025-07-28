import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../orado_icon_icons.dart';
import '../utilities.dart';
import 'text_formfield.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.isInPage = false,
    this.isHomePage = false,
    required this.hintText,
    this.searchQuery,
    this.onChanged,
  });
  final bool isInPage;
  final bool isHomePage;
  final String hintText;
  final String? searchQuery;
  final ValueChanged<String>? onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController searchTextController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  bool _speechEnabled = false;

  // final TextEditingController _textController = TextEditingController();
  String speechText = 'Listening...';
  bool speechListening = false;
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  Future<void> _startListening() async {
    log('start listening . . .');
    try {
      // Ask for microphone permission here
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        log('Microphone permission denied');
        return;
      }

      // Initialize speech if not already done
      if (!_speechEnabled) {
        _speechEnabled = await _speechToText.initialize();
      }

      if (searchTextController.text.isNotEmpty) {
        searchTextController.clear();
      }

      setState(() {});

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        localeId: 'en_En',
        partialResults: false,
      );

      await showDialog(
        context: context,
        builder: (BuildContext c) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  speechText,
                  style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
                ),
                const SizedBox(height: 10),
                Text(
                  '''Say "Pizza"''',
                  style: AppStyles.getSemiBoldTextStyle(
                      fontSize: 13, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 13),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.baseColor,
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      log('Speech error: $e');
    } finally {
      _stopListening();
    }
  }



  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> _stopListening() async {
    log('stop listening . . .');
    await _speechToText.stop();
    await _speechToText.cancel();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    log(' efcew $_lastWords');
    setState(() {
      _lastWords = result.recognizedWords;
      searchTextController.text = _lastWords;
    });
    // If the speech recognition was successful, we can
    // update the text field with the recognized words.
    //Call onChanged when speech result is set
    if (widget.onChanged != null) {
      widget.onChanged!(_lastWords);
    }
    context.pop();
    _stopListening();
    if (!widget.isInPage) {
      //! context.pushNamed(FoodListingScreen.route, extra: <String, String>{'search_query': _lastWords});
    }
  }

  @override
  void initState() {
    super.initState();
    searchTextController.text = widget.searchQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BuildTextFormField(
      //! onTap: widget.isHomePage ? () => context.pushNamed(AppPaths.searchScreen) : null,
      padding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      fillColor: Colors.grey.shade200,
      controller: searchTextController,
      hint: widget.hintText,
      prefix: const Icon(Icons.search, color: Colors.grey),
      suffix: IconButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        icon: const Icon(
          OradoIcon.mic_outlined,
          color: Colors.red,
        ),
      ),
      onChanged: widget.onChanged, // Call onChanged when text is changed
      onFieldSubmitted: (String value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        //! context.pushNamed(
        // !  FoodListingScreen.route,
        // !  extra: <String, String>{'search_query': value},
        // !);
      },
    );
  }
}
