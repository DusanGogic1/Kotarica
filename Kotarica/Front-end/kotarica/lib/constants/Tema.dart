
import 'dart:ui';


class Tema{
  static bool dark=false;

  static SetujDark()
  {
    dark=!dark;
  }

   Brightness getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }
}


