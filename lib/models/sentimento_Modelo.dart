
class SentimentoModelo {
  String id;
  String sentindo;
  String data;

  SentimentoModelo(
      {required this.id, required this.sentindo, required this.data});
  SentimentoModelo.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        sentindo = map["sentimento"],
        data = map["data"];

  Map<String, dynamic> toMap() {
    return {"id": id, "sentimento": sentindo, "data": data};
  }
}
