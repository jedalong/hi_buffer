library('move')
library('sf')
library('osmdata')
library('ggplot2')
library('units')
library('mapview')
library('wildlifeHI') #github('jedalong/wildlifeHI')

## The parameter "data" is reserved for the data object passed on from the previous app

## to display messages to the user in the log file of the App in MoveApps one can use the function from the logger.R file: 
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

rFunction = function(data, r, key, value, geom, poly2line, crs_code) {
  
  #check input data type
  if (class(data) != 'MoveStack'){
    if (class(data) == 'Move'){
      data <- moveStack(data, forceTz='UTC')
    } else {
      print('Input Data not of class MoveStack. Returning null object.')
      return(NULL)
    }
  }
  
  if (crs_code == 0){
    crs_code <- st_crs(data)
  }
  
  if (value == 'all'){
    osm_temp <- hi_get_osm(move=data,key=key,geom=geom,poly2line=poly2line)
  } else {
    osm_temp <- hi_get_osm(move=data,key=key,value=value,geom=geom,poly2line=poly2line)
  }
  
  #use hidden return='all' to keep the line segments for plotting
  list_x <- hi_buffer(data,r=r,osmdata=osm_temp,crs_code=crs_code,return='all')
  move_x <- list_x[[1]]
  sf_x <- list_x[[2]]
  buf_x <- list_x[[3]]
  
  
  #Buffer type Table
  x_tab <- table(trackId(move_x), move_x$buf_code)
  csvName <- paste0('Table_BufferMovementType_r_',r,'.csv')
  write.csv(x_tab,appArtifactPath(csvName),row.names=TRUE)
  
  #buffer Shapefile
  shpName <- paste0('Shapefile_buffer_r_',r,'.shp')
  suppressWarnings(st_write(buf_x,appArtifactPath(shpName)))
  
  #Lines Shapefile
  shpName <- paste0('Shapefile_trajectory_r_',r,'.shp')
  suppressWarnings(st_write(sf_x,appArtifactPath(shpName)))
  
  #Buffer Map
  m <- mapview(buf_x) + mapview(sf_x['buf_code'])
  htmlName <- paste0('Map_Buffer_r_',r,'.html')
  mapshot(m,url=appArtifactPath(htmlName))
  
  #return move
  return(move_x)
  
}
