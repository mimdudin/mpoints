class Rewards {
  String id, name, banner, category;
  String description, email, employeePin;
  String facebook, website, phoneNumber;
  int discount, rewardValue, rewardCost;
  String partnerName, partnerNumber;

  Rewards({
    this.id,
    this.name,
    this.banner,
    this.category,
    this.description,
    this.email,
    this.employeePin,
    this.facebook,
    this.website,
    this.phoneNumber,
    this.discount,
    this.rewardValue,
    this.rewardCost,
    this.partnerName,
    this.partnerNumber,
  });

  factory Rewards.fromJson(String rewardId, Map<String, dynamic> json) {
    return Rewards(
      id: rewardId,
      name: json['reward_name'],
      banner: json['banner'],
      category: json['category'],
      description: json['description'],
      email: json['email'],
      employeePin: json['employee_pin'],
      facebook: json['facebook'],
      website: json['website'],
      phoneNumber: json['phone_number'],
      discount: json['discount'],
      rewardValue: json['reward_value'],
      rewardCost: json['reward_cost'],
      partnerName: json['partner_name'],
      partnerNumber: json['partner_number'],
    );
  }
}
