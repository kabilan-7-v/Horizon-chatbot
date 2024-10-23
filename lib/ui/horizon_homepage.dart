import 'package:flutter/material.dart';
import 'package:horizon/ui/horizon_chatbotpage.dart';
import 'package:horizon/ui/horizon_groupcall.dart';
import 'package:horizon/ui/horizon_individualchatpage.dart';
import 'package:horizon/ui/horizon_notes.dart';
import 'package:horizon/service/gradienttext.dart';
import 'package:horizon/service/horizon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HorizonHomepage extends StatefulWidget {
  const HorizonHomepage({super.key});

  @override
  State<HorizonHomepage> createState() => _HorizonHomepageState();
}

class _HorizonHomepageState extends State<HorizonHomepage> {
  final calling = TextEditingController();

  @override
  void dispose() {
    calling.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<Widget> userlist = [
    ListTile(
      leading: CircleAvatar(
        radius: 30,
      ),
      title: Text("Kabilan"),
      trailing: Text("5.00pm"),
    ),
    SizedBox(
      height: 15,
    ),
    ListTile(
      leading: CircleAvatar(
        radius: 30,
      ),
      title: Text("Sachita"),
      trailing: Text("5.00pm"),
    ),
    SizedBox(
      height: 15,
    ),
  ];

  List<String> _notes = [];
  final GlobalKey<ScaffoldState> key = GlobalKey();

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes from shared_preferences
  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes') ?? [];
    });
  }

  // Save notes to shared_preferences
  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }

  // Add a new note
  void addNote() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        _notes.add(_noteController.text);
      });
      _saveNotes();
      _noteController.clear();
    }
  }

  // Delete a note
  void deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const GradientText(
          "Horizon",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          gradient: LinearGradient(
              colors: [Color.fromRGBO(228, 212, 156, 1), Color(0xffad9c00)]),
        ),
        leadingWidth: 100,
        leading: SizedBox(
          width: 60,
          height: 60,
          child: Image.asset("assets/Horizon-Thumbnail-1024x576 copy.png"),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HorizonNotes()));
            },
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/notes.png"),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                child: Container(
                                    height: 200,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 233, 223, 190),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Call id:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: calling,
                                          decoration: const InputDecoration(
                                              hintText: "Please Enter call id",
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                      LeviButton(
                                        child: const Text(
                                          "Join Meeting",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CallPage(
                                                        callId: calling.text,
                                                      )));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ])));
                          });
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.video_camera_front_outlined),
                        ),
                        Text(
                          "Create a Meet with a Id...",
                          style: TextStyle(color: Colors.blue[100]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userlist.length,
                    itemBuilder: (context, ind) {
                      return customlisttile("Domar");
                    }),
              )
            ],
          ),
          Positioned(
            bottom: 100,
            right: 15,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Image.asset(
            "assets/Horizon-Thumbnail-1024x576 copy.png",
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatScreen()));
          }),
    );
  }

  customlisttile(name) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HorizonIndividualchatpage(
                      name: name,
                    )));
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        leading: CircleAvatar(
          radius: 30,
        ),
        title: Text("Domar"),
        trailing: Text("5.00pm"),
      ),
    );
  }
}
