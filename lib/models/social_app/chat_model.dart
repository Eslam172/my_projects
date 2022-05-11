class ChatModel {
  String senderId;
  String recieverId;
  String dateTime;
  String text;
  String imageChat;
  String messageId;

  ChatModel(
      {this.senderId,
      this.recieverId,
      this.dateTime,
      this.text,
      this.messageId,
      this.imageChat});

  ChatModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    recieverId = json['recieverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    messageId = json['messageId'];
    imageChat = json['imageChat'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'dateTime': dateTime,
      'text': text,
      'messageId': messageId,
      'imageChat': imageChat,
    };
  }
}
