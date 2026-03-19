# VASP Zone-Center Phonons

Phonon frequencies and eigenvectors at the Gamma point using DFPT (IBRION=8).
The output vasprun.xml is the primary input for structural-symmetry-tools.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 relaxed structure |
| `INCAR` | DFPT input tags |
| `KPOINTS` | k-point mesh (Gamma-centered) |
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
| `IBRION` | `8` | DFPT — linear response |
| `NSW` | `1` | One ionic step (required for IBRION=8) |
| `EDIFF` | `1E-8` | Tight electronic convergence for DFPT |
| `ENCUT` | species-dependent | Plane wave cutoff |
| `LEPSILON` | `.FALSE.` | No Born charges (set .TRUE. for born_charges/) |

## Output

- `vasprun.xml` — contains the Hessian matrix under `<varray name="hessian">`
- `OUTCAR` — phonon frequencies and eigenvectors in text format

## Post-processing with structural-symmetry-tools

```bash
# Copy vasprun.xml and POSCAR to your analysis directory alongside
# symmetry_basis and symmetry_list from ISODISTORT, then:
python scripts/get_phonon_mode_charges.py > output.txt
```

See the `structural-symmetry-tools` repository for full details.

## Notes

- Start from a well-relaxed structure. Residual forces degrade the
  quality of the force constants and phonon frequencies.
- Use a Gamma-centered k-mesh (add Gamma in KPOINTS) for DFPT.
- `EDIFF=1E-8` is tighter than a standard SCF — DFPT is sensitive
  to the quality of the self-consistent ground state.
- For Born effective charges and the dielectric tensor, use the
  `born_charges/` workflow (`LEPSILON=.TRUE.`).
