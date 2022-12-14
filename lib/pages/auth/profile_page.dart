import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_firebase/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:chatapp_firebase/settings/styles_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? googlesignin = "";
  AuthService authService = AuthService();

  Future importShared() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    googlesignin = sf.getString('googlesignin');
  }

  @override
  Widget build(BuildContext context) {
    importShared();
    final currentTheme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: currentTheme.isDarkTheme()
          ? Colors.black12
          : Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: currentTheme.isDarkTheme()
            ? Colors.black12
            : Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text("Perfil",
            style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        backgroundColor:
            currentTheme.isDarkTheme() ? Color(0xff2a293d) : Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          children: <Widget>[
            CircleAvatar(
                radius: 90,
                backgroundColor: currentTheme.isDarkTheme()
                    ? Color(0xff2a293d)
                    : Colors.white,
                backgroundImage: googlesignin == "true"
                    ? NetworkImage(user.photoURL!)
                    : AssetImage('assets/person.png') as ImageProvider),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      currentTheme.isDarkTheme() ? Colors.white : Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(height: 2),
            ListTile(
              onTap: () {
                nextScreen(context, HomePage());
              },
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: const Icon(Icons.group),
              title: Text(
                "Mis grupos",
                style: TextStyle(
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            ListTile(
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: const Icon(Icons.group),
              title: Text(
                "Perfil",
                style: TextStyle(
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Cerrar sesi??n"),
                        content:
                            Text("??Est??s seguro de que quieres cerrar sesi??n?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                SharedPreferences sf =
                                    await SharedPreferences.getInstance();
                                sf.setString("googlesignin", "false");
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              leading: const Icon(Icons.exit_to_app),
              title: Text(
                "Cerrar sesi??n",
                style: TextStyle(
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.wb_sunny,
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black),
                Switch(
                    value: currentTheme.isDarkTheme(),
                    onChanged: (value) {
                      String newTheme =
                          value ? ThemePreference.DARK : ThemePreference.LIGHT;
                      currentTheme.setTheme = newTheme;
                    }),
                Icon(Icons.brightness_2,
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black)
              ],
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleAvatar(
              radius: 90,
              backgroundImage: googlesignin == "true"
                  ? NetworkImage(user.photoURL!)
                  : AssetImage('assets/person.png') as ImageProvider),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nombre: ",
                  style: TextStyle(
                      color: currentTheme.isDarkTheme()
                          ? Colors.white
                          : Colors.black,
                      fontSize: 17)),
              Text(widget.userName,
                  style: TextStyle(
                      color: currentTheme.isDarkTheme()
                          ? Colors.white
                          : Colors.black,
                      fontSize: 17))
            ],
          ),
          const Divider(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Email: ",
                  style: TextStyle(
                      color: currentTheme.isDarkTheme()
                          ? Colors.white
                          : Colors.black,
                      fontSize: 17)),
              Text(widget.email,
                  style: TextStyle(
                      color: currentTheme.isDarkTheme()
                          ? Colors.white
                          : Colors.black,
                      fontSize: 17))
            ],
          ),
        ]),
      ),
    );
  }
}
