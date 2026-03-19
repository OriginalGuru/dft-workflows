# dft-workflows

VASP and Quantum ESPRESSO calculation workflows for TACC Lonestar6.

Each calculation type provides a ready-to-run directory containing input
files, a setup script, and a Slurm jobscript. SrTiO3 is used as the
consistent example structure throughout.

## Structure

```
vasp/
    scf/                    # Self-consistent field calculation
    relax/                  # Ionic and cell relaxation
    bands/                  # Electronic band structure
    dos/                    # Density of states
    phonons_zone_center/    # Zone-center phonons (DFPT, IBRION=8)
    phonons_dispersion/     # Phonon dispersion (phonopy + DFPT)
    born_charges/           # Born effective charges (LEPSILON=.TRUE.)
    dielectric/             # Dielectric tensor
    elasticity/             # Elastic constants (IBRION=6)
    oneshot/                # Sequential workflow: scf through elasticity
qe/
    scf/
    relax/
    bands/
    dos/
    phonons_zone_center/    # ph.x, Gamma point
    phonons_dispersion/     # ph.x + q2r.x + matdyn.x
    born_charges/
    dielectric/
    elasticity/
    oneshot/
```

## File conventions

Each calculation directory contains:

```
README.md       Description, required inputs, expected outputs, notes
01_setup.sh     Prepares input files; place POTCAR/pseudopotentials here
jobscript.sh    Slurm submission script for LS6
POSCAR          Example SrTiO3 structure (VASP) or structure input (QE)
INCAR           VASP input tags with comments (VASP only)
KPOINTS         k-point mesh (VASP only)
```

The `oneshot/` directories contain a more substantial `01_setup.sh` that
prepares inputs for all calculation stages and a single `jobscript.sh`
that runs them sequentially.

## POTCAR / pseudopotentials

VASP POTCAR files are licensed and cannot be distributed. Place your POTCAR
in the calculation directory before running. `01_setup.sh` will check for
its presence and exit with an error if it is missing.

QE pseudopotential files (`.UPF`) must be downloaded separately from
https://www.quantum-espresso.org/pseudopotentials or another source.
The `01_setup.sh` for each QE calculation notes which pseudopotentials
are required.

## Requirements

- VASP 6.4.2 (`module load vasp/6.4.2`)
- Quantum ESPRESSO 7.2 (`module load qe/7.2`)
- Python 3.9 (`module load python3/3.9.7`) for any pre/post-processing scripts

See `docs/lonestar6.md` in the `structural-symmetry-tools` repository for
virtual environment setup and general LS6 notes.

## Example system

All examples use SrTiO3 in the cubic perovskite structure (Space Group
Pm-3m, No. 221). Lattice parameter a = 3.905 Ang. This is a well-studied
system with known phonon instabilities and dielectric properties, making
it a useful reference for validating new setups.
