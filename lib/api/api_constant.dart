// ignore_for_file: non_constant_identifier_names
// http://110.5.102.154:1212/Api_Flutter/spk/get_estimasi_pricing_by_status.php?status_approval=1
class ApiConstants {
  static String baseUrl = 'http://54.179.58.215:8080/api';
  // static String baseUrl = 'http://54.179.58.215:7000/api'; //! Dummy
  static String baseUrlPricing = 'http://110.5.102.154:4000/approvals';
  static String baseUrlImageMdbc =
      'https://110.5.102.154:50001/Files/Images/Product/';

  static String baseUrlPricingWeb = 'http://110.5.102.154:8000/api';

  static String baseUrlsandy = 'http://110.5.102.154:1212/Api_Flutter/spk';
  static String GETPricingEticketing = '/get_estimasi_pricing.php';
  static String GETapprovelPricingEticketing =
      '/get_estimasi_pricing_by_status.php';
  static String GETcustomerMetier = '/indexcustomermetier';
  static String GETapprovelPricingEticketingBySearch =
      '/get_estimasi_pricing_by_search.php';
  static String UPDATEapprovalPricingEticketing =
      '/update_estimasi_harga_by_phone.php';

  static String GETapprovelPricing = '/GetAll';
  static String GETapprovelPricingWaiting = '/StatusWaiting';
  static String GETapprovelPricingApproved = '/StatusApproved';
  static String PUTapprovelPricing = '/lot/';

  static String POSTloginendpoint = '/login';
  static String GETprofileendpoint = '/profile';
  static String GETposSalesendpoint = '/indexpossales';
  static String GETposTokoendpoint = '/indexpostoko';
  static String GETposReturendpoint = '/indexposretur';
  static String GETcustomerendpoint = '/indexcustomer';
  static String GETcustomerendbeliberlianpoint = '/indexcustomerbeliberlian';
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
  static String POSTtokometiercheckoutendpoint = '/postokometiercheckout';
  static String POSTtokobeliberliancheckoutendpoint =
      '/postokobeliberliancheckout';
  static String POSTreturcheckoutendpoint = '/posreturcheckout';
  static String POSTcreateCRMendpoint = '/createcrmsales';
  static String POSTcreateCustomerMetier = '/createcustomer';
  static String POSTmetiercheckout = '/possalesmetiercheckout';
  static String POSThistoryApprove = '/create_history_approve.php';
  static String POSThargaApproved = '/createprice';

  static String DELETEkeranjangtokoendpoint = '/deletecartpostoko';
  static String DELETEkeranjangsalesendpoint = '/deletecartpossales';
  static String DELETEallkeranjangsalesendpoint = '/clearcartpossales';
  static String DELETEallkeranjangtokondpoint = '/clearcartpostoko';
  static String DELETEallkeranjangreturendpoint = '/clearcartposretur';
}
