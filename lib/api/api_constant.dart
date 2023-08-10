// ignore_for_file: non_constant_identifier_names

class ApiConstants {
  static String baseUrl = 'http://54.179.58.215:8080/api';
  static String baseUrlPricing = 'http://110.5.102.154:4000/approvals';
  static String baseUrlImage =
      'https://110.5.102.154:50001/Files/Images/Product/';

  static String GETapprovelPricing = '/GetAll';

  static String POSTloginendpoint = '/login';
  static String GETprofileendpoint = '/profile';
  static String GETposSalesendpoint = '/indexpossales';
  static String GETposTokoendpoint = '/indexpostoko';
  static String GETposReturendpoint = '/indexposretur';
  static String GETcustomerendpoint = '/indexcustomer';
  static String GETtransaksiendpoint = '/indextransaksi';
  static String GETkeranjangsalesendpoint = '/indexcartpossales';
  static String GETkeranjangtokoendpoint = '/indexcartpostoko/';
  static String GETkeranjangreturendpoint = '/indexcartposretur/';
  static String GETdetailtransaksiendpoint = '/indextdetailtransaksi';
  static String GETcrmendpoint = '/indexcrmsales';
  static String POSTkeranjangsalesendpoint = '/createcartpossales';
  static String POSTkeranjangtokoendpoint = '/createcartpostoko';
  static String POSTkeranjangreturendpoint = '/createcartposretur';
  static String POSTsalescheckoutendpoint = '/possalescheckout';
  static String POSTtokocheckoutendpoint = '/postokocheckout';
  static String POSTreturcheckoutendpoint = '/posreturcheckout';
  static String POSTcreateCRMendpoint = '/createcrmsales';
  static String DELETEkeranjangtokoendpoint = '/deletecartpostoko';
  static String DELETEkeranjangsalesendpoint = '/deletecartpossales';
  static String DELETEallkeranjangsalesendpoint = '/clearcartpossales';
  static String DELETEallkeranjangtokondpoint = '/clearcartpostoko';
  static String DELETEallkeranjangreturendpoint = '/clearcartposretur';
}
