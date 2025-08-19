bool px[12];
bool v8, cycle, v9, mixer;

mtype = { emp, sol42C, sol82C, sol70C, undef1, undef2, water28C, water56C};

mtype B1 = sol42C;
mtype B3 = emp;
mtype B2 = water28C;

#define true 1
#define false 0
#define procnr(i) ((i)-1)


#define theta(i,j) ( \
    ((i == 1) && ((B1 == sol42C || B1 == sol82C) && (B3 == emp)) && (!px[procnr(2)]) ) || \
    ((i == 2) && ((B2 == water56C || B2 == water28C) && (B3 == emp)) && (!px[procnr(1)]) ) || \
    ((i == 3) && ((B1 == sol42C || B1 == sol82C) && (B3 == water28C)) && (!px[procnr(2)]) ) || \
    ((i == 4) && ((B2 == water28C || B2 == water56C) && (B3 == sol42C)) && (!px[procnr(1)]) ) \
)

#define result(i,j) (\
    ((i == 1) && (B1 == emp && (B3 == sol42C || B3 == sol82C))) || \
    ((i == 2) && (B2 == emp && (B3 == water28C || B3 == water56C))) ||\
    ((i == 3) && (B1 == emp && (B3 == sol70C))) ||\
    ((i == 4) && (B2 == emp && (B3 == sol70C))) \
)

inline PB1(i){
    if
    :: (i==1) -> v8=true; px[procnr(i)]= true; printf("PB1 called: i=1, v8=true\n");
    :: (i==2) -> v9=true; px[procnr(i)]= true; printf("PB1 called: i=2, v9=true\n");
    :: (i==3) -> v8=true; mixer = true; px[procnr(i)]= true; printf("PB1 called: i=3, v8=true, mixer = true\n");
    :: (i==4) -> v9=true; mixer = true; px[procnr(i)]= true; printf("PB1 called: i=4, v9=true, mixer = true\n");
    fi
}

inline PB0(i){
    if
    :: (i==1) -> v8=false; px[procnr(i)]= false; printf("PB0 called: i=1, v8=false\n");
    :: (i==2) -> v9=false; px[procnr(i)]= false; printf("PB0 called: i=2, v9=false\n");
    :: (i==3) -> v8=false; mixer = false; px[procnr(i)]= false; printf("PB0 called: i=3, v8=false, mixer =false\n");
    :: (i==4) -> v9=false; mixer = false; px[procnr(i)]= false; printf("PB0 called: i=4, v9=false, mixer =false\n");
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

inline prova(x,y){
    if
    :: (y==sol70C) -> printf("daje\n");
    :: else -> skip
    fi
}

proctype control(){
    int i,j;
    do
    :: atomic{ 
        i=1;
        j=1;
        do
        :: (i<5) ->
            //printf(" i = %d, processo %d che vale %d\n", i, procnr(i), px[procnr(i)]);
            if 
            :: (theta(i,j) && !px[procnr(i)]) -> PB1(i);
            :: (result(i,j) && px[procnr(i)]) -> PB0(i); prova(B1, B3)
            :: else -> skip
            fi;
            if
            :: (j==1) -> j=2;
            :: (j==2) -> j=1 ; i=i+1
            fi
        :: (i>=5) -> goto endcycle
        od;
        endcycle: cycle=0
    } 
    od
}

init {
    run control();

    run B1toB3();
    run B2toB3();
}