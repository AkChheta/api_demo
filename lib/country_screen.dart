import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryScreen extends StatelessWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Api().getCountry(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              List<CountryModel>? countries = snapshot.data;
              return ListView.builder(
                itemCount: countries!.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return ListTile(
                    title: Text(country.country.toString()),
                    subtitle: Text('Population: ${country.region}'),
                    leading: Text(country.code.toString()),
                  );
                },
              );
            }
          }),
    );
  }
}

class Api {
  Future<List<CountryModel>> getCountry() async {
    var url = Uri.parse('https://api.first.org/data/v1/countries');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = await json.decode(response.body);
        Map<String, dynamic> countries = await data['data'];
        List<CountryModel> countryModelList = [];

        countries.values.forEach((element) {
          var data = CountryModel(
              country: element['country'], region: element['region']);
          countryModelList.add(data);
        });
        countries.keys.forEach((element) {
          for (int i = 0; i < countries.length; i++) {
            countryModelList[i].code = element;
          }
        });

        return countryModelList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("E:::::::::::::::::::::${e}");
    }
    return [];
  }
}

class CountryModel {
  String? country;
  String? region;
  String? code;
  CountryModel({this.country, this.region, this.code});
}
