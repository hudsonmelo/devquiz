import 'package:DevQuiz/challenge/challenge_controller.dart';
import 'package:DevQuiz/challenge/widget/next_button/next_button_widget.dart';
import 'package:DevQuiz/challenge/widget/question_indicator/question_indicator_widget.dart';
import 'package:DevQuiz/challenge/widget/quiz/quiz_widget.dart';
import 'package:DevQuiz/shared/models/question_model.dart';
import 'package:flutter/material.dart';

class ChallangePage extends StatefulWidget {
  final List<QuestionModel> questions;

  const ChallangePage({Key? key, required this.questions}) : super(key: key);

  @override
  _ChallangePageState createState() => _ChallangePageState();
}

class _ChallangePageState extends State<ChallangePage> {
  final controller = ChallangeController();
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
  }

  void nextPage() {
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(86),
          child: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                ValueListenableBuilder<int>(
                  valueListenable: controller.currentPageNotifier,
                  builder: (context, value, _) => QuestionIndicatorWidget(
                    currentPage: value,
                    length: widget.questions.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: widget.questions
              .map(
                (e) => QuizWidget(
                  question: e,
                  onChange: nextPage,
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: ValueListenableBuilder<int>(
              valueListenable: controller.currentPageNotifier,
              builder: (context, value, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (value < widget.questions.length)
                    Expanded(
                      child: NextButtonWidget.white(
                        label: "Pular",
                        onTap: nextPage,
                      ),
                    ),
                  if (value == widget.questions.length)
                    Expanded(
                      child: NextButtonWidget.green(
                        label: "Confirmar",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
