# QE Phonon Dispersion

Full phonon dispersion using pw.x + ph.x + q2r.x + matdyn.x.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x SCF input |
| `ph.in` | ph.x input for q-point grid |
| `q2r.in` | q2r.x input — Fourier transform to real-space force constants |
| `matdyn.in` | matdyn.x input — interpolate dispersion along k-path |
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

# Step 2: Phonons on q-point grid
ph.x < ph.in > ph.out

# Step 3: Fourier transform to real-space force constants
q2r.x < q2r.in > q2r.out

# Step 4: Interpolate dispersion along k-path
matdyn.x < matdyn.in > matdyn.out
```

## Key ph.x input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `ldisp` | `.true.` | Compute on full q-point grid |
| `nq1, nq2, nq3` | e.g. `4 4 4` | q-point mesh dimensions |
| `epsil` | `.true.` | Include Born charges for LO-TO splitting |
| `tr2_ph` | `1.0d-14` | Convergence threshold |
| `fildyn` | `'SrTiO3.dyn'` | Stem for dynamical matrix files |

## q2r.in example

```
&INPUT
  fildyn = 'SrTiO3.dyn'
  zasr   = 'simple'
  flfrc  = 'SrTiO3.fc'
/
```

## matdyn.in example

```
&INPUT
  asr     = 'simple'
  flfrc   = 'SrTiO3.fc'
  flfrq   = 'SrTiO3.freq'
  q_in_band_form = .true.
/
5
  0.0 0.0 0.0  40   ! Gamma
  0.5 0.0 0.0  40   ! X
  0.5 0.5 0.0  40   ! M
  0.0 0.0 0.0  40   ! Gamma
  0.5 0.5 0.5   1   ! R
```

## Output

- `SrTiO3.dyn*` — dynamical matrices at each q-point
- `SrTiO3.fc` — real-space force constants
- `SrTiO3.freq` — phonon frequencies along k-path for plotting

## Notes

- For LO-TO splitting, set `epsil=.true.` in ph.x to compute Born
  charges and the dielectric tensor alongside the phonons.
- The q-point mesh should be converged. For SrTiO3, a 4x4x4 mesh
  is a reasonable starting point.
- `zasr='simple'` in q2r.x enforces the acoustic sum rule. Use
  `'crystal'` for a stricter enforcement.
- ph.x with `ldisp=.true.` is computationally expensive. On LS6,
  use multiple nodes and MPI parallelization. Adjust the jobscript
  accordingly.
- matdyn.x is fast — it can be run interactively after ph.x completes.
