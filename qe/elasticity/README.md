# QE Elastic Constants

Full elastic constant tensor using pw.x + ph.x.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x SCF input |
| `ph.in` | ph.x input for elastic constants |
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

# Step 2: Elastic constants
ph.x < ph.in > ph.out
```

## Key ph.x input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `trans` | `.false.` | No phonon frequencies |
| `epsil` | `.false.` | No dielectric tensor |
| `ldisp` | `.false.` | Gamma only |
| `lelfield` | `.false.` | No electric field |
| `lraman` | `.false.` | No Raman |

## ph.in example

```
Elastic constants SrTiO3
&INPUTPH
  prefix      = 'SrTiO3'
  outdir      = './tmp'
  tr2_ph      = 1.0d-14
  trans       = .false.
  epsil       = .false.
  ldisp       = .false.
  lraman      = .false.
  elastic_constants = .true.
/
0.0 0.0 0.0
```

## Output

- `ph.out` — elastic constant tensor (kBar), compliance tensor,
  bulk and shear moduli, Poisson ratio

## Extracting results

```bash
grep -A 20 "Elastic constants" ph.out
grep -A 5 "Bulk modulus" ph.out
```

## Notes

- Start from a fully relaxed structure. Residual stress will corrupt
  the elastic constants.
- QE reports elastic constants in kBar. Divide by 10 to convert to GPa.
- For cubic SrTiO3, there are three independent constants: C11, C12, C44.
- This calculation is computationally expensive. Expect roughly 6x the
  cost of a single SCF.
- A well-converged SCF (`conv_thr=1d-10` or tighter) is recommended
  for accurate elastic constants.
