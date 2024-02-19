import 'package:laskin/napit.dart';
import 'package:flutter/material.dart';

class LaskinRuutu extends StatefulWidget {
  const LaskinRuutu({super.key});

  @override
  State<LaskinRuutu> createState() => _LaskinRuutuState();
}

class _LaskinRuutuState extends State<LaskinRuutu> {
  String numero1 = ""; // ensimmäinen numero
  String operaattori = ""; // matemaattinen operaattori
  String numero2 = ""; // toinen numero

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold( //määritellään laskimen ulkomuotoa
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //numeronäytön asetukset
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$numero1$operaattori$numero2".isEmpty
                        ? "0"
                        : "$numero1$operaattori$numero2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //nappien asetukset näytöllä
            Wrap(
              children: Napit.buttonValues
                  .map(
                    (value) => SizedBox(
                  width: value == Napit.n0
                      ? screenSize.width / 2
                      : (screenSize.width / 4),
                  height: screenSize.width / 5,
                  child: teeNappi(value),
                ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget teeNappi(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: nappienVarit(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => paina(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  void paina(String value) {
    if (value == Napit.del) {
      korjaus();
      return;
    }

    if (value == Napit.clr) {
      tyhjenna();
      return;
    }

    if (value == Napit.prosentti) {
      muutaProsentiksi();
      return;
    }

    if (value == Napit.tulos) {
      laske();
      return;
    }

    lisaaNumero(value);
  }


  void laske() {
    if (numero1.isEmpty) return;
    if (operaattori.isEmpty) return;
    if (numero2.isEmpty) return;

    final double num1 = double.parse(numero1);
    final double num2 = double.parse(numero2);

    var result = 0.0;
    switch (operaattori) {
      case Napit.lisaa:
        result = num1 + num2;
        break;
      case Napit.vahenna:
        result = num1 - num2;
        break;
      case Napit.kerro:
        result = num1 * num2;
        break;
      case Napit.jaa:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      numero1 = result.toStringAsPrecision(3);

      if (numero1.endsWith(".0")) {
        numero1 = numero1.substring(0, numero1.length - 2);
      }

      operaattori = "";
      numero2 = "";
    });
  }

  // muuttaa numeron mateemattiseksi numeroksi esim 100 = 1.0
  void muutaProsentiksi() {

    if (numero1.isNotEmpty && operaattori.isNotEmpty && numero2.isNotEmpty) {

      laske();
    }

    if (operaattori.isNotEmpty) {

      return;
    }

    final number = double.parse(numero1);
    setState(() {
      numero1 = "${(number / 100)}";
      operaattori = "";
      numero2 = "";
    });
  }


  // tyhjentää laskimen näytön
  void tyhjenna() {
    setState(() {
      numero1 = "";
      operaattori = "";
      numero2 = "";
    });
  }


  // poistaa viimeisen numeron
  void korjaus() {
    if (numero2.isNotEmpty) {

      numero2 = numero2.substring(0, numero2.length - 1);
    } else if (operaattori.isNotEmpty) {
      operaattori = "";
    } else if (numero1.isNotEmpty) {
      numero1 = numero1.substring(0, numero1.length - 1);
    }

    setState(() {});
  }


  // lisää numeron operaattorin jälkeen
  void lisaaNumero(String value) {



    if (value != Napit.piste && int.tryParse(value) == null) {

      if (operaattori.isNotEmpty && numero2.isNotEmpty) {

        laske();
      }
      operaattori = value;
    }


    else if (numero1.isEmpty || operaattori.isEmpty) {

      if (value == Napit.piste && numero1.contains(Napit.piste)) return;
      if (value == Napit.piste && (numero1.isEmpty || numero1 == Napit.n0)) {

        value = "0.";
      }
      numero1 += value;
    }

    else if (numero2.isEmpty || operaattori.isNotEmpty) {

      if (value == Napit.piste && numero2.contains(Napit.piste)) return;
      if (value == Napit.piste && (numero2.isEmpty || numero2 == Napit.n0)) {

        value = "0.";
      }
      numero2 += value;
    }

    setState(() {});
  }

  // nappien värien määritys

  Color nappienVarit(value) {
    return [Napit.del, Napit.clr].contains(value)?
    Color.fromARGB(255, 111, 192, 230):
    [
      Napit.prosentti,
      Napit.kerro,
      Napit.lisaa,
      Napit.vahenna,
      Napit.jaa,
      Napit.tulos,
    ].contains(value)?
    Color.fromARGB(255, 27, 86, 149):
    Colors.white;
  }
}