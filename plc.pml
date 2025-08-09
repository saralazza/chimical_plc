bool px[12];
bool v8, cycle, v9, mixer;

mtype = { emp, sol42C, sol82C, undef1, undef2 };

mtype B1 = sol42C;   // stato iniziale esempio: soluzione concentrata 4g/l in B1
mtype B3 = emp;

#define true 1
#define false 0
#define procnr(i) ((i)-1)

#define theta(i,j) (i == 1 && ((B1 == sol42C || B1 == sol82C) && B3 == emp))

#define result(i,j) (i==1 && (B1 == emp && (B3 == sol42C || B3 == sol82C)))

inline PB1(i){
    if
    :: (i==1) -> v8=true; px[procnr(i)]= true; printf("PB1 called: i=1, v8=true\n");
    :: (i==2) -> v9=true; px[procnr(i)]= true; printf("PB1 called: i=2, v9=true\n");
    :: (i==3) -> v8=true; mixer = true; px[procnr(i)]= true; printf("PB3 called: i=3, v8=true, mixer = true\n");
    fi
}

inline PB0(i){
    if
    :: (i==1) -> v8=false; px[procnr(i)]= false; printf("PB0 called: i=1, v8=false\n");
    :: (i==2) -> v9=false; px[procnr(i)]= false; printf("PB0 called: i=2, v9=false\n");
    :: (i==3) -> v8=false; mixer = false; px[procnr(i)]= false; printf("PB0 called: i=3, v8=false, mixer =false\n");
    fi
}

proctype B1toB3(){
    do
    :: atomic{
        (cycle==0 && B1!=emp && v8==true)-> B3 = B1; B1 = emp; cycle = 1;
    }
    od
}

inline prova(x,y){
    if
    :: (x==emp && y==sol42C) -> printf("daje\n");
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
        :: (i<4) ->
            printf(" i = %d, processo %d che vale %d\n", i, procnr(i), px[procnr(i)]);
            if 
            :: (theta(i,j) && !px[procnr(i)]) -> PB1(i);
            :: (result(i,j) && px[procnr(i)]) -> PB0(i);
            :: else -> skip
            fi;
            if
            :: (j==1) -> j=2;
            :: (j==2) -> j=1 ; i=i+1
            fi
        :: (i==3) -> goto endcycle
        od;
        endcycle: cycle=0
    } 
    od
}

init {
    run control();

    run B1toB3();
}