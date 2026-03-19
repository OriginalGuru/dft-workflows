# VASP Elastic Constants

Full elastic constant tensor via DFPT (IBRION=6).
Computes the second derivatives of the total energy with respect to strain.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 relaxed structure |
| `INCAR` | Elasticity input tags |
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
| `IBRION` | `6` | Finite differences for elastic constants |
| `NSW` | `1` | Required for IBRION=6 |
| `ISIF` | `3` | Allow full stress tensor |
| `EDIFF` | `1E-8` | Tight electronic convergence |
| `POTIM` | `0.015` | Strain step size |

## Output

- `OUTCAR` — elastic constant tensor (Cij in kBar), compliance tensor,
  bulk modulus, shear modulus, sound velocities
- `vasprun.xml` — structured output

## Extracting results

The elastic tensor is written in OUTCAR under:
```
TOTAL ELASTIC MODULI (kBar)
```

To convert kBar to GPa, divide by 10.

```bash
grep -A 10 "TOTAL ELASTIC MODULI" OUTCAR
```

## Notes

- Start from a fully relaxed structure with tight convergence. Residual
  stress from an under-relaxed cell will corrupt the elastic constants.
- For cubic SrTiO3 there are three independent elastic constants:
  C11, C12, and C44.
- `POTIM=0.015` is a reasonable default. If the elastic constants are
  noisy, try a smaller value (0.010). If VASP fails to converge on the
  strained cells, try a larger value (0.020).
- This calculation is computationally expensive — expect roughly 6x the
  cost of a single SCF for a cubic system.
