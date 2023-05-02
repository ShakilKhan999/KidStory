import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kids_story/customs/glass.dart';

class ReadingPage extends StatefulWidget {
  String heroTag;
  static const String routeName = 'reading';
  String title;
  String story;
  ReadingPage({Key? key, this.title = '', this.story = '', this.heroTag = ''})
      : super(key: key);

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  String title = '';
  String story = '';

  @override
  void initState() {
    setData();

    super.initState();
  }

  setData() {
    story = widget.story;
    title = widget.title;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/bg-6.jpeg',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: GlassBox(),
                  ),
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Acherus',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              story,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Acherus',
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/bg-6.jpeg',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: GlassBox(),
                  ),
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Acherus',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              story,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Acherus',
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
