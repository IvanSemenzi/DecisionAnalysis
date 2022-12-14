function h = DP_SF_plot_circle(center,r,N,color)

% Plot a circle of given center, radius, number of points and color

theta=linspace(0,2*pi,N);
x=center(1)+r*cos(theta);
y=center(2)+r*sin(theta);
h=fill(x,y,color);
axis square

