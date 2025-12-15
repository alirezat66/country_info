import 'package:country_info/features/country/domain/entities/country.dart';

extension CountryMapperExt on Country {
  Map<String, String> get basicFields => {
    'Flag': emoji,
    'Name': name,
    'Code': code,
    'Capital': capital ?? '',
  };

  Map<String, String> get extendedFields => {
    'Currency': currency ?? 'NA',
    'Phone': phone ?? 'AN',
    'Continent Code': continent?.code ?? 'NA',
    if (continent != null) 'Continent Name': continent!.name,
    if (languages.isNotEmpty)
      'Languages': languages.map((language) => language.name).join(', '),
  };

  List<MapEntry<String, String>> toDetailFields({required bool showMore}) {
    final fields = <MapEntry<String, String>>[
      MapEntry('Flag', emoji),
      MapEntry('Name', name),
      MapEntry('Code', code),
      MapEntry('Capital', capital ?? ''),
    ];

    if (showMore) {
      fields.addAll([
        MapEntry('Currency', currency ?? ''),
        MapEntry('Phone', phone ?? ''),
        if (continent != null) ...[
          MapEntry('Continent Code', continent!.code),
          MapEntry('Continent Name', continent!.name),
        ],
        if (languages.isNotEmpty)
          MapEntry(
            'Languages',
            languages.map((language) => language.name).join(', '),
          ),
      ]);
    }

    return fields;
  }
}
