import 'package:flutter/material.dart';
import 'package:supermanager/shared_components/add_task_sheet.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSubmitted;
  final String otherEndId;

  const ChatInputWidget({Key key,@required this.onSubmitted, this.otherEndId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChatInputWidgetState();

}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  TextEditingController editingController=TextEditingController();
  FocusNode focusNode=FocusNode();
  @override
  void initState() {
    super.initState();
    editingController.addListener((){
      if(mounted){
        setState(() {

        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(),
        Expanded(
          flex: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 8.0),
            decoration: BoxDecoration(color: Color.fromRGBO(121, 134, 203, 1).withOpacity(0.06),borderRadius: BorderRadius.circular(32.0),),
            margin: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(child: TextField(
                  decoration: InputDecoration(
                    border:InputBorder.none,
                    hintText: "Type Your Message here",
                    contentPadding: EdgeInsets.only(left: 10)
                  ),
                  focusNode: focusNode,
                  textInputAction: TextInputAction.send,
                  controller: editingController,
                  onSubmitted: sendMessage,
                )),
                IconButton(
                  icon: Icon(
                    isTexting?
                    Icons.send
                    :Icons.library_add), 
                    onPressed: (){
                      isTexting?
                      sendMessage(editingController.text)
                      :Modal().mainBottomSheet(context, widget.otherEndId);
                      },
                    color: Color.fromRGBO(121, 134, 203, 1),),
              ],
            ),
          ),
        ),
      ],
    );
  }
  bool get isTexting=>editingController.text.length!=0;

  void sendMessage(String message){
    if(!isTexting){
      return;
    }
    widget.onSubmitted(message);
    editingController.text='';
    //focusNode.unfocus();
  }
}