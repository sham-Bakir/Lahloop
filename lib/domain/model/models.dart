// Onboarding Models
class SliderObject {
  String title;
  String subTitle;
  String image;
  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}

// login models
class Customer {
  // they should not be null (I don't want to pass a null value to the view)
  String id;
  String name;
  int numOfNotifications;
  Customer(this.id, this.name, this.numOfNotifications);
}

class Contacts {
  // they should not be null (I don't want to pass a null value to the view)
  String phone;
  String email;
  String link;
  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  // I don't want to pass a null value but not for a whole class
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer, this.contacts);
}
