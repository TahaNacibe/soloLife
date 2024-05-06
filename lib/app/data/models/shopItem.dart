class ShopItem {
  String title;
  String image;
  int price;
  String itemType;
  bool isOwned;
  String id;
  int rarity;
  String description;

   ShopItem({
    required this.title,
    required this.image,
    required this.price,
    required this.itemType,
    required this.id,
    this.isOwned = false,
    required this.rarity,
    this.description = "no Description for that item"
  });
}