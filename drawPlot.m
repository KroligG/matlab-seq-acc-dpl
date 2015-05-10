hold all;
line([X0(1) theta0(1)*10000],[X0(2) theta0(2)*10000],'Color','g','LineWidth',2);
line([X0(1) theta_0(1)*10000],[X0(2) theta_0(2)*10000],'Color','b','LineWidth',2)

plot(Xt(1,:),Xt(2,:),'o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',5);

dispersePoints = 1;
labels=cellstr(num2str(T(1:dispersePoints:end)'));
text(Xt(1,1:dispersePoints:end),Xt(2,1:dispersePoints:end),labels,'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',11);

x = eps * cos(0 : 0.01 : 2*pi) + point(1);
y = eps * sin(0 : 0.01 : 2*pi) + point(2);

% xlim([0 point(1)+100]);
% ylim([0 point(2)+100]);
xlim([0 max(Xt(1,:))]);
ylim([0 max(Xt(2,:))]);
plot(x, y);
plot(point(1), point(2), 'or');

hold off;