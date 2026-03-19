# QE Zone-Center Phonons

Zone-center phonon frequencies and eigenvectors using pw.x + ph.x.
Requires a converged SCF calculation.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x SCF input |
| `ph.in` | ph.x input for Gamma-point phonons |
| `01_setup.sh` | Checks inputs and prepares the run directory |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
bash 01_setup.sh
sbatch jobscript.sh
```

## Workflow

```bash
# Step 1: SCF
pw.x < pw.in > pw.out

# Step 2: Phonons at Gamma
ph.x < ph.in > ph.out
```

## Key ph.x input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `calculation` | `'phonons'` | Phonon calculation |
| `tr2_ph` | `1.0d-14` | Convergence threshold |
| `epsil` | `.false.` | No dielectric/Born charges |
| `trans` | `.true.` | Compute phonon frequencies |
| `ldisp` | `.false.` | Gamma point only |

## ph.in example

```
Phonons at Gamma
&INPUTPH
  prefix   = 'SrTiO3'
  outdir   = './tmp'
  tr2_ph   = 1.0d-14
  epsil    = .false.
  trans    = .true.
  ldisp    = .false.
  fildyn   = 'SrTiO3.dyn'
/
0.0 0.0 0.0
```

## Output

- `ph.out` — phonon frequencies and eigenvectors at Gamma
- `SrTiO3.dyn` — dynamical matrix file

## Notes

- `tr2_ph` should be set tighter than `conv_thr` in the SCF by
  at least two orders of magnitude.
- `outdir` and `prefix` must match the SCF calculation exactly.
- For Born effective charges and the dielectric tensor at the same
  time, set `epsil=.true.`. See `../born_charges/`.
- ph.x at Gamma only (`ldisp=.false.`) is much faster than a full
  phonon dispersion calculation.
