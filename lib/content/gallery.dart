class Picture {
  String asset;
  bool isSelfie = false;
  bool wasProfile = false;
  bool isProfile = false;
  bool isClient = false;

  Picture.fromJson(Map json) {
    asset = json['asset'];

    if ( json.containsKey('is_selfie') ) {
      isSelfie = json['is_selfie'];
    }

    if ( json.containsKey('was_profile') ) {
      wasProfile = json['was_profile'];
    }

    if ( json.containsKey('is_profile') ) {
      isProfile = json['is_profile'];
    }

    if ( json.containsKey('is_client') ) {
      isClient = json['is_client'];
    }

  }
}