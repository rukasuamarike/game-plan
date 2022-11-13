import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:take_break/pages/home.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:location/location.dart';

final router = FluroRouter();
void main() async {
  Handler homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return HomePage();
  });
  router.define("/", handler: homeHandler);
  router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return HomePage();
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location = Location();

  late Stream<LocationData>? locationStream;

  @override
  initState() {
    super.initState();
    locationStream = location.onLocationChanged.asBroadcastStream();
    location.getLocation();
    locationStream!.listen((LocationData? l) {
      print("location updated ${l?.latitude} ${l?.longitude}");
    });
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<User?>.value(
              value: FirebaseAuth.instance.authStateChanges(),
              initialData: null),
        ],
        child: MaterialApp(
            onGenerateRoute: router.generator,
            home: HomePage(),
            theme: ThemeData(
              primarySwatch: Colors.blue,
            )));
  }
}
