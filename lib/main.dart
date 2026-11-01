import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'di/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  addFontLicenses();

  final providers = await DependencyInjection.init();
  runApp(MultiProvider(providers: providers, child: const OffpickApp()));
}

/// The bundled fonts are under the SIL Open Font License, which asks apps to ship it.
void addFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final family in ['Poppins']) {
      final license = await rootBundle.loadString('assets/fonts/$family-OFL.txt');
      yield LicenseEntryWithLineBreaks([family], license);
    }
  });
}
