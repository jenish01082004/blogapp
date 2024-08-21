class fatchone {
  Blog? blog;

  fatchone({this.blog});

  fatchone.fromJson(Map<String, dynamic> json) {
    blog = json['blog'] != null ? new Blog.fromJson(json['blog']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.blog != null) {
      data['blog'] = this.blog!.toJson();
    }
    return data;
  }
}

class Blog {
  String? sId;
  String? title;
  String? description;
  String? imagepath;
  String? videopath;
  int? iV;

  Blog(
      {this.sId,
        this.title,
        this.description,
        this.imagepath,
        this.videopath,
        this.iV});

  Blog.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    imagepath = json['Imagepath'];
    videopath = json['videopath'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['Imagepath'] = this.imagepath;
    data['videopath'] = this.videopath;
    data['__v'] = this.iV;
    return data;
  }
}
