# QE Relaxation

Structural relaxation of ionic positions and cell with pw.x.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x input file with relaxation settings |
| `01_setup.sh` | Sets PSEUDO_DIR, checks inputs |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
bash 01_setup.sh
sbatch jobscript.sh
```

## Key input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `calculation` | `'vc-relax'` | Relax ions and cell (variable cell) |
| `forc_conv_thr` | `1.0d-4` | Force convergence (Ry/Bohr) |
| `press_conv_thr` | `0.1` | Pressure convergence (kBar) |
| `ion_dynamics` | `'bfgs'` | BFGS minimizer |
| `cell_dynamics` | `'bfgs'` | Cell minimizer |

## Output

- `pw.out` — ionic steps, forces, stress at each step
- `prefix.save/` — final charge density
- The final relaxed structure is printed at the end of `pw.out` under
  `Begin final coordinates`

## Extracting the relaxed structure

```bash
# Extract final coordinates from pw.out
grep -A 100 "Begin final coordinates" pw.out | grep -B 100 "End final coordinates"
```

## Notes

- Use `calculation='relax'` to relax ions only (fixed cell).
- Use `calculation='vc-relax'` to relax both ions and cell.
- After relaxation, copy the final `CELL_PARAMETERS` and
  `ATOMIC_POSITIONS` blocks from `pw.out` into your subsequent
  calculation input files.
- QE does not write a POSCAR-format output. Use ASE or a conversion
  script if you need to go back to VASP format.
