# QE Band Structure

Electronic band structure using pw.x + bands.x.
Requires a converged charge density from a prior SCF calculation.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x bands input (calculation='bands') |
| `bands.in` | bands.x post-processing input |
| `01_setup.sh` | Checks that SCF outdir exists, prepares inputs |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
# Requires completed SCF run with matching outdir/prefix
bash 01_setup.sh
sbatch jobscript.sh
```

## Workflow

```bash
# Step 1: pw.x bands calculation
pw.x < pw.in > pw.out

# Step 2: bands.x post-processing
bands.x < bands.in > bands.out
```

## Key input parameters (pw.in)

| Parameter | Value | Purpose |
|---|---|---|
| `calculation` | `'bands'` | Band structure along k-path |
| `restart_mode` | `'restart'` | Read SCF charge density |
| `nbnd` | set explicitly | Number of bands to compute |

## K_POINTS block

Use `tpiba_b` format for an explicit k-path:
```
K_POINTS tpiba_b
5
  0.0 0.0 0.0  40   ! Gamma
  0.5 0.0 0.0  40   ! X
  0.5 0.5 0.0  40   ! M
  0.0 0.0 0.0  40   ! Gamma
  0.5 0.5 0.5   1   ! R
```

## Output

- `pw.out` — eigenvalues at each k-point
- `bands.out` — processed band data
- `prefix.bands.dat` — eigenvalues formatted for plotting

## Notes

- `outdir` and `prefix` must match those used in the SCF calculation.
- For SrTiO3 (cubic Pm-3m), the standard path is
  Gamma -> X -> M -> Gamma -> R -> X.
- Use gnuplot, matplotlib, or xcrysden to plot the band data.
