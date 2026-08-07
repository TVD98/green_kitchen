import '../models/recipe_models.dart';

/// Sample discovery payloads matching `POST /discovery/search` `data[]` items.
///
/// Envelope shape from the API:
/// ```json
/// { "success": true, "data": [ /* these objects */ ] }
/// ```
const fakeDiscoveryRecipeJson = <Map<String, dynamic>>[
  {
    'id': 'fake_rec_tofu_pepper',
    'title': 'Đậu hũ sốt tiêu xanh',
    'slug': 'dau-hu-sot-tieu-xanh',
    'description':
        'Món chay cay nhẹ, xào nhanh trong chảo với tiêu xanh và nước tương.',
    'time_minutes': 25,
    'difficulty': 'easy',
    'servings': 2,
    'tags': ['vegetarian', 'mild', 'vietnamese', 'quick'],
    'steps': [
      {'order': 1, 'text': 'Cắt đậu hũ thành khối vừa ăn, thấm khô.'},
      {'order': 2, 'text': 'Phi thơm tỏi, cho đậu hũ vào chiên vàng nhẹ.'},
      {'order': 3, 'text': 'Thêm tiêu xanh, nước tương, đảo đều 2–3 phút.'},
    ],
    'ingredients': [
      {'name': 'đậu hũ', 'quantity': '300g'},
      {'name': 'tiêu xanh', 'quantity': '50g'},
      {'name': 'tỏi', 'quantity': '3 tép'},
      {'name': 'nước tương', 'quantity': '2 muỗng canh'},
    ],
    'nutrition': {
      'calories': 280,
      'protein_g': 18,
      'carbs_g': 12,
      'fat_g': 16,
    },
    'image_url':
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=1200&q=80',
    'source': 'gemini',
    'created_at': '2026-08-03T08:00:00.000Z',
  },
  {
    'id': 'fake_rec_mushroom_soup',
    'title': 'Canh nấm rau củ',
    'slug': 'canh-nam-rau-cu',
    'description':
        'Canh thanh nhẹ với nấm hương, cà rốt và bắp cải, phù hợp ăn kèm cơm.',
    'time_minutes': 20,
    'difficulty': 'easy',
    'servings': 3,
    'tags': ['vegetarian', 'light', 'soup'],
    'steps': [
      {'order': 1, 'text': 'Rửa nấm, thái mỏng cà rốt và bắp cải.'},
      {'order': 2, 'text': 'Đun nước dùng rau, cho rau củ vào nấu 10 phút.'},
      {'order': 3, 'text': 'Nêm muối, tiêu, tắt bếp và rắc hành lá.'},
    ],
    'ingredients': [
      {'name': 'nấm hương', 'quantity': '100g'},
      {'name': 'cà rốt', 'quantity': '1 củ'},
      {'name': 'bắp cải', 'quantity': '150g'},
      {'name': 'hành lá', 'quantity': '2 nhánh'},
    ],
    'nutrition': {
      'calories': 90,
      'protein_g': 4,
      'carbs_g': 14,
      'fat_g': 2,
    },
    'image_url':
        'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=1200&q=80',
    'source': 'gemini',
    'created_at': '2026-08-03T08:01:00.000Z',
  },
  {
    'id': 'fake_rec_lemongrass_tofu',
    'title': 'Đậu hũ xả ớt',
    'slug': 'dau-hu-xa-ot',
    'description':
        'Đậu hũ chiên giòn phủ xả ớt thơm nồng, mức độ medium.',
    'time_minutes': 30,
    'difficulty': 'medium',
    'servings': 2,
    'tags': ['vegetarian', 'spicy', 'vietnamese'],
    'steps': [
      {'order': 1, 'text': 'Thái đậu hũ, chiên vàng các mặt.'},
      {'order': 2, 'text': 'Băm xả, ớt; xào thơm rồi cho đậu hũ vào đảo.'},
      {'order': 3, 'text': 'Nêm nước mắm chay, đường, tắt bếp.'},
    ],
    'ingredients': [
      {'name': 'đậu hũ', 'quantity': '350g'},
      {'name': 'sả', 'quantity': '3 cây'},
      {'name': 'ớt', 'quantity': '2 quả'},
      {'name': 'nước mắm chay', 'quantity': '1.5 muỗng canh'},
    ],
    'nutrition': {
      'calories': 320,
      'protein_g': 20,
      'carbs_g': 10,
      'fat_g': 22,
    },
    'image_url':
        'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?auto=format&fit=crop&w=1200&q=80',
    'source': 'gemini',
    'created_at': '2026-08-03T08:02:00.000Z',
  },
];

List<RecipeModel> fakeDiscoveryRecipeModels() => fakeDiscoveryRecipeJson
    .map(RecipeModel.fromJson)
    .toList(growable: false);

RecipeModel? fakeDiscoveryRecipeById(String id) {
  for (final json in fakeDiscoveryRecipeJson) {
    if (json['id'] == id) {
      return RecipeModel.fromJson(json);
    }
  }
  return null;
}
