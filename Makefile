MODEL = plant.pml

CC = gcc

LIVENESS_FLAGS = -DACCEPT_LABELS -DNFAIR=12

SAFETY_FLAGS = -DSAFETY

SAFETY_CHECKER = pan.safety
LIVENESS_CHECKER = pan.liveness

all: check-safety check-liveness

check-safety: $(SAFETY_CHECKER)
	@echo ""
	@echo "==================================================="
	@echo "--- SAFETY VERIFICATION ---"
	@echo "==================================================="
	./$(SAFETY_CHECKER)

check-liveness: $(LIVENESS_CHECKER)
	@echo ""
	@echo "==================================================="
	@echo "--- LIVENESS VERIFICATION---"
	@echo "==================================================="
	./$(LIVENESS_CHECKER) -a -f

$(SAFETY_CHECKER): .force-safety-rebuild
	$(CC) $(SAFETY_FLAGS) -o $(SAFETY_CHECKER) pan.c

$(LIVENESS_CHECKER): .force-liveness-rebuild
	$(CC) $(LIVENESS_FLAGS) -o $(LIVENESS_CHECKER) pan.c

.force-safety-rebuild: $(MODEL)
	sed '/^ltl/d' $(MODEL) > model.tmp
	spin -a model.tmp

.force-liveness-rebuild: $(MODEL)
	spin -a $(MODEL)

clean:
	rm -f pan.c $(SAFETY_CHECKER) $(LIVENESS_CHECKER) $(LIVENESS_CHECKER_NOPOR) *.trail _spin_nvr.tmp model.tmp

.PHONY: all check-safety check-liveness clean .force-safety-rebuild .force-liveness-rebuild