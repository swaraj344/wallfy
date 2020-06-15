import 'package:wallfy/modal/modal.dart';

final String apiKey = "zhivDdpUDmP0ve7ooXU6QQCEjV2SVNv4gcvktXSlHqc";


List<CategoriesModal> getCategories(){

  List<CategoriesModal> categories = new List();
  CategoriesModal categoriesModal = new CategoriesModal();


  categoriesModal.categoriesName = "Nature";
  categoriesModal.imgUrl = "assets/images/nature.jpg";
  categories.add(categoriesModal);

  categoriesModal = new CategoriesModal();
  categoriesModal.categoriesName = "Street Art";
  categoriesModal.imgUrl = "assets/images/street.jpg";
  categories.add(categoriesModal);

  categoriesModal = new CategoriesModal();
  categoriesModal.categoriesName = "Cars";
  categoriesModal.imgUrl = "assets/images/car.jpg";
  categories.add(categoriesModal);

  categoriesModal = new CategoriesModal();
  categoriesModal.categoriesName = "Dark";
  categoriesModal.imgUrl = "assets/images/dark.jpg";
  categories.add(categoriesModal);

  categoriesModal = new CategoriesModal();
  categoriesModal.categoriesName = "Random";
  categoriesModal.imgUrl = "assets/images/random.jpg";
  categories.add(categoriesModal);


  return categories;

}