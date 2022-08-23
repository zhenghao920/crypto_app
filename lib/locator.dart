

import 'package:crypto_app/repo.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.asNewInstance();
final s1 = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton<CoinRepo>(() => CoinRepo());
  s1.registerLazySingleton<CoinRepo>(() => CoinRepo());
}