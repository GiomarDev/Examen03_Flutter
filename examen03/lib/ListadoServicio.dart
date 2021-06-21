import 'dart:convert';
import 'package:json_table/json_table.dart';
import 'package:examen03/ServicioObject.dart';
import 'package:flutter/material.dart';
import 'package:examen03/NuevoServicio.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' show Future;

class ListadoServicio extends StatefulWidget {
  List<ServicioObejct> oListaServicio = [];
  int codigoServicioSelect = 0;

  //Codigos para el Web API
  String url = "http://wscibertec2021.somee.com";
  String urlController = "/Servicio/";
  String urlListado = "Listar?NombreCliente=";

  String jsonServicios =
      '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 0,"MensajeError": null}]';

  String titulo;
  ListadoServicio(this.titulo);

  @override
  State<StatefulWidget> createState() => _ListadoServicio();
}

class _ListadoServicio extends State<ListadoServicio> {
  final _tfNombredeCliente = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> _consultarServicios() async {
    print("Iniciando");
    String urlListaServicios = widget.url +
        widget.urlController +
        widget.urlListado +
        _tfNombredeCliente.text.toString();

    Uri urlFinal = Uri.parse(urlListaServicios);

    var response = await http.get(urlFinal);
    var data = response.body;

    var oListaServicioObejctTmp = List<ServicioObejct>.from(
        json.decode(data).map((x) => ServicioObejct.fromJson(x)));
    setState(() {
      widget.oListaServicio = oListaServicioObejctTmp;
      widget.jsonServicios = data;

      if (widget.oListaServicio.length == 0) {
        widget.jsonServicios =
            '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 0,"MensajeError": null}]';
      }
    });

    return "Procesado";
  }

  void _nuevoServicios() {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return new NuevoServicio("", widget.codigoServicioSelect);
    }));
  }

  void _verRegistro() {}

  @override
  Widget build(BuildContext context) {
    //Declara variable
    var json = jsonDecode(widget.jsonServicios);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Consulta de Servicios ",
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Para consultar completar el nombre del Cliente y presione en 'Consultar'",
                style: TextStyle(fontSize: 12),
              ),
              TextField(
                controller: _tfNombredeCliente,
                decoration: InputDecoration(
                    hintText: "Ingrese el Nombre del Cliente",
                    labelText: "Nombre del Cliente"),
              ),
              Text(
                "Se encontraron : " +
                    widget.oListaServicio.length.toString() +
                    " Clientes",
                style: TextStyle(fontSize: 9),
              ),
              new Table(
                children: [
                  TableRow(children: [
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        child: Text(
                          "Consultar",
                          style: TextStyle(fontSize: 14, fontFamily: "rbold"),
                        ),
                        onPressed: _consultarServicios,
                      ),
                    ), //Container 1 -- Fin

                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        child: Text(
                          "Nuevo Servicio",
                          style: TextStyle(fontSize: 14, fontFamily: "rbold"),
                        ),
                        onPressed: _nuevoServicios,
                      ),
                    )
                  ])
                ],
              ),

              //Inicio de la tabla con Json
              JsonTable(
                json,
                showColumnToggle: true,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                paginationRowCount: 11,
                onRowSelect: (index, map) {
                  widget.codigoServicioSelect =
                      int.parse(map["CodigoServicio"].toString());
                  print("demo" + map["CodigoServicio"].toString());

                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext pContexto) {
                    return new NuevoServicio("", widget.codigoServicioSelect);
                  }));

                  _verRegistro();

                  print(index);
                  print(map);
                },
              ),
            ],
          ),
        ));
  }
}
