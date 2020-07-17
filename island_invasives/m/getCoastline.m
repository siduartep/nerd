function [cumCoastlineX,cumCoastlineY]=getCoastline(S,utmZone)
cumCl=[];
cumCoastlineX=[];
cumCoastlineY=[];
for i=1:length(S.CoastlineFiles)
    CoastlineFile=S.CoastlineFiles{i};
    %%% Reading files
    Cl = shaperead(CoastlineFile);
    %%% Add fields Lat Lon to structure
    %%% Calculating geographic coordinates
    coastlineX=[Cl(:).X]';
    coastlineY=[Cl(:).Y]';
    [Lat,Lon] = utm2deg(coastlineX,coastlineY,repmat(utmZone,length(coastlineX),1));
    coastlineGeometry=Cl(1).Geometry;
    try % points
        Lat = num2cell(Lat(:));
        Lon = num2cell(Lon(:));
        [Cl(:).Lat]=Lat{:};
        [Cl(:).Lon]=Lon{:};
    catch
        try % polygons
            Cl.Lat=Lat;
            Cl.Lon=Lon;
        catch % otherwise
            error([CoastlineFile ' is not a valid coastline file'])
        end 
    end
    
    %%% Storing coastline
    if ~isempty(cumCl)
        if strcmpi(coastlineGeometry,cumCl(1).Geometry)
            cumCl=[cumCl(:);Cl(:)];
        end
    end
    cumCoastlineX=[cumCoastlineX;coastlineX;coastlineX(1);NaN];
    cumCoastlineY=[cumCoastlineY;coastlineY;coastlineY(1);NaN];
end