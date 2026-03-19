# VASP Born Effective Charges

Born effective charge tensors and macroscopic dielectric tensor via DFPT
with LEPSILON=.TRUE. These are needed for mode effective charges in
structural-symmetry-tools and for LO-TO splitting in phonon dispersion.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 relaxed structure |
| `INCAR` | DFPT input tags with LEPSILON=.TRUE. |
| `KPOINTS` | Gamma-centered k-point mesh |
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
| `IBRION` | `8` | DFPT |
| `NSW` | `1` | Required for IBRION=8 |
| `LEPSILON` | `.TRUE.` | Compute Born charges and dielectric tensor |
| `EDIFF` | `1E-8` | Tight electronic convergence |
| `LWAVE` | `.FALSE.` | Do not write WAVECAR (large file, not needed) |

## Output

- `vasprun.xml` — Born charges under `<array name="born_charges">`,
  dielectric tensor under `<varray name="dielectric_dft">`
- `OUTCAR` — Born charges and dielectric tensor in text format

## Post-processing with structural-symmetry-tools

The `vasprun.xml` from this calculation contains both the Hessian and
Born charges when run with `IBRION=8` and `LEPSILON=.TRUE.`:

```bash
python scripts/get_phonon_mode_charges.py > output.txt
```

Mode effective charges will use the full calculated BEC tensors rather
than the rigid-ion approximation.

## Notes

- This calculation combines `phonons_zone_center` and `dielectric` in
  one run. There is no need to run them separately.
- The charge neutrality sum rule is not enforced by VASP. Small violations
  are normal. structural-symmetry-tools includes sum rule correction
  functions (`apply_charge_sum_rule_uniform`,
  `apply_charge_sum_rule_weighted`) if needed.
- Born charges are only meaningful for insulators and semiconductors.
  Do not use for metals.
