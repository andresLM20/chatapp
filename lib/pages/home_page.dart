import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/auth/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chatapp_firebase/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:chatapp_firebase/settings/styles_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? googlesignin = "";
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(email: email, userName: userName)));
    }
  }

  @override
  void initState() {
    init();
    super.initState();
    gettingUserData();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("########### PRINT DEVICE TOKEN");
    print(deviceToken);
    print("########################");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage mensaje) {
      String? title = mensaje.notification!.title;
      String? description = mensaje.notification!.body;

      nextScreen(context, ProfilePage(email: email, userName: userName));
      print("ABRIENDO PERFIL!!!!!!!!!!!!");
    });
  }

  //string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      userName = val!;
    });
    //getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  Future importShared() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    googlesignin = sf.getString('googlesignin');
  }

  @override
  Widget build(BuildContext context) {
    importShared();
    final currentTheme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: currentTheme.isDarkTheme()
            ? Colors.black12
            : Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: currentTheme.isDarkTheme()
              ? Colors.black12
              : Color.fromARGB(255, 20, 146, 148),
          actions: [
            IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: Icon(Icons.search),
            ),
          ],
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Groups",
            style: TextStyle(
              color: currentTheme.isDarkTheme() ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor:
              currentTheme.isDarkTheme() ? Color(0xff2a293d) : Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.transparent,
                  backgroundImage: googlesignin == "true"
                      ? NetworkImage(user.photoURL!)
                      : AssetImage('assets/person.png') as ImageProvider),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(height: 2),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                leading: const Icon(Icons.group),
                title: Text(
                  "Mis grupos",
                  style: TextStyle(
                    color: currentTheme.isDarkTheme()
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  nextScreenReplace(
                      context,
                      ProfilePage(
                        userName: userName,
                        email: email,
                      ));
                },
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
                          title: Text("Cerrar sesión"),
                          content: Text(
                              "¿Estás seguro de que quieres cerrar sesión?"),
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
                                  FirebaseAuth.instance.signOut();
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
                  "Cerrar sesión",
                  style: TextStyle(
                      color: currentTheme.isDarkTheme()
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              SizedBox(
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
                        String newTheme = value
                            ? ThemePreference.DARK
                            : ThemePreference.LIGHT;
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
        body: groupList(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              popUpDialog(context);
            },
            elevation: 0,
            //backgroundColor:
            //  currentTheme.isDarkTheme() ? Colors.white : Colors.black,
            child: Icon(Icons.add,
                //color: currentTheme.isDarkTheme() ? Colors.white : Colors.black,
                size: 30)),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    final currentTheme = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Crear un grupo",
                textAlign: TextAlign.left,
              ),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: TextStyle(
                            color: currentTheme.isDarkTheme()
                                ? Colors.black
                                : Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                        ))
              ]),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, "Grupo creado con éxito");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("Crear"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          //make some checks
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['groups'].length,
                    itemBuilder: (context, index) {
                      int reverseIndex =
                          snapshot.data['groups'].length - index - 1;
                      return GroupTile(
                          groupId: getId(snapshot.data['groups'][reverseIndex]),
                          groupName:
                              getName(snapshot.data['groups'][reverseIndex]),
                          userName: snapshot.data['fullname']);
                    });
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor));
          }
        });
  }

  noGroupWidget() {
    final currentTheme = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "No te has unido a ningún grupo, toca + para crear un grupo o puedes buscar alguno al que te puedas unir.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:
                      currentTheme.isDarkTheme() ? Colors.white : Colors.black),
            )
          ]),
    );
  }

  Future getDeviceToken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }
}
