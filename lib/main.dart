import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'telas/tela_home.dart';

void main() async{
  
  // não sei o que isso faz, mas o flutterconfig precisa
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  // só quero modo retrato.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  String testDeviceIds = FlutterConfig.get("TEST_DEVICE_IDS");

  // isso precisa ser chamado antes, senão o app nem inicia por causa do ADMOB.
  // também é assim no Kotlin.

  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: testDeviceIds.split(' ')
    )
  );
  // Rodar o app
  runApp(const QRCodeDaNeide());
}

// o App
class QRCodeDaNeide extends StatelessWidget{
  const QRCodeDaNeide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 255, 27, 225),
        // contraste mais alto pro play console não gerar 300 mensagens de aviso
        hintColor: const Color.fromARGB(255, 36, 0, 31)
      ),
      home : const TelaHome()
    );
  }
  
}


