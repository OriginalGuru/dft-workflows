# VASP Relaxation

Structural relaxation of ionic positions and cell shape/volume.
Run this before any property calculation to obtain the equilibrium geometry.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 initial structure |
| `INCAR` | Relaxation input tags |
| `KPOINTS` | k-point mesh |
| `POTCAR` | Not included — place your POTCAR here |
| `01_setup.sh` | Checks inputs and prepares the run directory |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
bash 01_setup.sh
sbatch jobscript.sh
```

## Key INCAR tags

| Tag | Value | Purpose |
|---|---|---|
| `IBRION` | `2` | Conjugate gradient relaxation |
| `NSW` | `100` | Maximum ionic steps |
| `ISIF` | `3` | Relax ions + cell shape + cell volume |
| `EDIFF` | `1E-6` | Electronic convergence |
| `EDIFFG` | `-0.01` | Ionic convergence (forces, eV/Ang) |
| `ENCUT` | species-dependent | Plane wave cutoff |

## Output

- `CONTCAR` — relaxed structure; copy to POSCAR for subsequent calculations
- `OUTCAR` — ionic steps, forces, stress tensor at each step
- `vasprun.xml` — full structured output

## Notes

- After relaxation completes, copy `CONTCAR` to `POSCAR` and use that
  as the starting geometry for all property calculations.
- Check convergence in OUTCAR: forces on all atoms should be below
  `|EDIFFG|` and the stress tensor should be near zero.
- `ISIF=3` relaxes everything. Use `ISIF=2` to relax ions only
  (fixed cell), or `ISIF=4` for cell shape only (fixed volume).
