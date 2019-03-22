class Partners {
  String id, name, category;
  String logo, email, facebook;
  String phoneNumber, website;

  Partners(
      {this.id,
      this.name,
      this.category,
      this.logo,
      this.email,
      this.facebook,
      this.phoneNumber,
      this.website});

  factory Partners.fromJson(String partnerId, Map<String, dynamic> json) {
    return Partners(
        id: partnerId,
        name: json['name'],
        category: json['category'],
        logo: json['logo'],
        email: json['email'],
        facebook: json['facebook'],
        phoneNumber: json['phone_number'],
        website: json['website']);
  }
}
