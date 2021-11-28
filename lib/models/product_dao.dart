class ProductDAO {
  String? cveprod;
  String? descpro;
  String? imgpro;

  ProductDAO({this.cveprod, this.descpro, this.imgpro});

  Map<String, dynamic> toMap() {
    return {
      'cveprod': cveprod,
      'descpro': descpro,
      'imgpro': imgpro,
    };
  }
}
