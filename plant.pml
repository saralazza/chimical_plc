bool px[12];
bool cycle, v1, v3, v5, v6, v8, v9, v11, v12, v15, v17, v18, v20, v22, v23, v24, v25, v29, pump1, pump2, mixer, heater;

mtype = { emp, sol42C, sol82C, sol70C, sol140C, sol84C, sol42H, sol84H, undef1, undef2, water28C, water56C, water28H, water56H};

mtype B1 = sol42C;
mtype B3 = emp;
mtype B2 = water28C;
mtype B4 = emp;
mtype B5 = emp;
mtype B6 = emp;
mtype B7 = emp;


#define true 1
#define false 0
#define procnr(i) ((i)-1)

#define phi(i,j)( \
    ((i == 1) && ((B1 == sol42C || B1 == sol82C) && (B3 == emp)) ) || \
    ((i == 2) && ((B2 == water56C || B2 == water28C) && (B3 == emp)) ) || \
    ((i == 3) && ((B1 == sol42C || B1 == sol82C) && (B3 == water28C)) ) || \
    ((i == 4) && ((B2 == water28C || B2 == water56C) && (B3 == sol42C)) ) || \
    ((i == 5) && ((B3 == sol70C) && (B4 == emp || B4 == sol70C)) ) || \
    ((i == 6) && ((B4 == sol70C || B4 == sol140C) && (B5 == emp)) ) || \
    ((i == 7) && ((B5 == sol70C) && (B6 == emp || B6 == water28C || B6 == water28H)) ) || \
    ((i == 8) && ((B5 == sol42H) && (B7 == emp || B7 == sol42C || B7 == sol42H)) ) || \
    ((i == 9) && ((B7 == sol42H || B7 == sol84H)) ) || \
    ((i == 10) && ((B6 == water28H || B6 == water56H)) ) || \
    ((i == 11) && ((B7 == sol42C || B7 == sol84C) && (B1 == emp || B1 == sol42C)) ) || \
    ((i == 12) && ((B6 == water28C || B6 == water56C) && (B2 == emp || B2 == water28C)) ) \
)


#define psi(i,j)( \
    ((i == 1) && phi(1,j) && (!px[procnr(2)] && !px[procnr(4)] && !px[procnr(5)] && !px[procnr(11)]) ) || \
    ((i == 2) && phi(2,j) && (!px[procnr(1)] && !px[procnr(3)] && !px[procnr(5)] && !px[procnr(12)]) ) || \
    ((i == 3) && phi(3,j) && (!px[procnr(2)] && !px[procnr(4)] && !px[procnr(5)] && !px[procnr(11)]) ) || \
    ((i == 4) && phi(4,j) && (!px[procnr(1)] && !px[procnr(3)] && !px[procnr(5)] && !px[procnr(12)]) ) || \
    ((i == 5) && phi(5,j) && (!px[procnr(1)] && !px[procnr(2)] && !px[procnr(3)] && !px[procnr(4)] && !px[procnr(6)]) ) || \
    ((i == 6) && phi(6,j) && (!px[procnr(5)] && !px[procnr(7)] && !px[procnr(8)]) ) || \
    ((i == 7) && phi(7,j) && (!px[procnr(6)] && !px[procnr(8)] && !px[procnr(10)] && !px[procnr(12)]) ) || \
    ((i == 8) && phi(8,j) && (!px[procnr(6)] && !px[procnr(7)] && !px[procnr(9)] && !px[procnr(11)]) ) || \
    ((i == 9) && phi(9,j) && (!px[procnr(8)] && !px[procnr(11)]) ) || \
    ((i == 10) && phi(10,j) && (!px[procnr(7)] && !px[procnr(12)]) ) || \
    ((i == 11) && phi(11,j) && (!px[procnr(1)] && !px[procnr(3)] && !px[procnr(8)] && !px[procnr(9)]) ) || \
    ((i == 12) && phi(12,j) && (!px[procnr(2)] && !px[procnr(4)] && !px[procnr(7)] && !px[procnr(10)]) ) \
)

