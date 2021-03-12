
class SubmitModel {
  String message;
  SubmitModel(this.message);
  SubmitModel.fromJson(Map<String, dynamic> map): message = map['message'];
}