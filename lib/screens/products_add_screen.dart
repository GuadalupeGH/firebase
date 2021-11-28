import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase/screens/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class ProductsAddScreen extends StatefulWidget {
  ProductsAddScreen({Key? key}) : super(key: key);

  @override
  _ProductsAddScreenState createState() => _ProductsAddScreenState();
}

class _ProductsAddScreenState extends State<ProductsAddScreen> {
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerDescripcion = TextEditingController();

  File? image;
  final picker = ImagePicker();
  ProductDAO? productDAO;
  late FirebaseProvider _firebaseProvider;
  var picketFile;
  UploadTask? task;
  var carga = false;

  bool bandera1 = false;
  bool bandera2 = false;
  // late String urlImage;

  Future selectImage(opcion) async {
    try {
      if (opcion == 1) {
        picketFile = await picker.pickImage(source: ImageSource.camera);
      } else {
        picketFile = await picker.pickImage(source: ImageSource.gallery);
      }

      setState(() {
        if (picketFile != null) {
          this.image = File(picketFile.path);
        } else {
          print('Error');
        }
      });
    } catch (e) {
      print('foto error');
    }
  }

  String nombre() {
    var arreglo = [
      'q',
      'w',
      'e',
      'r',
      't',
      'y',
      'u',
      'i',
      'o',
      'p',
      'a',
      's',
      'd',
      'f',
      'g',
      'h',
      'j',
      'k',
      'l',
      'z',
      'x',
      'c',
      'v',
      'b',
      'n',
      'm',
      '?',
      '%',
      '&'
    ];
    Random random = new Random();
    var nombre = '';
    for (int a = 0; a < 10; a++) {
      nombre += arreglo.elementAt(random.nextInt(arreglo.length));
    }

    return nombre;
  }

  uploadImage() async {
    var clave, descripcion, avatar;
    clave = _controllerNombre.text;
    descripcion = _controllerDescripcion.text;
    setState(() {
      carga = true;
    });
    var aleatorio = nombre();
    var imageFile =
        FirebaseStorage.instance.ref().child('productos/$clave$aleatorio');
    UploadTask task = imageFile.putFile(image!);
    var imageurl = await (await task).ref.getDownloadURL();
    String urlImage = imageurl.toString();
    //----------

    try {
      if (image != null) {
        avatar = image?.path;
      } else {
        avatar = '';
      }
      productDAO =
          ProductDAO(cveprod: clave, descpro: descripcion, imgpro: urlImage);
      _firebaseProvider.saveProduct(productDAO!).then((result) {
        print('si se hizo');
      });
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
      this.bandera1 = false;
      this.bandera2 = false;
    } catch (Exception) {
      print(Exception);
    }
  }

  //implementar metodo antes de que se muestra la interfaz
  @override
  void initState() {
    _firebaseProvider = FirebaseProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget alerta() {
      return AlertDialog(
        title: Text('Error'),
        content: Text("Seleccionar una foto"),
        actions: <Widget>[
          ElevatedButton(
              child: Text("Aceptar"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(196, 91, 80, 1)),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    }

    Future<void> mostAlerta(BuildContext context) async {
      return showDialog<void>(
        barrierDismissible: false, //solo se cierra al presionar aceptar
        context: context,
        builder: (_) => alerta(),
      );
    }

    double screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: 45, left: 20, right: 20),
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home');
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                      color: Colors.grey,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0),
                        width: screenWidht,
                        child: Text(
                          'Nuevo Producto',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            //poner una sombra
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.black26,
                                  offset: Offset(0, 20))
                            ]),
                        child: ClipOval(
                          child: (image == null || image!.path == '')
                              ? Image.asset(
                                  './assets/producto.png',
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  image!,
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 0,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromRGBO(196, 91, 80, 1),
                          child: IconButton(
                            padding: EdgeInsets.all(5),
                            icon: Icon(
                              Icons.photo,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Foto del producto'),
                                      actions: [
                                        Column(
                                          children: [
                                            Container(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Color.fromRGBO(
                                                                    196,
                                                                    91,
                                                                    80,
                                                                    1)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      selectImage(2);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(Icons.image),
                                                        Text('Galería')
                                                      ],
                                                    ))),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                        // ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextField(
                        controller: _controllerNombre,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFe5e5e5),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          errorText: bandera1 ? 'Campo obligatorio' : null,
                          labelText: "Producto",
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                        // maxLength: 100,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextField(
                        maxLines: 6,
                        controller: _controllerDescripcion,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFe5e5e5),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          errorText: bandera2 ? 'Campo obligatorio' : null,
                          labelText: "Descripción",
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                          // border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                        // maxLength: 200,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (picketFile != null) {
                              if (_controllerNombre.text.isEmpty) {
                                bandera1 = true;
                              } else {
                                if (_controllerDescripcion.text.isEmpty) {
                                  bandera2 = true;
                                } else {
                                  try {
                                    uploadImage();
                                  } catch (Exception) {}
                                }
                              }
                            } else {
                              mostAlerta(this.context);
                              print('No se eligio foto');
                            }
                          });
                        },
                        child: Text(
                          "Guardar",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(196, 91, 80, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Center(
            child: carga == true
                ? Container(
                    child: Center(
                        child: Container(
                      child: CircularProgressIndicator(),
                      width: 40,
                      height: 40,
                    )),
                    color: Color.fromRGBO(0, 0, 0, .2),
                    width: double.infinity,
                    height: double.infinity)
                : Container(),
          )
        ],
      ),
    );
  }
}
