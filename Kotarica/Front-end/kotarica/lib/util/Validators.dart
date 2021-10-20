String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  if (value.isEmpty)
    _msg = "Email adresa nije uneta.";
  else if (!regex.hasMatch(value))
    _msg = "Email adresa nije važeća.";
  return _msg;
}

String validateUsername(String value) {
  String _msg;
  RegExp regex = new RegExp(r'^[a-zA-Z0-9._]{4,}$');

  if (value.isEmpty)
    _msg = "Korisničko ime nije uneto.";
  else if (!regex.hasMatch(value))
    _msg =
        "Korisničko ime mora imati najmanje 4 karaktera.";
  return _msg;
}

bool isEmpty(String value1 , String value2, String value3) {
  String _msg;
  RegExp regex = new RegExp(r'^[a-zA-Z0-9._]{4,}$');

  if (value1.isEmpty || value2.isEmpty || value2.isEmpty)
    return false;

  return true;
}


// String validatePassword(String value){
//   String _msg;
//   RegExp regex1 = new RegExp(r'.{4,}$');
//   RegExp regex2 = new RegExp(r'^(?=.*\d).{4,}$');
//
//   if(value.isEmpty)
//     _msg = "Šifra nije uneta";
//   else if (!regex1.hasMatch(value))
//     _msg = "Šifra mora imati najmanje 4 karaktera.";
//   else if(!regex2.hasMatch(value))
//     _msg = "Šifra mora sadržati najmanje jednu cifru.";
//
//   return _msg;
// }
//
// String validateConfirmPassword(String value, String valueToCofirm){
//   String _msg;
//
//   if(value.compareTo(valueToCofirm) != 0)
//     _msg = "Šifre se ne podudaraju";
//   return _msg;
// }

String validatePrivateKey(String value) {
  const int pkLength = 64;
  String _msg;
  RegExp regex = new RegExp('[0-9a-fA-F]{$pkLength}');

  if (value.length != pkLength) {
    _msg = "Privatni ključ mora sadržati tačno $pkLength karaktera.";
  }
  else if (!regex.hasMatch(value)) {
    _msg = "Privatni ključ se mora sastojati isključivo iz karaktera a-f (ili A-F) i/ili brojeva 0-9.";
  }

  return _msg;
}

String validateConfirmPrivateKey(String value, String valueToConfirm) {
  String _msg;

  if(value.compareTo(valueToConfirm) != 0) {
    _msg = "Privatni ključevi se ne podudaraju.";
  }
  return _msg;
}

String validatePhoneNumber(String value){
  String _msg;
  RegExp regex1 = new RegExp(r'^06[0-9]{8}$');
  RegExp regex2 = new RegExp(r'^06[0-9]{7}$');

  if(value.isEmpty)
    _msg = "Broj telefona nije unet.";
  else if(!regex1.hasMatch(value) && !regex2.hasMatch(value))
    _msg = "Broj telefona je neispravnog oblika.";
  return _msg;
}