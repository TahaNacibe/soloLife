class ShopItem {
  String title;
  String image;
  int price;
  String itemType;
  bool isOwned;
  String id;

   ShopItem({
    required this.title,
    required this.image,
    required this.price,
    required this.itemType,
    required this.id,
    this.isOwned = false,
  });
}