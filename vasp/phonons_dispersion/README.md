# VASP Phonon Dispersion

Full phonon dispersion curves using DFPT + phonopy.
This workflow generates force constants on a supercell and post-processes
them with phonopy to produce the dispersion along a k-path.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 primitive cell (phonopy works from the primitive cell) |
| `INCAR` | DFPT input tags for supercell force constant calculation |
| `KPOINTS` | k-point mesh for the supercell |
| `POTCAR` | Not included — place your POTCAR here |
| `01_setup.sh` | Generates phonopy supercells and prepares VASP inputs |
| `jobscript.sh` | Slurm submission script |

## Workflow

```bash
# 1. Generate displaced supercells with phonopy
phonopy -d --dim="2 2 2" -c POSCAR

# 2. Run VASP on each displaced supercell
#    01_setup.sh handles this setup; jobscript.sh submits each one
bash 01_setup.sh
sbatch jobscript.sh

# 3. Collect forces and compute force constants
phonopy -f disp-*/vasprun.xml

# 4. Generate dispersion
phonopy --dim="2 2 2" -c POSCAR -p band.conf
```

## Key INCAR tags

| Tag | Value | Purpose |
|---|---|---|
| `IBRION` | `-1` | Single-point force calculation on each supercell |
| `NSW` | `0` | No ionic relaxation |
| `EDIFF` | `1E-8` | Tight convergence for accurate forces |
| `ISYM` | `0` | Disable symmetry (phonopy handles it) |

## Requirements

- phonopy (`pip install phonopy` in your virtual environment)

## Output

- `FORCE_SETS` — phonopy force sets file
- `band.yaml` — dispersion data for plotting
- `mesh.yaml` — phonon DOS data

## Notes

- The supercell size (`--dim`) should be large enough that the force
  constants decay to zero at the supercell boundary. For SrTiO3,
  2x2x2 is a reasonable starting point.
- phonopy uses its own POSCAR convention. Always use the phonopy-generated
  `SPOSCAR` files as input to VASP, not the original POSCAR.
- For non-analytical corrections (LO-TO splitting), provide Born effective
  charges and the dielectric tensor from `born_charges/` to phonopy via
  a BORN file.
