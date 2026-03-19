# VASP Oneshot Workflow

Sequential calculation workflow that runs the following in a single
Slurm job:

1. SCF — ground state charge density
2. DOS — density of states
3. Bands — electronic band structure
4. Zone-center phonons — Gamma-point DFPT
5. Born effective charges — Born charges + dielectric tensor
6. Dielectric tensor — macroscopic dielectric response
7. Elasticity — elastic constant tensor

Each stage uses the output of the previous where needed (e.g. bands
reads the SCF charge density). If a stage fails, the jobscript reports
the failure and stops.

## Files

| File | Description |
|---|---|
| `01_setup.sh` | All input files live here: POSCAR, INCARs, KPOINTS |
| `jobscript.sh` | Slurm script that calls 01_setup.sh then runs each stage |
| `POTCAR` | Not included — place your POTCAR here |

## Usage

```bash
# Place your POTCAR here, then:
bash 01_setup.sh    # verify inputs look correct
sbatch jobscript.sh
```

## Directory structure created by 01_setup.sh

```
run/
    scf/
        INCAR  KPOINTS  POSCAR  POTCAR
    dos/
        INCAR  KPOINTS  POSCAR  POTCAR  CHGCAR -> ../scf/CHGCAR
    bands/
        INCAR  KPOINTS  POSCAR  POTCAR  CHGCAR -> ../scf/CHGCAR
    phonons_zone_center/
        INCAR  KPOINTS  POSCAR  POTCAR
    born_charges/
        INCAR  KPOINTS  POSCAR  POTCAR
    dielectric/
        INCAR  KPOINTS  POSCAR  POTCAR
    elasticity/
        INCAR  KPOINTS  POSCAR  POTCAR
```

## Output

Each stage writes its output to its own subdirectory under `run/`.
Key output files:

| Stage | Key output |
|---|---|
| scf | `run/scf/vasprun.xml`, `CHGCAR` |
| dos | `run/dos/DOSCAR`, `vasprun.xml` |
| bands | `run/bands/EIGENVAL`, `vasprun.xml` |
| phonons_zone_center | `run/phonons_zone_center/vasprun.xml` |
| born_charges | `run/born_charges/vasprun.xml` |
| dielectric | `run/dielectric/vasprun.xml` |
| elasticity | `run/elasticity/OUTCAR` |

## Post-processing

The `vasprun.xml` from `born_charges/` contains both the Hessian and
Born effective charges and is the primary input for
`structural-symmetry-tools`:

```bash
cp run/born_charges/vasprun.xml /path/to/analysis/
cp run/phonons_zone_center/vasprun.xml /path/to/analysis/  # if no LEPSILON
python /path/to/structural-symmetry-tools/scripts/get_phonon_mode_charges.py > output.txt
```

## Notes

- Total wall time for SrTiO3 (5-atom primitive cell) is roughly 2-4 hours
  on a single LS6 node depending on k-mesh density.
- The jobscript checks the exit code of each VASP call and stops on
  failure rather than proceeding with a bad result.
- Phonon dispersion is not included in oneshot — it requires a separate
  phonopy supercell workflow. See `../phonons_dispersion/`.
