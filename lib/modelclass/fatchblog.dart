class fatchblog {
  List<StudentData>? studentData;

  fatchblog({this.studentData});

  fatchblog.fromJson(Map<String, dynamic> json) {
    if (json['studentData'] != null) {
      studentData = <StudentData>[];
      json['studentData'].forEach((v) {
        studentData!.add(new StudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studentData != null) {
      data['studentData'] = this.studentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentData {
  String? sId;
  String? title;
  String? description;
  String? imagepath;
  String? videopath;
  int? iV;

  StudentData(
      {this.sId,
        this.title,
        this.description,
        this.imagepath,
        this.videopath,
        this.iV});

  StudentData.fromJson(Map<String, dynamic> json) {
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
