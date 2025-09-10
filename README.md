# PLC Control Schedule Verification

This project provides a Promela model for the verification and optimization of a PLC (Programmable Logic Controller) control schedule, based on the case study described in the paper "Verification and Optimization of a PLC Control Schedule" by Ed Brinksma and Angelika Mader.

The model simulates an experimental chemical batch plant controlled by a PLC. The goal is to formally verify that the control logic is correct, ensuring the system operates continuously without deadlocks and always produces new batches.

The verification is performed using the **SPIN model checker**.

## Project Structure

- `prova.pml`: The main Promela model file containing the logic for the chemical plant processes and the PLC controller.
- `Makefile`: An automation script to simplify the verification process.

## Verification Goals

This project aims to formally verify two critical properties of the system, as outlined in the original paper:

1.  **Safety (Deadlock Freedom):** The system must never enter a state from which it cannot proceed. This guarantees the controller will never halt or freeze.

2.  **Liveness (Continuous Production):** The system must always make useful progress. Specifically, it must always eventually produce a new batch and subsequently clear the production tank to allow the cycle to continue indefinitely. This is verified using the following Linear Temporal Logic (LTL) formula:
    
    `([]<> (B3 == sol70C)) && ([]<> (B3 == emp))`
    
    This translates to: "It is always true that eventually tank B3 will be full (`sol70C`), AND it is always true that eventually tank B3 will be empty (`emp`)."

## Prerequisites

To run the verification, you must have the **SPIN model checker** installed. SPIN consists of the `spin` executable and requires a C compiler like `gcc`.

-   **SPIN**
-   **GCC**

## How to Run the Verification

A `Makefile` is provided to automate the entire process. Simply open a terminal in the project directory and use the following commands.

### 1. Verify Safety (Deadlock Freedom)

This is the most fundamental check. It will compile a "safety checker" and run it to ensure the model is free of deadlocks and assertion violations.

To run the safety verification, execute:
```bash
make check-safety
```
You can also just run `make`, as this is the default target.

**Expected Output:**
The verification is successful if the output ends with `errors: 0`. This confirms that the model is deadlock-free.

### 2. Verify Liveness (Continuous Production)

This check verifies the core requirement that the system continuously produces batches. It compiles a separate "liveness checker" with fairness enabled and runs it against the full LTL property defined in the model.

To run the liveness verification, execute:
```bash
make check-liveness
```

**Expected Output:**
The verification is successful if the output ends with `errors: 0`. This formally proves that the system will always produce new batches and complete the production cycle.


### 3. Clean Up Generated Files

After running the verifications, you can clean up all generated files (executables, `.trail` files, etc.) with the following command:

```bash
make clean
```

This will restore your directory to its original state, leaving only the source files.