import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_in_flutter/boxes.dart';
import 'package:hive_in_flutter/person.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  peronsBox = await Hive.openBox<Person>('persons');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Flutter hive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: Colors.blue,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'name',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        hintText: 'age',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          ///add person to boxPerson
                          if (nameController.text.isNotEmpty &&
                              ageController.text.isNotEmpty) {
                            setState(() {
                              peronsBox.put(
                                'key_${nameController.text}',
                                Person(
                                    name: nameController.text,
                                    age: int.parse(ageController.text)),
                              );
                            });
                          }
                        },
                        child: const Text('add')),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: peronsBox.length,
                itemBuilder: (context, index) {
                  Person person = peronsBox.getAt(index);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    child: ListTile(
                      title: Row(
                        children: [
                          Text('name: ${person.name}'),
                          const SizedBox(
                            width: 15,
                          ),
                          Text('age: ${person.age}'),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              peronsBox.deleteAt(index);
                            });
                          },
                          icon: const Icon(Icons.remove)),
                    ),
                  );
                },
              )),
              Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            setState(() {
                              peronsBox.clear();

                            });
                          },
                          child: const Text(
                            'delete all',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
