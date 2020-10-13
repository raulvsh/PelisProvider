import 'package:flutter/material.dart';
import 'package:Cartelera/lang/app_localizations.dart';
import 'package:Cartelera/providers/peliculas_provider.dart';
import 'package:Cartelera/search/search_delegate.dart';
import 'package:Cartelera/widgets/card_swiper_widget.dart';
import 'package:Cartelera/widgets/movie_horizontal.dart';

class ResourcesPage extends StatefulWidget {
  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final peliculasProvider = PeliculasProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    var aux = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false, //No haría falta al no escribirse nunca

      appBar: AppBar(
        centerTitle: true,
        title: Text('Cartelera'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
                // query: 'Hola'
              );
            },
          )
        ],
      ),


      body: _buildResourcesbody(),
    );
  }

  _buildResourcesbody() {
    return Container(
      //color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Container(
            //color: Colors.black,
            //height: 300,
            child: Column(
              children: <Widget>[
                Container(
                  //color: Colors.yellowAccent,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Películas en Cartelera',
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
                  ),
                ),
                CardSwiper(
                  peliculas: snapshot.data,
                ),
              ],
            ),
          );
        } else {
          return Container(
            //height: 300,
            //color: Colors.red,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  _footer(BuildContext context) {
    return Container(
      //color: Colors.pink,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            //color: Colors.yellowAccent,
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Películas Populares',
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            ),
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    peliculas: snapshot.data,
                    siguientePagina: peliculasProvider.getPopulares,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
                //snapshot.data?.forEach((p) => print(p.title));
                //print(snapshot.data);
                //return Container();
              }),
        ],
      ),
    );
  }
}
