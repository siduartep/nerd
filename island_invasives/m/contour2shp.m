function [Out, h]=contour2shp(X,Y,Z,v,graficar)
if nargin<5
    graficar=false;
end
v=v(:);
epsilon=.1;
if any(v<=0)
    v=[v;epsilon];
end
v=v(0<v&v<max(Z(:)));
v=[v(:);ceil(max(Z(:)))];
v=unique(v);
[C,h] = contourf(X,Y,Z,v);
if ~graficar
    set(h,'visible','off');
end
for j=1:length(v)-1
    minLevel=v(j);
    maxLevel=v(j+1);
    indLevel = 1;
    i = 1;
    cstruct = struct('level', {}, 'x', {}, 'y', {});
    while indLevel <= size(C,2)
        n = C(2,indLevel);
        cstruct(i).x = C(1,indLevel+(1:n));
        cstruct(i).y = C(2,indLevel+(1:n));
        cstruct(i).level = C(1,indLevel);
        i = i+1;
        indLevel = indLevel+n+1;
    end
    x=[];
    y=[];
    indMinLevel=find([cstruct.level]==minLevel);
    for i=indMinLevel
        x1=cstruct(i).x;
        y1=cstruct(i).y;
        [x2, y2] = poly2cw(x1, y1);
        x=[x NaN x2];
        y=[y NaN y2];
    end
    indMaxLevel=find([cstruct.level]==maxLevel);
    for i=indMaxLevel
        x1=cstruct(i).x;
        y1=cstruct(i).y;
        [x2, y2] = poly2ccw(x1, y1);
        x=[x NaN x2];
        y=[y NaN y2];
    end
    Out(j).Geometry='Polygon';
    Out(j).BoundingBox=[min(x) min(y);max(x) max(y)];
    Out(j).X=x;
    Out(j).Y=y;
    if minLevel==epsilon
        minLevel=0;
    end
    Out(j).Density = [num2str(minLevel) ' - ' num2str(maxLevel)];
end