#define theta(i,j) ( \
    ((i == 1) && psi(1,j) && !psi(5,j) ) || \
    ((i == 2) && psi(2,j) && !psi(1,j) && !psi(3,j) && !psi(5,j) ) || \
    ((i == 3) && psi(3,j) && !psi(5,j) ) || \
    ((i == 4) && psi(4,j) && !psi(1,j) && !psi(3,j) && !psi(5,j)) || \
    ((i == 5) && psi(5,j) && !psi(6,j) ) || \
    ((i == 6) && psi(6,j) && !psi(7,j) && !psi(8,j) ) || \
    ((i == 7) && psi(7,j) ) || \
    ((i == 8) && psi(8,j) && !psi(7,j) ) || \
    ((i == 9) && psi(9,j) && !psi(8,j) ) || \
    ((i == 10) && psi(10,j) && !psi(7,j) ) || \
    ((i == 11) && psi(11,j) && !psi(1,j) && !psi(3,j) && !psi(8,j) && !psi(9,j) ) || \
    ((i == 12) && psi(12,j) && !psi(2,j) && !psi(4,j) && !psi(7,j) && !psi(10,j) ) \
)


#define result(i,j) (\
    ((i == 1) && (B1 == emp && (B3 == sol42C || B3 == sol82C))) || \
    ((i == 2) && (B2 == emp && (B3 == water28C || B3 == water56C))) ||\
    ((i == 3) && (B1 == emp && (B3 == sol70C))) || \
    ((i == 4) && (B2 == emp && (B3 == sol70C))) || \
    ((i == 5) && (B3 == emp && B4 == sol70C)) || \
    ((i == 6) && (B4 == emp && B5 == sol70C)) || \
    ((i == 7) && (B5 == sol42H && (B6 == water28H))) || \
    ((i == 8) && (B5 == emp && (B7 == sol42H))) || \
    ((i == 9) && (B7 == sol42C)) || \
    ((i == 10) && (B6 == water28C)) || \
    ((i == 11) && (B7 == emp && (B1 == sol42C))) || \
    ((i == 12) && (B6 == emp && (B2 == water28C))) \
)

inline PB1(i){
    if
    :: (i==1) -> v8=true; px[procnr(i)]= true; printf("PB1 called: i=1, v8=true\n");
    :: (i==2) -> v9=true; px[procnr(i)]= true; printf("PB1 called: i=2, v9=true\n");
    :: (i==3) -> v8=true; mixer = true; px[procnr(i)]= true; printf("PB1 called: i=3, v8=true, mixer = true\n");
    :: (i==4) -> v9=true; mixer = true; px[procnr(i)]= true; printf("PB1 called: i=4, v9=true, mixer = true\n");
    :: (i==5) -> v11=true; px[procnr(i)]= true; printf("PB1 called: i=5, v11=true\n");
    :: (i==6) -> v12=true; px[procnr(i)]= true; printf("PB1 called: i=6, v12=true\n");
    :: (i==7) -> heater = true; px[procnr(i)]= true; printf("PB1 called: i=7, heater = true\n");
    :: (i==8) -> v15=true; px[procnr(i)]= true; printf("PB1 called: i=8, v15=true\n");
    :: (i==9) -> v17=true; px[procnr(i)]= true; printf("PB1 called: i=9, v17=true\n");
    :: (i==10) -> v29=true; px[procnr(i)]= true; printf("PB1 called: i=10, v29=true\n");
    :: (i==11) -> v18=true; v23=true; v22=true; v1=true; v3=true; pump1=true; px[procnr(i)]= true; printf("PB1 called: i=11, v18=true; v23=true; v22=true; v1=true; v3=true; pump1=true\n");
    :: (i==12) -> v20=true; v24=true; v25=true; v5=true; v6=true; pump2=true; px[procnr(i)]= true; printf("PB1 called: i=12, v20=true; v24=true; v25=true; v5=true; v6=true; pump2=true\n");
    fi
}

