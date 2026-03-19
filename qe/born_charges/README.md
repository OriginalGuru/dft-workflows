# QE Born Effective Charges

Born effective charge tensors and macroscopic dielectric tensor
using pw.x + ph.x with `epsil=.true.`.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x SCF input |
| `ph.in` | ph.x input with epsil=.true. |
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

# Step 2: Born charges and dielectric tensor at Gamma
ph.x < ph.in > ph.out
```

## Key ph.x input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `epsil` | `.true.` | Compute Born charges and dielectric tensor |
| `trans` | `.true.` | Also compute phonon frequencies |
| `ldisp` | `.false.` | Gamma point only |
| `tr2_ph` | `1.0d-14` | Convergence threshold |

## ph.in example

```
Born charges and dielectric tensor
&INPUTPH
  prefix   = 'SrTiO3'
  outdir   = './tmp'
  tr2_ph   = 1.0d-14
  epsil    = .true.
  trans    = .true.
  ldisp    = .false.
  fildyn   = 'SrTiO3.dyn'
/
0.0 0.0 0.0
```

## Output

- `ph.out` — Born effective charge tensors and dielectric tensor
- `SrTiO3.dyn` — dynamical matrix including Born charge information

## Extracting Born charges

```bash
grep -A 5 "Effective charges" ph.out
grep -A 5 "Dielectric constant" ph.out
```

## Notes

- Setting both `epsil=.true.` and `trans=.true.` computes phonon
  frequencies, Born charges, and the dielectric tensor in a single
  ph.x run — the most efficient approach.
- Born charges are only meaningful for insulators and semiconductors.
- The acoustic sum rule for Born charges (sum over all atoms = 0)
  is checked in ph.out. Small violations are normal.
- The output from this calculation can be used to construct a BORN
  file for phonopy (for LO-TO splitting in phonon dispersion).
