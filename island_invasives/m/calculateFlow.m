function flujo=calculateFlow(diametro)
% [diametro] = mm
% [flujo] = kg/seg
[x,y,p]=fitFlowRate;
flujo=polyval(p,diametro); % kg/seg