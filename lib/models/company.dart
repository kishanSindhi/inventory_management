const companyTable = 'company';

class CompanyFields {
  static const id = '_id';
  static const name = 'companyName';
}

class Company {
  final int id;
  final String companyName;

  Company({
    required this.id,
    required this.companyName,
  });

  Map<String, Object?> toJson() => {
        CompanyFields.id: id,
        CompanyFields.name: companyName,
      };
}
