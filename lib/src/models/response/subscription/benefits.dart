class Benefits {
  int? numOfService;
  int? numOfUser;
  int? numOfOffer;
  int? location;
  int? followYourActive;

  Benefits(
      {this.numOfService,
      this.numOfUser,
      this.numOfOffer,
      this.location,
      this.followYourActive});

  Benefits.fromJson(Map<String, dynamic> json) {
    numOfService = json['num_of_service'];
    numOfUser = json['num_of_user'];
    numOfOffer = json['num_of_offer'];
    location = json['location'];
    followYourActive = json['follow_your_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_of_service'] = this.numOfService;
    data['num_of_user'] = this.numOfUser;
    data['num_of_offer'] = this.numOfOffer;
    data['location'] = this.location;
    data['follow_your_active'] = this.followYourActive;
    return data;
  }
}
