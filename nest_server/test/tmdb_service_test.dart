import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/tmdb_service.dart';
import 'package:test/test.dart';

void main() {
  group('HttpTmdbService.parseTitle', () {
    test('reads a film from search results', () {
      final title = HttpTmdbService.parseTitle({
        'media_type': 'movie',
        'id': 346648,
        'title': 'Paddington 2',
        'release_date': '2017-11-09',
        'poster_path': '/poster.jpg',
        'vote_average': 7.567,
        'vote_count': 3000,
        'overview': ' A bear. ',
      })!;
      expect(title.tmdbId, 346648);
      expect(title.type, WatchType.movie);
      expect(title.title, 'Paddington 2');
      expect(title.year, 2017);
      expect(title.posterPath, '/poster.jpg');
      expect(title.rating, closeTo(7.567, 0.001));
      expect(title.overview, 'A bear.');
    });

    test('reads a series by its name and first air date', () {
      final title = HttpTmdbService.parseTitle({
        'media_type': 'tv',
        'id': 82728,
        'name': 'Bluey',
        'first_air_date': '2018-10-01',
        'vote_average': 8,
        'vote_count': 10,
      })!;
      expect(title.type, WatchType.series);
      expect(title.title, 'Bluey');
      expect(title.year, 2018);
      expect(title.rating, 8.0);
      expect(title.posterPath, isNull);
    });

    test('details pass their kind', () {
      final title = HttpTmdbService.parseTitle({
        'id': 1,
        'name': 'Ted Lasso',
        'first_air_date': '',
        'vote_average': 0,
        'vote_count': 0,
      }, type: WatchType.series)!;
      expect(title.year, isNull);
      expect(title.rating, isNull);
    });

    test('people and untitled results are left out', () {
      expect(
        HttpTmdbService.parseTitle({
          'media_type': 'person',
          'id': 2,
          'name': 'Someone',
        }),
        isNull,
      );
      expect(
        HttpTmdbService.parseTitle({'media_type': 'movie', 'id': 3}),
        isNull,
      );
    });
  });
}
