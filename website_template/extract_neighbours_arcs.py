#!/usr/bin/python3

import json

# https://docs.python.org/3/library/functions.html#print
# https://docs.python.org/3/library/stdtypes.html#str.format

fra_topo_json_file_path='htdocs/json/fra.topo.json'
world_topo_json_file_path='htdocs/json/world.topo.json'

context = {
  'reference_country': 'FRA',
  'neighbour_countries': [
    'AUT',
    'BEL',
    'CHE',
    'CZE',
    'DEU',
    'ESP',
    'GBR',
    'IRL',
    'ITA',
    'LUX',
    'NLD',
    'PRT'
  ],
  'arcs': []
}

def get_country_arcs(country_id):
  arcs = []
  print('country_id: {}; type {}'.format(country_id, context[country_id]['summary']['type']))
  if context[country_id]['summary']['type'] == 'MultiPolygon':
    for area_list in context[country_id]['summary']['arcs']:
      for area in area_list:
        for segment in area:
          arcs.append(segment)
  elif context[country_id]['summary']['type'] == 'Polygon':
    for area in context[country_id]['summary']['arcs']:
      for segment in area:
        arcs.append(segment)
  else:
    print('Unknown field type')
  return arcs

def is_segment_part_of_reference_country(segment):
  for reference_segment in context[context['reference_country']]['arcs']:
    if reference_segment == segment or (reference_segment + 1) == -segment:
      print('Shared segment (frontier) with reference country detected! (segment: {})'.format(segment))
      return True
  return False

def is_segment_part_of_another_neighbour_country(neighbour_id, segment):
  for country_id in context['neighbour_countries']:
    if not country_id == neighbour_id:
      for another_segment in context[country_id]['arcs']:
        #if another_segment == segment or (another_segment + 1) == -segment:
        if (another_segment + 1) == -segment:
          print('Shared segment (frontier) with another country detected! ({})'.format(country_id))
          return True
  return False

def get_arcs(topo_json):
  #print(json.dumps(topo_json))
  #print(json.dumps(context, indent=4))

  context[context['reference_country']] = {}
  for country_id in context['neighbour_countries']:
    context[country_id] = {}

  country_found_witness = False
  for country_summary in topo_json['objects']['world']['geometries']:
    if country_summary['id'] == context['reference_country']:
      print('country_id {} found!'.format(context['reference_country']))
      context[context['reference_country']]['summary'] = country_summary
      country_found_witness = True
      break
  if country_found_witness == False:
    print('country_id {} NOT found!'.format(context['reference_country']))
  print(json.dumps(context, indent=4))

  for country_id in context['neighbour_countries']:
    country_found_witness = False
    for country_summary in topo_json['objects']['world']['geometries']:
      if country_summary['id'] == country_id:
        print('country_id {} found!'.format(country_id))
        context[country_id]['summary'] = country_summary
        country_found_witness = True
        break
    if country_found_witness == False:
      print('country_id {} NOT found!'.format(country_id))
  #print(json.dumps(context, indent=4))

  context[context['reference_country']]['arcs'] = get_country_arcs(context['reference_country'])
  for country_id in context['neighbour_countries']:
    context[country_id]['arcs'] = get_country_arcs(country_id)

  for country_id in context['neighbour_countries']:
    print('Appending segments from country: {}'.format(country_id))
    for segment in context[country_id]['arcs']:
      print (segment)
      if not is_segment_part_of_reference_country(segment):
        if segment >= 0 or (segment < 0 and not is_segment_part_of_another_neighbour_country(country_id, segment)):
          context['arcs'].append(topo_json['arcs'][segment if segment >= 0 else (-segment)])
  #print(json.dumps(context['arcs'], indent=4))

  datamaps_arc = {
    'origin': {
      'longitude': 0,
      'latitude': 0
    },
    'destination': {
      'longitude': 0,
      'latitude': 0
    }
  }
  for segment in context['arcs']:
    coord_orig = segment[0]
    coord_dest = [0, 0]
    for i in range(1, len(segment)):
      coord_dest[0] = coord_orig[0]
      coord_dest[1] = coord_orig[1]
      coord_dest[0] = coord_dest[0] + segment[i][0]
      coord_dest[1] = coord_dest[1] + segment[i][1]
      datamaps_arc['origin']['longitude'] = (coord_orig[0] * topo_json['transform']['scale'][0]) + topo_json['transform']['translate'][0]
      datamaps_arc['origin']['latitude'] = (coord_orig[1] * topo_json['transform']['scale'][1]) + topo_json['transform']['translate'][1]
      datamaps_arc['destination']['longitude'] = (coord_dest[0] * topo_json['transform']['scale'][0]) + topo_json['transform']['translate'][0]
      datamaps_arc['destination']['latitude'] = (coord_dest[1] * topo_json['transform']['scale'][1]) + topo_json['transform']['translate'][1]
      coord_orig[0] = coord_dest[0]
      coord_orig[1] = coord_dest[1]
      #print('{}{}'.format(datamaps_arc, ','))
      print("\t\t\t\t\t\t\t\t{'origin':{'longitude':%.5f,'latitude':%.5f},'destination':{'longitude':%.5f,'latitude':%.5f}},"%(datamaps_arc['origin']['longitude'], datamaps_arc['origin']['latitude'], datamaps_arc['destination']['longitude'], datamaps_arc['destination']['latitude']))


try:
  with open(world_topo_json_file_path, 'r') as json_file_world:
    try:
      json_world = json.load(json_file_world)
      get_arcs(json_world)
    except JSONDecodeError:
      print('An error occured while attempting to parse json')
    finally:
      json_file_world.close()
except IOError:
  print('An error occured while attempting to open file {}'.format(world_topo_json_file_path))
