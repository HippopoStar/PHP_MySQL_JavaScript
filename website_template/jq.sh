#!/bin/sh

# L'idee c'est de recuperer les arcs correspondant aux pays frontaliers,
# puis de les ajouter au fichier decrivant la geographie de la France

# Etant donne que les arcs correspondant aux frontieres entre la France et
# les pays voisins sont mutualises dans la carte representant le monde
# (pour les frontieres, 1 arc est defini, utilise par la geometrie des 2 pays),
# il doit etre possible de remplacer l'arc de cette frontiere par les arcs
# des frontieres du pays voisin avec les departements frontaliers

# Structures JSON :

################################################################################
#                                                                              #
#                                   FRANCE                                     #
#                                                                              #
################################################################################

# {
#	"transform" : {
#		"scale" : [
#			0.0117664110161016,
#			0.00724655695994403
#		],
#		"translate" : [
#			-61.7978409499999,
#			-21.3707821589999
#		]
#	},
#	"objects" : {
#		"fra" : {
#			"type" : "GeometryCollection",
#			"geometries" : [
#				[...]
#				{
#				"properties" : {
#					"name" : "Côtes-d'Armor"
#				},
#				"type" : "Polygon",
#				"id" : "FR.CA",
#				"arcs" : [
#					[
#						122,										22 / 35
#						123,										22 / 56
#						124,										22 / 29
#						125
#					]
#				]
#				},
#				{
#					"type" : "MultiPolygon",
#					"properties" : {
#						"name" : "Finistère"
#					},
#					"arcs" : [
#						[
#							[
#								162
#							]
#						],
#						[
#							[
#								-125,								29 / 22
#								163,								29 / 56
#								164
#							]
#						]
#					],
#					"id" : "FR.FI"
#				},
#				{
#					"properties" : {
#						"name" : "Ille-et-Vilaine"
#					},
#					"type" : "Polygon",
#					"id" : "FR.IV",
#					"arcs" : [
#						[
#							215,
#							216,
#							217,
#							218,
#							219,									35 / 56
#							-123,									35 / 22
#							220
#						]
#					]
#				},
#				{
#					"type" : "MultiPolygon",
#					"properties" : {
#						"name" : "Morbihan"
#					},
#					"arcs" : [
#						[
#							[
#								269									Belle-Ile
#							]
#						],
#						[
#							[
#								-220,								56 / 35
#								-245,								Loire-Atlant
#								270,								Ocean Atlant
#								-164,								56 / 29
#								-124								56 / 22
#							]
#						]
#					],
#					"id" : "FR.MB"
#				},
#				[...]
#			]
#		}
#	}
#	"type" : "Topology",
#	"arcs" : [
#		[
#			[
#				<longitude>,
#				<latitude>
#			],
#			[
#				<deplacement_est_ouest_01>,
#				<deplacement_nord_sud_01>
#			],
#			[
#				<deplacement_est_ouest_02>,
#				<deplacement_nord_sud_02>
#			],
#			[...]
#		],
#		[...]
#	]
# }


################################################################################
#                                                                              #
#                                   WORLD                                      #
#                                                                              #
################################################################################

# {
#	"type": "Topology",
#	"objects": {
#		"world": {
#			"type": "GeometryCollection",
#			"geometries": [
#				{
#					"type": "Polygon",
#					"properties": {
#						"name": "Belgium"
#					},
#					"id": "BEL",
#					"arcs": [
#						[62, 63, 64, 65, 66]
#					]
#				},
#				{
#					"type": "Polygon",
#					"properties": {
#						"name": "Switzerland"
#					},
#					"id": "CHE",
#					"arcs": [
#						[-51, 161, 162, 163]
#					]
#				},
#				{
#					"type": "Polygon",
#					"properties": {
#						"name": "Germany"
#					},
#					"id": "DEU",
#					"arcs": [
#						[222, 223, -220, -52, -164, 224, 225, -64, 226, 227, 228]
#					]
#				},
#				{
#					"type": "Polygon",
#					"properties": {
#						"name": "Spain"
#					},
#					"id": "ESP",
#					"arcs": [
#						[255, 256, 257, 258]
#					]
#				},
#				{
#					"type": "MultiPolygon",
#					"properties": {
#						"name": "France"
#					},
#					"id": "FRA",
#					"arcs": [
#						[
#							[277]
#						],
#						[
#							[278, -225, -163, 279, 280, -257, 281, -66]
#						]
#					]
#				},
#				{
#					"type": "MultiPolygon",
#					"properties": {
#						"name": "United Kingdom"
#					},
#					"id": "GBR",
#					"arcs": [
#						[
#							[288, 289]
#						],
#						[
#							[290]
#						]
#					]
#				},
#				{
#					"type": "MultiPolygon",
#					"properties": {
#						"name": "Italy"
#					},
#					"id": "ITA",
#					"arcs": [
#						[
#							[375]
#						],
#						[
#							[376]
#						],
#						[
#							[377, 378, -280, -162, -50]
#						]
#					]
#				},
#				{
#					"type": "Polygon",
#					"properties": {
#						"name": "Luxembourg"
#					},
#					"id": "LUX",
#					"arcs": [
#						[-226, -279, -65]
#					]
#				},
#				[...]
#			]
#		}
#	}
#	"arcs": [
#		[...]
#	],
#	"transform": {
#		"scale": [0.036003600360036005, 0.016927109510951093],
#		"translate": [-180, -85.609038]
#	}
# }

jq '(.["objects"]["world"]["geometries"][] | select(.["properties"]["name"] == "Belgium") | .["arcs"][] | flatten(1)) as $x | $x[0] as $first | ($x | last) as $last | .["arcs"][$first:$last+1]' htdocs/json/world.topo.json