inline PB0(i){
    if
    :: (i==1) -> v8=false; px[procnr(i)]= false; printf("PB0 called: i=1, v8=false\n");
    :: (i==2) -> v9=false; px[procnr(i)]= false; printf("PB0 called: i=2, v9=false\n");
    :: (i==3) -> v8=false; mixer = false; px[procnr(i)]= false; printf("PB0 called: i=3, v8=false, mixer =false\n");
    :: (i==4) -> v9=false; mixer = false; px[procnr(i)]= false; printf("PB0 called: i=4, v9=false, mixer =false\n");
    :: (i==5) -> v11=false; px[procnr(i)]= false; printf("PB0 called: i=5, v11=false\n");
    :: (i==6) -> v12=false; px[procnr(i)]= false; printf("PB0 called: i=6, v12=false\n");
    :: (i==7) -> heater = false; px[procnr(i)]= false; printf("PB0 called: i=7, heater = false\n");
    :: (i==8) -> v15=false; px[procnr(i)]= false; printf("PB0 called: i=8, v15=false, mixer = false\n");
    :: (i==9) -> v17=false; px[procnr(i)]= false; printf("PB0 called: i=9, v17=false\n");
    :: (i==10) -> v29=false; px[procnr(i)]= false; printf("PB0 called: i=10, v29=false\n");
    :: (i==11) -> v18=false; v23=false; v22=false; v1=false; v3=false; pump1=false; px[procnr(i)]= false; printf("PB0 called: i=11, v18=false; v23=false; v22=false; v1=false; v3=false; pump1=false\n");
    :: (i==12) -> v20=false; v24=false; v25=false; v5=false; v6=false; pump2=false; px[procnr(i)]= false; printf("PB0 called: i=12, v20=false; v24=false; v25=false; v5=false; v6=false; pump2=false\n");
    fi
}

proctype B1toB3(){
    do
    :: atomic{
        (cycle==0 && B1!=emp && v8==true && mixer==false)-> B3 = B1; B1 = emp; cycle = 1;
    }
    :: atomic{
        (cycle==0 && B1!=emp && v8==true && mixer==true)-> B3 = sol70C; B1 = emp; cycle = 1;
    }
    od
}

proctype B2toB3(){
    do
    :: atomic{
        (cycle==0 && B2!=emp && v9==true && mixer==false)-> B3 = B2; B2 = emp; cycle = 1;
    }
    :: atomic{
        (cycle==0 && B2!=emp && v9==true && mixer==true)-> B3 = sol70C; B2 = emp; cycle = 1;
    }
    od
}

proctype B3toB4(){
    do
    :: atomic{
        (cycle==0 && B3==sol70C && v11==true)-> B4 = B3; B3 = emp; cycle = 1;
    }
    od
}

proctype B4toB5(){
    do
    :: atomic{
        (cycle==0 && B4!=emp && v12==true)-> B5 = B4; B4 = emp; cycle = 1;
    }
    od
}

proctype B5toB6(){
    do
    :: atomic{
        (cycle==0 && B5!=emp && heater==true)-> B5 = sol42H; B6 = water28H; cycle = 1;
    }
    od
}

proctype B5toB7(){
    do
    :: atomic{
        (cycle==0 && B5!=emp && v15==true)-> B5 = emp; B7 = sol42H; cycle = 1;
    }
    od
}

proctype coolB7(){
    do
    :: atomic{
        (cycle==0 && B7!=emp && v17==true)-> B7 = sol42C; cycle = 1;
    }
    od
}

proctype coolB6(){
    do
    :: atomic{
        (cycle==0 && B6!=emp && v29==true)-> B6 = water28C; cycle = 1;
    }
    od
}


proctype B6toB2(){
    do
    :: atomic{
        (cycle==0 && B6!=emp && v20 && v24 && v25 && v5 && v6 && pump2) ->
            B6 = emp; B2 = water28C; cycle = 1;
    }
    od
}

proctype B7toB1(){
    do
    :: atomic{
        (cycle==0 && B7!=emp && v18 && v23 && v22 && v1 && v3 && pump1) ->
            B7 = emp; B1 = sol42C; cycle = 1;
    }
    od
}


proctype control(){
    int i,j;
    do
    :: 
        atomic{
            i=1;
            j=1;
            do
            :: (i < 13) -> 
                if
                :: (theta(i,j) && !px[procnr(i)]) -> PB1(i)
                :: (result(i,j) && px[procnr(i)]) -> PB0(i);
                :: else -> skip
                fi;
                i=i+1
            :: (i >= 13) -> break
            od;
            endcycle: cycle=0;
        }
    od
}

init {
    run control();

    run B1toB3();
    run B2toB3();
    run B3toB4();
    run B4toB5();
    run B5toB6();
    run B5toB7();
    run coolB7();
    run coolB6();
    run B7toB1();
    run B6toB2();
}


/*
spin -a plant.pml
gcc -DACCEPT_LABELS -DNFAIR=12 -o pan pan.c
./pan -a -f
*/
ltl full_production_cycle { ([]<> (B3 == sol70C)) && ([]<> (B3 == emp)) }