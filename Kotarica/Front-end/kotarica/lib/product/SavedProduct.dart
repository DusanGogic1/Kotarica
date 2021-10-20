import 'package:kotarica/product/Product.dart';

class SavedProduct extends Product {
  int userId; // korisnik koji je sacuvao oglas
  bool
      visible; // da li prikazati sacuvani oglas ili ne / umesto brisanja oglasa

  SavedProduct(this.userId, id, this.visible) : super.idConstructor(id);
}
