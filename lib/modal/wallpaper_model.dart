class WallpaperModel {
  String photographer,photoId;
  UrlModel urls;
  WallpaperModel({this.photographer, this.urls,this.photoId});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
        photographer: jsonData["user"]["name"],
        urls: UrlModel.fromMap(jsonData["urls"]),
        photoId: jsonData['id']
    );
  }
}

class UrlModel {
  String raw, full, regular, small, thumb,custom;

  UrlModel({this.raw, this.full, this.regular, this.small, this.thumb,this.custom});
  factory UrlModel.fromMap(Map<String, dynamic> jsonData) {
    return UrlModel(
      raw: jsonData['raw'],
      full: jsonData['full'],
      regular: jsonData['regular'],
      small: jsonData['small'],
      thumb: jsonData['thumb'],
      custom: jsonData['raw']+"&q=85&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max"
    );
  }
}
