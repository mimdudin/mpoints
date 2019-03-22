class Employee {
  String id, pin, firstName, lastName;
  Claims claims;

  Employee(this.id, this.pin, this.firstName, this.lastName, this.claims);
}

class Claims {
  int claims, purchaseAmount;

  Claims({this.claims, this.purchaseAmount});

  factory Claims.fromJson(Map<String, dynamic> json) {
    return Claims(
        claims: json['claims'], purchaseAmount: json['purchase_amount']);
  }
}
