y <- c(1.00000000000000, 1.02340467557620, 1.03437352316635, 1.05620055098226,
       1.06779917620969, 1.06333168804339, 1.07563834749462, 1.05011973396500)
y2 <- c(1.00000000000000, 0.947945083243594, 0.885823640068795, 0.848179963004416, 
        0.864046400333855, 0.836409683888678, 0.653872166503499, 0.731273832260501)
x <- c(3,6,9,12,15, 18,21,24)
plot(x, y, type = "b", lty = 1, col='red', pch=20, ylim = c(0.6,1.07), 
     xlab = 'n', ylab = 'Razmerje: max vsote/max razdalje',
     main = 'Razmerje za vsote in najkrajše povezave')
lines(x, y2, pch = 18, col = "blue", type = "b", lty = 2)
legend("bottomleft", legend=c("Razmerje med vsotama povezav za obe maksimizaciji",
                              "Razmerje med najkrajšima povezavama za obe maksimizaciji"),
       col=c("red", "blue"), lty = 1:2, cex=0.8)





z <- c(0.0878442049026489,  0.695756244659424,   3.20040369033813,   16.7076765775681,   
       127.604686427116, 476.638591051, 3634.53250909)
z2 <- c(0.0577517986297607,  0.582032465934753,   3.19157488346100,   20.4999457120895,   
        117.850273919106, 126.389681101, 4391.16166091)
x1 <- c(3,6,9,12,15,18,21)
plot(x1, z, type = "b", lty = 1, col='red', pch=20,  
     xlab = 'n', ylab = 'Sekunde',
     main = 'Èas porabljen za izvedbo programa')
lines(x1, z2, pch = 18, col = "blue", type = "b", lty = 2)
legend("topleft", legend=c("Èas porabljen za maksimizacijo vsote",
                              "Èas porabljen za maksimizacijo dolžine najkrajše povezave"),
       col=c("red", "blue"), lty = 1:2, cex=0.8)
