import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oya/app.dart';
import 'package:oya/firebase_options.dart';
import 'package:oya/features/scanner/data/off_product_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Open Food Facts SDK user agent
  OffProductClient.configure();

  runApp(
    const ProviderScope(
      child: OyaApp(),
    ),
  );
}
