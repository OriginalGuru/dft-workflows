# QE SCF

Self-consistent field calculation with pw.x.
Computes the ground-state charge density and total energy.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x input file |
| `01_setup.sh` | Sets PSEUDO_DIR, checks pseudopotentials, prepares run |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
# Edit PSEUDO_DIR in 01_setup.sh to point to your pseudopotential directory
bash 01_setup.sh
sbatch jobscript.sh
```

## Pseudopotentials required

For SrTiO3:
- `Sr.upf` — Sr pseudopotential
- `Ti.upf` — Ti pseudopotential
- `O.upf`  — O pseudopotential

## Key input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `calculation` | `'scf'` | Single-point energy |
| `ecutwfc` | species-dependent | Plane wave cutoff (Ry) |
| `ecutrho` | 4-10x ecutwfc | Charge density cutoff (Ry) |
| `conv_thr` | `1.0d-9` | SCF convergence threshold |
| `occupations` | `'smearing'` | Smearing for metals; `'fixed'` for insulators |
| `smearing` | `'mp'` | Methfessel-Paxton (metals) or `'gaussian'` |
| `degauss` | `0.02` | Smearing width (Ry) |

## Output

- `pw.out` — calculation log, total energy, timing
- `prefix.save/` — charge density, wavefunctions (needed for bands/DOS)

## Notes

- Set `outdir` and `prefix` consistently across all calculations so
  that bands and DOS can read the SCF charge density.
- For insulators like SrTiO3, use `occupations='fixed'` and remove
  the smearing parameters.
- The charge density is saved in `outdir/prefix.save/`. Point the
  `bands/` and `dos/` calculations to the same `outdir`.
