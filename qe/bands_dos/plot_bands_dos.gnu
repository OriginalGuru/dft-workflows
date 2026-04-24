set terminal x11 persist size 600,600

EF = 9.9149   # <-- VBM from `grep "highest occupied" scf.out`

set multiplot layout 1,2

# --- Bands panel (left, wider) ---
set size 0.72, 1.0
set origin 0.0, 0.0
set lmargin 8
set rmargin 0

set xlabel "Wave vector"
set ylabel "Energy (eV)"
set yrange [-10:10]
unset key

GM1 = 0.000000
X   = 0.500000
M   = 1.000000
GM2 = 1.707107
R   = 2.573132

set xtics ("{/Symbol G}" GM1, "X" X, "M" M, "{/Symbol G}" GM2, "R" R)
set xrange [GM1:R]

set arrow 1 from X,   graph 0 to X,   graph 1 nohead lc rgb "gray50" lw 0.5
set arrow 2 from M,   graph 0 to M,   graph 1 nohead lc rgb "gray50" lw 0.5
set arrow 3 from GM2, graph 0 to GM2, graph 1 nohead lc rgb "gray50" lw 0.5
set arrow 4 from GM1, 0 to R, 0 nohead lc rgb "gray70" lw 0.5 dt 2

plot for [i=2:31] 'SrTiO3.bands.dat.gnu' u 1:(column(i)-EF) w l lc rgb "black"

# --- DOS panel (right, narrower, rotated so energy is on y-axis) ---
set size 0.28, 1.0
set origin 0.72, 0.0
set lmargin 0
set rmargin 3

unset arrow
unset xtics
unset xlabel
unset ylabel
set format y ""           # hide y-tick labels (same axis as bands panel)

set xlabel "DOS"
set xtics auto
set xrange [0:*]          # auto upper bound
# yrange is inherited: [-10:10]

# Dashed zero line at VBM, spanning whatever the DOS max ends up being
set arrow 1 from graph 0, first 0 to graph 1, first 0 nohead lc rgb "gray70" lw 0.5 dt 2

plot 'SrTiO3.dos' u 2:($1-EF) w l lc rgb "black"

unset multiplot
