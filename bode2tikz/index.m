
%% Example 1 - Single plot
H = tf([1 0.1 7.5],[1 0.12 9 0 0]);
bode(H);
bode2tikz(gcf)

%% Example 2 - Continnuous and Discrete plot

H = tf([1 0.1 7.5],[1 0.12 9 0 0]);
Hd = c2d(H,0.5,'zoh');
bode(H,Hd)

bode2tikz(gcf)

