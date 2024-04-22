import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late WebViewController controller;
  bool isLoading = false;

   @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (await controller.canGoBack()) {
        controller.goBack();
        return false;
      } else {
        return false;
      }
    },
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Высота вашей кастомной шапки
        child: CustomAppBar(),
      ),

      body: Stack(
        children: <Widget>[
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "https://plof.atlasdemo.space",
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            onPageStarted: (url) {
              setState(() {
                isLoading = true; // Начало загрузки - устанавливаем isLoading в true
              });
            },
            onPageFinished: (url) {
              Future.delayed(Duration(milliseconds: 400), () {
                setState(() {
                  isLoading = false;
                });
              });
              controller.runJavascript(
                  'document.querySelector("header").style.display = "none";'
                      'document.querySelector("footer").style.display = "none";'
                      'document.querySelector("nav").style.display = "none";'
                      'document.getElementById("floatButton").style.display = "none";'
              );
            },
          ),
          if (isLoading)
            Container(
              color: Colors.white, // Белый фон
              child: Center(
                child: Lottie.asset('assets/loadaer.json'),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // border: Border(
          //   top: BorderSide(color: Colors.grey),
          //   left: BorderSide(),
          //   right: BorderSide(),
          //   bottom: BorderSide(),
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.white,
            color: Color(0xFF4E4E4E),
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xFFfab758),
            gap: 8,
            iconSize: 28,
            padding: const EdgeInsets.all(12),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Главная',
                onPressed: () {
                  controller.loadUrl('https://plof.atlasdemo.space/');
                },
              ),
              GButton(
                icon: Icons.category,
                text: 'Контакты',
                onPressed: () {
                  controller.loadUrl('https://plof.atlasdemo.space');
                },
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: 'Корзина',
                onPressed: () async {
                  await controller.runJavascript('''
                  var button = document.querySelector('[data-bs-toggle="offcanvas"][data-bs-target="#offcanvas-cart"]');
                  if (button) {
                    button.click();
                  }
                ''');
                },
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Аккаунт',
                onPressed: () {
                  controller.loadUrl('https://plof.atlasdemo.space/user');
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );


}




class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 0.0), // Выберите подходящие значения
      child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/logomain.png',
            width: 100,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _launchURL('https://wa.me/996706737010');
                },
                child: SvgPicture.asset(
                  'assets/whatsapp.svg',
                  height: 24,
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.instagram.com/zubobra/');
                },
                child: SvgPicture.asset(
                  'assets/instagram.svg',
                  height: 24,
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _launchURL('tel:+996708715281');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0), // Паддинги сверху и снизу
                  child: Text(
                    'Заказать',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [],
    ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
