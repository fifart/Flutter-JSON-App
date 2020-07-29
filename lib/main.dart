import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter JSON Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Photo>> _getPhotos() async {

    //var a = "https://api.coinranking.com/v1/public/coins/?base=EUR&timePeriod=24h&ids=1,2,3,6,9";
    var b = "https://jsonplaceholder.typicode.com/photos";

    var data = await http.get(b);

    var jsonData = json.decode(data.body);
    print(jsonData);
    List<Photo> photos = [];

    for(var p in jsonData){
      Photo photo = Photo(p["albumId"], p["id"], p["title"], p["url"], p["thumbnailUrl"]);

      photos.add(photo);
    }


    return photos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getPhotos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading...."),
                )
              );
            } else {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].thumbnailUrl
                        ),
                      ),
                      title: Text(snapshot.data[index].title),
                    onTap: (){

                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                        );
                    },
                  );
                },
              );
            }

          },
        )
      ),
    );
  }
}

class DetailPage extends StatelessWidget {

  final Photo photo;

  DetailPage(this.photo);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.title),
      ),
      body: Container(
        child: Center(
          child: Image.network(photo.url),
        ),
      )
    );
  }
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);

}