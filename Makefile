# promela file
MODEL = plant.pml

CC = gcc

# Flag for liveness properties verification
# -DACCEPT_LABELS: acceptance cycles
# -DNFAIR=12:      fairness
LIVENESS_FLAGS = -DACCEPT_LABELS -DNFAIR=12

# Flag for safety properties verification
# -DSAFETY: disable liveness verification 
SAFETY_FLAGS = -DSAFETY

SAFETY_CHECKER = pan.safety
LIVENESS_CHECKER = pan.liveness

# safety verification (deadlock)
all: check-deadlock

check-deadlock: $(SAFETY_CHECKER)
	@echo "--- DEADLOCK VERIFICATION ---"
	./$(SAFETY_CHECKER)

# liveness verification
check-liveness: $(LIVENESS_CHECKER)
	@echo "--- LIVENESS VERIFICATION WITH FAIRNESS ---"
	./$(LIVENESS_CHECKER) -a -f

$(SAFETY_CHECKER): pan.c
	$(CC) $(SAFETY_FLAGS) -o $(SAFETY_CHECKER) pan.c

$(LIVENESS_CHECKER): pan.c
	$(CC) $(LIVENESS_FLAGS) -o $(LIVENESS_CHECKER) pan.c

pan.c: $(MODEL)
	spin -a $(MODEL)

clean:
	@echo "--- Remove files ---"
	rm -f pan.c $(SAFETY_CHECKER) $(LIVENESS_CHECKER) *.trail _spin_nvr.tmp

.PHONY: all check-deadlock check-liveness clean