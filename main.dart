import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//untuk terhubung dengan API TMDb dengan APIkey
class TMDbApi {
  final String apiKey;
  TMDbApi(this.apiKey);

//fungsi utk cari film berdasarkan judul, nah disini pake async
  Future<List<dynamic>> searchMovie(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'));

//logic responnya berhasil atau tidak
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      print('Gagal Memuat Film: ${response.statusCode}');
      return [];
    }
  }

//menampilkan detail film yang terhubung dgn API TMDb berdasarkan id
  Future<Map<String, dynamic>> getMovieDetails(int id) async {
    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/$id?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Gagal Memuat Detail Film: ${response.statusCode}');
      return {};
    }
  }
}

//fungsi utk running program
Future<void> main() async {
  final String apiKey =
      '90616499d93439fd8b365dcf84aa3ee3'; //ini API Key yg saya daftar di TMDb
  final TMDbApi tmdbApi = TMDbApi(apiKey);

  print('Masukkan Judul Film Yang Ingin Anda Cari:');
  String? searchQuery = stdin.readLineSync();
  if (searchQuery != null && searchQuery.isNotEmpty) {
    try {
      var searchResults = await tmdbApi.searchMovie(searchQuery);
      print('Hasil Pencarian:');

      //logic utk menapilkan hasil pencarian
      for (var movie in searchResults) {
        print('Judul: ${movie['title']} (ID: ${movie['id']})');
      }
      if (searchResults.isNotEmpty) {
        int movieId = searchResults[0]['id'];
        var movieDetails = await tmdbApi.getMovieDetails(movieId);

        //format daftar film
        print('Detail Film:');
        print('Judul: ${movieDetails['title']}');
        print('Tahun Rilis: ${movieDetails['release_date']}');
        print('Rating: ${movieDetails['vote_average']}');
        print('Sinopsis: ${movieDetails['overview']}');
      }
      //utk catch error/kesalahan
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  } else {
    print('Judul Film Tidak Boleh Kosong.');
  }
}
