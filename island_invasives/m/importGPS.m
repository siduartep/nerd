function S=importGPS(filename,graficar)
if nargin<2
    graficar=false;
end
log = shaperead(filename);
if graficar
    figure
    hold on
    axis equal
end
N=0;
for j=1:length(log)
    [X,Y,utmZone] = wgs2utm(log(j).Y(1:end-1)',log(j).X(1:end-1)');
    n=length(X);
    esEsquina=false(n,1);
    for i=1:n-2
        a=[X(i+1)-X(i)  ,Y(i+1)-Y(i)];
        b=[X(i+2)-X(i+1),Y(i+2)-Y(i+1)];
        if acos((dot(a,b))/(norm(a)*norm(b)))>3*pi/8
            esEsquina(i)=true;
        end
    end
    k=find(diff(esEsquina)==-1,1,'last');
    if graficar
        fill(X,Y,rand(1,3))
        plot(X(2:k),Y(2:k),'go')
        plot(X(k+1:n),Y(k+1:n),'ro')
    end
    d1=0;
    for i=2:k-1
        d=norm([X(i+1)-X(i),Y(i+1)-Y(i)]);
        d1(end+1)=d1(end)+d;
        if graficar
            text(mean([X(i+1),X(i)]),mean([Y(i+1),Y(i)]),num2str(d))
        end
    end
    d2=0;
    for i=k+1:n-1
        d=norm([X(i+1)-X(i),Y(i+1)-Y(i)]);
        d2(end+1)=d2(end)+d;
        if graficar
            text(mean([X(i+1),X(i)]),mean([Y(i+1),Y(i)]),num2str(d))
        end
    end
    n2=ceil(max([d1 d2])/20);
    w1=linspace(0,max(d1),n2);
    x1=interp1(d1,X(2:k),w1);
    y1=interp1(d1,Y(2:k),w1);
    w2=linspace(0,max(d2),n2);
    x2=interp1(d2,X(k+1:n),w2);
    y2=interp1(d2,Y(k+1:n),w2);
    x2=x2(end:-1:1);
    y2=y2(end:-1:1);
    x=mean([x1;x2]);
    y=mean([y1;y2]);
    if graficar
        plot(x1,y1,'g.')
        plot(x2,y2,'r.')
        plot(x,y,'b.-')
    end
    d=sqrt(diff(x).^2+diff(y).^2);
    d(end+1)=d(end);
    d=cumsum(d);
    t=d/(log(j).Speed*0.514444)/(24*60*60)+datenum(log(j).Time,'yyyy-mm-ddTHH:MM:SS-06:00');
    utmZone=utmzone(log(j).Y(1),log(j).X(1));
    utmZone(3:4)=[' ' utmZone(end)];
    [Lat,Lon] = utm2deg(x,y,repmat(utmZone,length(x),1));
    for i=1:n2
        [S(N+i).X]=x(i);
        [S(N+i).Y]=y(i);
        [S(N+i).Time]=t(i);
        [S(N+i).Lat]=Lat(i);
        [S(N+i).Lon]=Lon(i);
    end
    [S(N+1:N+n2).Speed]=deal(log(j).Speed);
    [S(N+1:N+n2-1).Logging_on]=deal(1);
    [S(N+n2).Logging_on]=deal(0);
    [S(N+1:N+n2).Geometry]   = deal('Point');
    N=N+n2;
end