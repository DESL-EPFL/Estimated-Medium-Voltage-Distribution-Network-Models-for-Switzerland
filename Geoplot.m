% function to locate MV network on Swiss map

function [msg] = Geoplot(j)


if nargin == 0

    % choose MV network to plot
    j = 740;

    
end


filename = ['MV' num2str(j), '.xlsx'];

% load network locations

Locations = xlsread(filename, 4);


Latitude = [Locations(1,2); Locations(:,2)];
Longitude = [Locations(1,3); Locations(:,3)];

% load network graph

LD = xlsread(filename, 1);

From_to = [LD(:,1:2)];
From_to = [1 2; From_to+1];

% graph
graph_temp = graph(From_to(:,1), From_to(:,2));
    
% load switzerland boundaries 

Suiss_poly = load('switzerland-exact.poly.txt');

% plot
figure
width = 1600;
height = 600;
x0 = 20;
y0 = 20;
set(gcf,'units','points','position',[x0,y0,width,height])

subplot(1,2,1)

plot(Suiss_poly(:,1), Suiss_poly(:,2), 'linewidth', 4);
hold on

plot(graph_temp, 'XData', Longitude, 'YData', Latitude, 'linewidth', 3)

legend('Swiss boundary', 'MV network', 'Location', 'best')

ylabel('Latitude')
xlabel('Longitude')
set(gca,'FontSize',28)
set(gca, 'FontName', 'Cambria')
grid on
axis([-inf inf -inf inf])
legend boxoff


subplot(1,2,2)

plot(Suiss_poly(:,1), Suiss_poly(:,2), 'linewidth', 4);
hold on
plot(graph_temp, 'XData', Longitude, 'YData', Latitude, 'linewidth', 3)
axis([min(Longitude)-0.03 max(Longitude)+0.03 min(Latitude)-0.03 max(Latitude)+0.03])

legend('Swiss boundary', 'MV network', 'Location', 'best')

ylabel('Latitude')
xlabel('Longitude')
set(gca,'FontSize',28)
set(gca, 'FontName', 'Cambria')
grid on
legend boxoff

suptitle(['Geographical locations of MV network ', num2str(j)])
set(gca,'FontSize',28)
set(gca, 'FontName', 'Cambria')

msg = ['locating MV netowrk ', num2str(j), ' successful'];  



end 