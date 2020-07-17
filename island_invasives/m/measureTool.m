function [h,pos,status]=measureTool(h,pos,status)
currentPoint=get(gca,'CurrentPoint');
pos(end+1,:)=[currentPoint(1,1) currentPoint(1,2)];
n=size(pos,1);
if n==1
    h=plot(pos(1),pos(2),'k.-');
else
    set(h,'xdata',pos(:,1),'ydata',pos(:,2));
end
distance = sum(sqrt(sum(diff(pos).^2,2)));
area = polyarea(pos(:,1),pos(:,2));
set(status,'string',['Distance: ' num2str(distance) ' m.  Area: ' num2str(area) ' m^2.']);