class Partners {
  String id, name, category;
  String logo, email, facebook;
  String phoneNumber, website, partnerNumber;
  bool isNewest, isPopular;
  int pointsRate, socialRate;

  Partners(
      {this.id,
      this.name,
      this.category,
      this.logo,
      this.email,
      this.facebook,
      this.phoneNumber,
      this.partnerNumber,
      this.website,
      this.isNewest,
      this.isPopular,
      this.pointsRate,
      this.socialRate});

  factory Partners.fromJson(String partnerId, Map<String, dynamic> json) {
    return Partners(
      id: partnerId,
      name: json['name'],
      category: json['category'],
      logo: json['logo'],
      email: json['email'],
      facebook: json['facebook'],
      phoneNumber: json['phone_number'],
      partnerNumber: json['partner_number'],
      website: json['website'],
      isNewest: json['isNewest'],
      isPopular: json['isPopular'],
      pointsRate: json['points_rate'],
      socialRate: json['social_rate'],
    );
  }
}
