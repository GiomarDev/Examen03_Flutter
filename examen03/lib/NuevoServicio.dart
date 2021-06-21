import 'dart:convert';
import 'package:json_table/json_table.dart';
import 'package:examen03/ServicioObject.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' show Future;

class NuevoServicio extends StatefulWidget {
  String titulo;
  ServicioObejct oServicio = ServicioObejct();
  int codigoServicioSelect = 0;

  //Codigos para el Web API
  String url = "http://wscibertec2021.somee.com";
  String urlController = "/Servicio";
  String urlListado = "Listar?NombreCliente=";
  String urlRegistraModifica = "/RegistraModifica?";

  String mensaje = "";
  bool validacion = false;
  NuevoServicio(this.titulo, this.codigoServicioSelect);

  @override
  _NuevoServicio createState() => _NuevoServicio();
}

class _NuevoServicio extends State<NuevoServicio> {
  final _tfNombreCliente = TextEditingController();
  final _tfNumeroOrdenServicio = TextEditingController();
  final _tfFechaProgramada = TextEditingController();
  final _tfLinea = TextEditingController();
  final _tfEstado = TextEditingController();
  final _tfObservaciones = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    if (widget.codigoServicioSelect > 0) {
      //ListaKey
    }
  }

  void _grabarRegistro() {
    _ejecutarServicioGrabar();
  }

  Future<String> _ejecutarServicioGrabar() async {
    String accion = "Accion=N&";

    String strParams = "";
    strParams +=
        "&CodigoServicio=" + widget.oServicio.CodigoServicio.toString();
    strParams += "&NombreCliente=" + _tfNombreCliente.text;
    strParams += "&NumeroOrdenServicio=" + _tfNumeroOrdenServicio.text;
    strParams += "&FechaProgramada=" + _tfFechaProgramada.text;
    strParams += "&Linea=" + _tfLinea.text;
    strParams += "&Estado=" + _tfEstado.text;
    strParams += "&Observaciones=" + _tfObservaciones.text;

    String urlRegistroServicios = "";
    urlRegistroServicios = widget.url +
        widget.urlController +
        widget.urlRegistraModifica +
        accion +
        strParams;

    Uri urlFinalRegistrar = Uri.parse(urlRegistroServicios);
    var response = await http.get(urlFinalRegistrar);
    var data = response.body;

    setState(() {
      widget.oServicio = ServicioObejct.fromJson(json.decode(data));
      if (widget.oServicio.CodigoServicio > 0) {
        widget.mensaje = "Grabado Correctamente";
      }
      if (widget.oServicio.CodigoError == 2) {
        widget.mensaje = "Ya existe un registro con los mismos datos";
      }
      if (widget.oServicio.CodigoError > 2) {
        widget.mensaje = "Ocurrio un error Inesperado.";
      }

      print(widget.oServicio);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro de Servicios " + widget.titulo),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: null),
          ],
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(" Código de Servicio:" +
                  widget.oServicio.CodigoServicio.toString()),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _tfNombreCliente,
                      decoration: InputDecoration(
                        hintText: "Ingrese  la razón social ",
                        labelText: "Razón Social",
                        errorText: _tfNombreCliente.text.toString() == ""
                            ? "Falta ingresar la razón Social"
                            : null,
                      )),
                  TextField(
                      controller: _tfNumeroOrdenServicio,
                      decoration: InputDecoration(
                        hintText: "Ingresar el NumeroOrdenServicio ",
                        labelText: "Numero de Orden Servicio",
                        errorText: _tfNumeroOrdenServicio.text.toString() == ""
                            ? "Falta ingresar el NumeroOrdenServicio"
                            : null,
                      )),
                  TextField(
                      controller: _tfFechaProgramada,
                      decoration: InputDecoration(
                        hintText: "Ingresar la dirección",
                        labelText: "Dirección",
                      )),
                  TextField(
                      controller: _tfLinea,
                      decoration: InputDecoration(
                        hintText: "Ingresar el Linea",
                        labelText: "Linea",
                      )),
                  TextField(
                      controller: _tfObservaciones,
                      decoration: InputDecoration(
                        hintText: "Ingresar el Observaciones",
                        labelText: "Observaciones",
                      )),
                  TextField(
                      controller: _tfEstado,
                      decoration: InputDecoration(
                        hintText: "Ingresar el Estado",
                        labelText: "Estado",
                      )),
                  RaisedButton(
                    color: Colors.greenAccent,
                    child: Text(
                      "Grabar",
                      style: TextStyle(fontSize: 18, fontFamily: "rbold"),
                    ),
                    onPressed: _grabarRegistro,
                  ),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
