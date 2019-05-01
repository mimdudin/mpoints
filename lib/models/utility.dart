class Utility {
  String email, facebook, website, termOfUse;

  Utility({this.email, this.facebook, this.website, this.termOfUse});

  factory Utility.fromJson(Map<String, dynamic> json) {
    return Utility(email: json['email'], facebook: json['facebook'], website: json['website'], termOfUse: json['termOfUse']);
  }
}
