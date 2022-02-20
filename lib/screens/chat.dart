import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  update() {
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _messageController = TextEditingController();
    TextEditingController _nicknameController = TextEditingController();
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          style: const TextStyle(color: Colors.white, fontSize: 20),
          controller: _nicknameController,
          decoration: const InputDecoration(
            hintText: 'Enter your nickname...',
            labelText: 'Nickname*',
          ),
        ),
        actions: [
          IconButton(onPressed: update, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: widget.chatRepository.messages.asStream(),
              builder: (BuildContext context, AsyncSnapshot<List<ChatMessageDto>> snapshot) {
                if(!snapshot.hasData) return Text('No Data');
                var messagesList = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                      itemCount: messagesList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemBuilder: (context, index) {
                        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(microseconds: 300), curve: Curves.easeOut);
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade300
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(messagesList[index].author.name.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                                  Text(messagesList[index].createdDateTime.toString(), style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),),
                                  const SizedBox(height: 4,),
                                  Text(messagesList[index].message.toString()),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              }
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Write message",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 12,),
                  FloatingActionButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty && _nicknameController.text.isNotEmpty) {
                        print('MESSAGE::: ${_nicknameController.text} ${_messageController.text}');
                        widget.chatRepository.sendMessage(_nicknameController.text, _messageController.text);
                        update();
                      }
                    },
                    child: const Icon(Icons.send, size: 24,),
                    elevation: 0,
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
