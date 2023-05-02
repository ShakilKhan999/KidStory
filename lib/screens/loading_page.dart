import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_story/screens/story_create_and_list.dart';
import 'package:provider/provider.dart';

import '../providers/chat_gpt_provider.dart';

class LoadingPage extends StatefulWidget {
  static const String routeName='/loadingpage';
  LoadingPage({Key? key,}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}
class _LoadingPageState extends State<LoadingPage> {
  late ChaGptProvider chaGptProvider;


  @override
  void didChangeDependencies() {
    // chaGptProvider = Provider.of<ChaGptProvider>(context, listen: true);
    // if(chaGptProvider.storycreated)
    //   {
    //     Navigator.pushReplacementNamed(context, StoryCreateAndList.routeName);
    //   }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
