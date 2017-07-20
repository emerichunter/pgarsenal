set terminal png medium size 640,480
set output "buffers.png"
set title "Buffer size over time"
set grid xtics ytics
set xlabel "Time during test"
set ylabel "Buffers"
set xdata time
# set timefmt "%s"
plot "results.dat" using 1:2 with lines

