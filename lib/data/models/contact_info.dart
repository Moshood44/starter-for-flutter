class ContactInfo {
  final String? phoneNumber;
  final String? whatsappNumber;
  final String? telegramHandle;
  final String? instagramHandle;

  const ContactInfo({
    this.phoneNumber,
    this.whatsappNumber,
    this.telegramHandle,
    this.instagramHandle,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
      'telegramHandle': telegramHandle,
      'instagramHandle': instagramHandle,
    };
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phoneNumber: json['phoneNumber'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      telegramHandle: json['telegramHandle'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
    );
  }

  // Validation
  bool get hasAnyContact {
    return phoneNumber != null ||
        whatsappNumber != null ||
        telegramHandle != null ||
        instagramHandle != null;
  }

  bool get isPhoneNumberValid {
    if (phoneNumber == null) return true;
    // Basic phone number validation (can be enhanced)
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phoneNumber!);
  }

  ContactInfo copyWith({
    String? phoneNumber,
    String? whatsappNumber,
    String? telegramHandle,
    String? instagramHandle,
  }) {
    return ContactInfo(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      telegramHandle: telegramHandle ?? this.telegramHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactInfo &&
        other.phoneNumber == phoneNumber &&
        other.whatsappNumber == whatsappNumber &&
        other.telegramHandle == telegramHandle &&
        other.instagramHandle == instagramHandle;
  }

  @override
  int get hashCode {
    return Object.hash(phoneNumber, whatsappNumber, telegramHandle, instagramHandle);
  }

  @override
  String toString() {
    return 'ContactInfo(phoneNumber: $phoneNumber, whatsappNumber: $whatsappNumber)';
  }
}