# HI Buffer Analysis

hi_buffer

Github repository: github.com/jedalong/hi_buffer

## Description
This app facilitates buffer analysis of features in Open Street Map (OSM).

## Documentation
This app computes where tracking data segments (i.e., pairs of consecutive tracking points) are within or cross a buffer (specified by distance r, which is an input parameter) around OSM features. Specifically, it identifies where tracking segments are within (or not within) a specified buffer, and where they enter, exit, and cross buffered features.

The OSM key, which is essentially a class of features in OSM, can be specified as an input variable. The default is to use the 'highway' key which includes roads, trails, etc.

The OSM value, which is essentially the typology of features within a given OSM key, can also be specified as an input variable. The default is to use all of the values in a given key, but single values can be specified for more targeted analysis.

The geom argument can be used to focus on a specific geometry type: one of 'point', 'line' (the default), or 'polygon'. The poly2line argument is used to convert polygon features to lines, useful when studying movement-around-boundary problems.

The back-end tools used for geoprocessing buffers work more efficiently with projected geographical data. Therefore, the crs_code parameter can be used to pass in a projected coordinate system which is then used for all geoprocessing tasks.


### Input data

MoveStack in Movebank format

### Output data

MoveStack in Movebank format with one additional columns, named buf_code, with the following codes:

- within: movement completely within buffer
- enter: moved from outside to inside of buffer
- exit: moved from inside to outside of buffer
- cross_in: movement starts and ends inside buffer, but crosses outside of buffer
- cross_out: movement starts and ends outside buffer, but crosses inside of buffer
- NA: movement outside of buffer

### Artefacts

`Table_BufferMovementType_r_*.csv`: A csv file with a table of the number of movement events associated with each buffer movement type (see above) per individual. 
`Shapfile_buffer_r_*.shp`: A shapefile with the buffer of the OSM data with distance r (also has .shx,.dbf.prj files)
`Shapfile_trajectory_r_*.shp`: A shapefile with the movement segments stored as lines (also has .shx,.dbf.prj files)
`Map_Buffer_r_*.html`: An interactive map widget of the OSM feature buffer and movement trajectory lines derived from R package mapview. Includes a corresponding data folder.

### Settings 

`r`: (integer) buffer distance, in appropriate units. 

`key`: (string) OSM key class, as a string. Default is 'highway'. For more information see the (OSM Wiki Page)[ https://wiki.openstreetmap.org/wiki/Tags#Keys_and_values].

`value`: (string) OSM value tag, as a string. Default is to use all values for a specified key, but the user can choose specific value tags for more targeted analysis. For more information see the (OSM Wiki Page)[ https://wiki.openstreetmap.org/wiki/Tags#Keys_and_values].

`geom`: (string) geometry type to focus on, one of ('point', 'line', 'polygon'). Default is 'line'.

`poly2line`: (logical) used to convert polygon features to lines, useful when studying movement-around-boundary problems. Default is TRUE.

`crs_code`: (integer) With crossing analysis it is strongly recommended that the data be converted into a PROJECTED coordinate reference system (e.g., UTM Zone, national grid, etc.). CRS codes (also known as EPSG codes) are integer numbers that correspond to a specified Spatial Coordinate Reference System. A searchable website for identifying the CRS code associated with a given reference system is: https://spatialreference.org.

### Most common errors

- specified key/value is not present (check spelling of key and value settings)
- OSM data (for chosen key/value) not present in study area (overlay GPS data on OSM to check)
- Study area is too large (try to make study area or OSM query smaller)
- crs_code not specified, resulting in very slow processing times

### Null or error handling

***Input MoveStack:** If input data is of class: "Move", it is automatically converted to a "MoveStack". If it is another type of object the function returns NULL. 
