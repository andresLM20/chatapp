import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 64),
            Text(
              title,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subtitle,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 17),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                color: Color.fromARGB(255, 127, 78, 241),
                urlImage: 'assets/on1.png',
                title: 'Una aplicación de mensajería.',
                subtitle:
                    'Chatea con tus amigos desde tu celular. Una aplicación muy intuitiva para intercambiar mensajes con las personas que más quieres.',
              ),
              buildPage(
                color: Color.fromARGB(255, 127, 78, 241),
                urlImage: 'assets/on2.png',
                title: 'Grupos.',
                subtitle:
                    'Crea grupos e invita a tus amigos para iniciar una conversación. Puedes invitar a tantos amigos como prefieras.',
              ),
              buildPage(
                color: Color.fromARGB(255, 127, 78, 241),
                urlImage: 'assets/on3.png',
                title: 'Envía mensajes.',
                subtitle:
                    'Busca un grupo, únete y envía tu primer mensaje para que los demás miembros del grupo puedan verlo.',
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  primary: Colors.white,
                  backgroundColor: Color.fromARGB(255, 30, 23, 158),
                  minimumSize: Size.fromHeight(80),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) =>
                              HomePage())) // SALTA A HOMEPAGE
                      );
                },
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => controller.jumpToPage(2),
                          child: Text("Skip",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 127, 78, 241)))),
                      Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 3,
                          effect: WormEffect(
                            spacing: 16,
                            dotColor: Colors.black26,
                            activeDotColor: Color.fromARGB(255, 127, 78, 241),
                          ),
                          onDotClicked: (index) => controller.animateToPage(
                              index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn),
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: Color.fromARGB(255, 127, 78, 241)),
                        ),
                      ),
                    ]),
              ),
      );
}
