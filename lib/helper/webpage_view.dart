import 'package:direct_emploi/helper/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageView extends StatefulWidget {
  const WebPageView({super.key, required this.controller, required this.webPageTitle});
  final WebViewController controller;
  final String webPageTitle;

  @override
  State<WebPageView> createState() => _WebPageViewState();
}

class _WebPageViewState extends State<WebPageView> {
  var loadingPercentage = 0;

  @override
  void initState(){
    super.initState();
    widget.controller..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url){
          setState(() {
            loadingPercentage = 0;
          });
        },
          onProgress: (progress){
          loadingPercentage = progress;
          },
        onPageFinished: (url){
          setState(() {
            loadingPercentage = 100;
          });
        }
      )
    )..setJavaScriptMode(JavaScriptMode.unrestricted)..addJavaScriptChannel("SnackBar", onMessageReceived: (message){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          widget.webPageTitle,
          style: TextStyle(fontSize: 14, color: textColor,fontFamily: 'semi-bold'),
        ),
        actions: [
          IconButton(onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await widget.controller.canGoBack()){
              await widget.controller.goBack();
            }else{
              messenger.showSnackBar(SnackBar(content: Text("Vous n'avez pas de page précedente pour revenir.")));
            }
            return;

          }, icon: Icon(Icons.arrow_back_ios,)),

          IconButton(onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await widget.controller.canGoForward()){
              await widget.controller.goForward();
            }else{
              messenger.showSnackBar(SnackBar(content: Text("Vous n'avez pas de page suivante pour revenir.")));
            }
            return;
          }, icon: Icon(Icons.arrow_forward_ios,)),

          IconButton(onPressed: () async {
            widget.controller.reload();
          }, icon: Icon(Icons.replay,)),
        ],

      ),
      body: SafeArea(
        child: Stack(
            children: [
              WebViewWidget(controller: widget.controller),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                )
            ]),
      ),
    );
  }
}
