class Statement {
  String id;
  String partnerName, contra, rewardName, banner;
  int timestamp, purchaseAmount, rewardCost, rewardValue;
  double claim;

  Statement(
      {this.id,
      this.timestamp,
      this.partnerName,
      this.contra,
      this.rewardName,
      this.banner,
      this.claim,
      this.purchaseAmount,
      this.rewardCost,
      this.rewardValue});

  factory Statement.fromJson(String statementId, Map<String, dynamic> json) {
    return Statement(
        id: statementId,
        timestamp: json['timestamp'],
        partnerName: json['partner_name'],
        contra: json['contra'],
        rewardName: json['reward_name'],
        banner: json['banner'],
        claim: json['claim'],
        purchaseAmount: json['purchase_amount'],
        rewardCost: json['reward_cost'],
        rewardValue: json['reward_value']);
  }
}
