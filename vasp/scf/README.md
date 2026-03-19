# VASP SCF

Self-consistent field calculation. Computes the ground-state charge density
and total energy for a fixed geometry.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 cubic perovskite structure |
| `INCAR` | SCF input tags |
| `KPOINTS` | Monkhorst-Pack k-point mesh |
| `POTCAR` | Not included — place your POTCAR here |
| `01_setup.sh` | Checks inputs and prepares the run directory |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
# Place your POTCAR in this directory, then:
bash 01_setup.sh
sbatch jobscript.sh
```

## Key INCAR tags

| Tag | Value | Purpose |
|---|---|---|
| `IBRION` | `-1` | No ionic movement |
| `NSW` | `0` | No ionic steps |
| `EDIFF` | `1E-6` | Electronic convergence criterion |
| `ENCUT` | species-dependent | Plane wave cutoff |
| `ISMEAR` | `0` | Gaussian smearing |
| `SIGMA` | `0.05` | Smearing width |

## Output

- `OUTCAR` — full calculation log, total energy, timing
- `CONTCAR` — final structure (identical to POSCAR for SCF)
- `CHGCAR` — charge density (needed for bands and DOS)
- `vasprun.xml` — structured output for post-processing

## Notes

- Run SCF before `bands/` or `dos/`. Those calculations use `ICHARG=11`
  to read the converged charge density from this directory.
- For a well-converged SCF, check that the energy difference between
  the last two electronic steps is below EDIFF in OUTCAR.
