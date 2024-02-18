import 'package:chat_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ShowUsersToAdd extends StatefulWidget {
  UserModel user;
  
  ShowUsersToAdd({super.key, required this.user});

  @override
  State<ShowUsersToAdd> createState() => _ShowUsersToAddState();
}

class _ShowUsersToAddState extends State<ShowUsersToAdd> {
  @override
  Widget build(BuildContext context) {
    String name = widget.user.name;
    String surname = widget.user.surname;
    String unicNickname = widget.user.unicNickName;

    return Container(
      height: 70,
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
             SizedBox(height: 2,
               child: Divider(height: 2,
                           thickness: 2,
                         ),
             ),

          
          SizedBox(
            height: 60,
            child: ListTile(
              trailing: IconButton(icon: Icon(Icons.person_add), onPressed: () {
                //  Navigator.push(context, MaterialPageRoute(builder: (context) => ));
              },),
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: const Color.fromARGB(255, 132, 126, 73)),
                child: Center(
                  child: Text(
                    "${name.substring(0, 1)}${surname.substring(0, 1)}",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              title: Text("${name} ${surname}"),
              subtitle: Text("${unicNickname}"),
            ),
          ),
       
        ],
      ),
    );
  }
}
