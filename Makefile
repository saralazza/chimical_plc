MODEL = plant.pml

CC = gcc

# Flag di compilazione per LIVENESS
# -DACCEPT_LABELS: Abilita la ricerca di acceptance cycles (per LTL)
# -DNFAIR=12:      Abilita l'algoritmo di fairness per 12 processi
LIVENESS_FLAGS = -DACCEPT_LABELS -DNFAIR=12

# Flag di compilazione per SAFETY (deadlock e asserzioni)
# -DSAFETY: Abilita solo i controlli di base
SAFETY_FLAGS = -DSAFETY

# Eseguibili che verranno creati
SAFETY_CHECKER = pan.safety
LIVENESS_CHECKER = pan.liveness

# --- Target Principali ---

# Esegue tutte le verifiche
all: check-safety check-liveness

# Target per la verifica di Safety (Deadlock)
check-safety: $(SAFETY_CHECKER)
	@echo ""
	@echo "==================================================="
	@echo "--- ESECUZIONE VERIFICA DI SAFETY (DEADLOCK)    ---"
	@echo "==================================================="
	./$(SAFETY_CHECKER)

# Target per la verifica di Liveness (CON POR)
check-liveness: $(LIVENESS_CHECKER)
	@echo ""
	@echo "==================================================="
	@echo "--- ESECUZIONE VERIFICA LIVENESS (CON POR)      ---"
	@echo "==================================================="
	./$(LIVENESS_CHECKER) -a -f

# --- Regole di Compilazione ---

# Regola per compilare il verificatore di Safety
# Dipende da un file "fittizio" per forzare la rigenerazione di pan.c
$(SAFETY_CHECKER): .force-safety-rebuild
	@echo "--- Compilazione del verificatore di Safety ---"
	$(CC) $(SAFETY_FLAGS) -o $(SAFETY_CHECKER) pan.c

# Regola per compilare il verificatore di Liveness
# Dipende da un file "fittizio" per forzare la rigenerazione di pan.c
$(LIVENESS_CHECKER): .force-liveness-rebuild
	@echo "--- Compilazione del verificatore di Liveness (con POR) ---"
	$(CC) $(LIVENESS_FLAGS) -o $(LIVENESS_CHECKER) pan.c

# --- Regole "Fittizie" per Forzare la Rigenerazione ---
# Queste regole assicurano che 'spin -a' venga eseguito ogni volta,
# generando il 'pan.c' corretto per il tipo di verifica.

.force-safety-rebuild: $(MODEL)
	@echo "--- Generazione di pan.c per la verifica di Safety ---"
	# Creiamo una versione temporanea del modello senza la riga LTL
	sed '/^ltl/d' $(MODEL) > model.tmp
	# Generiamo pan.c da questo modello temporaneo
	spin -a model.tmp

.force-liveness-rebuild: $(MODEL)
	@echo "--- Generazione di pan.c per la verifica di Liveness ---"
	spin -a $(MODEL)

# --- Regola di Pulizia ---

# Target per rimuovere tutti i file generati
clean:
	@echo "--- Pulizia dei file generati dalla verifica ---"
	rm -f pan.c $(SAFETY_CHECKER) $(LIVENESS_CHECKER) $(LIVENESS_CHECKER_NOPOR) *.trail _spin_nvr.tmp model.tmp

# Dichiara i target che non sono file
.PHONY: all check-safety check-liveness clean .force-safety-rebuild .force-liveness-rebuild