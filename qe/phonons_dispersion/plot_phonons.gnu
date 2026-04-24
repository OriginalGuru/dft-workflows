set terminal x11 persist
set xlabel "Wave vector"
set ylabel "Frequency (cm^{-1})"
set yrange [-5:25]
unset key

# High-symmetry points
GM1 = 0.000000
X   = 0.500000
M   = 1.000000
GM2 = 1.707107
R   = 2.573132

set xtics ("{/Symbol G}" GM1, "X" X, "M" M, "{/Symbol G}" GM2, "R" R)
set xrange [GM1:R]

# Vertical lines at interior high-symmetry points
set arrow from X,   graph 0 to X,   graph 1 nohead lc rgb "gray50" lw 0.5
set arrow from M,   graph 0 to M,   graph 1 nohead lc rgb "gray50" lw 0.5
set arrow from GM2, graph 0 to GM2, graph 1 nohead lc rgb "gray50" lw 0.5

# Dashed zero line to mark soft modes
set arrow from GM1, 0 to R, 0 nohead lc rgb "gray70" lw 0.5 dt 2

plot for [i=2:16] 'SrTiO3.freq.gp' u 1:(column(i)*0.0299792458) w l lc rgb "blue"
