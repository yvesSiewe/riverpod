import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(
    ProviderScope(child: const MyApp())
  );
}
final counterProvider = StateProvider<int>((ref) => 0);
final themeDataProvider = StateProvider<bool>((ref) => false);
final nameProvider = Provider<String>((ref)=> 'Yves');
final lastnameProvider = Provider<String>((ref)=> 'Roland');
// definition de l'etat qui ecoute
final listProvider = StateProvider<List<String>>((ref)=>[]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final counter = ref.watch(counterProvider);
    final themeData = ref.watch(themeDataProvider);
    final name = ref.watch(nameProvider);
    final listTodo = ref.watch(listProvider);
    TextEditingController searchControler = TextEditingController();

    return Scaffold(
      backgroundColor: themeData? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: themeData? Colors.white : Colors.black,
        title: Text(
          'riverpodTest $name',
          style: TextStyle(
            color: themeData? Colors.black: Colors.white
          ),
        ),
        actions: [
          ElevatedButton(onPressed: (){
            ref.read(themeDataProvider.notifier).state = !ref.read(themeDataProvider.notifier).state;
          }, 
            child: Text(themeData? 'Darck': 'light')
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'value: $counter',
              style: TextStyle(
                color: themeData? Colors.black: Colors.white
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      if(ref.read(counterProvider)>0){
                        ref.read(counterProvider.notifier).state --;
                      }
                    },
                    icon: Icon(Icons.remove)
                  ),
                  IconButton(
                    onPressed: (){
                      ref.read(counterProvider.notifier).state++;
                    },
                    icon: Icon(Icons.add)
                  )
                ],
              ),
            ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: SearchBar(
                          controller: searchControler,
                          hintText: 'Add a task',
                        ),
                      ),
                      Expanded(child: IconButton(
                          onPressed: (){
                            ref.read(listProvider.notifier).state = [
                              searchControler.text,
                              ...ref.read(listProvider),
                            ];
                          },
                          icon: Icon(Icons.add)
                        )
                      )
                    ],
                  ),
                ),
            Expanded(
              child: listTodo.isEmpty?
                 Center(
                  child: Text('no element yet'),
                 ):
                 ListView.builder(
                    itemCount: listTodo.length,
                    itemBuilder:(context, index){
                      return ListTile(
                        title: Text(listTodo[index]),
                        trailing: Icon(Icons.delete, color: Colors.red,),
                      );
                    },),
            )
          ],
        ),
      ),
    );
  }
}

