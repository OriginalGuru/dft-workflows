# dft-workflows

VASP and Quantum ESPRESSO calculation workflows for TACC Lonestar6.

Each calculation type provides a ready-to-run directory containing input
files and a Slurm jobscript. SrTiO₃ is used as the consistent example
structure throughout.

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

Each calculation directory contains at minimum:

```
README.md       Description, required inputs, expected outputs, notes
jobscript.sh    Slurm submission script for LS6
```

VASP directories additionally contain:
```
POSCAR          Example SrTiO3 structure
INCAR           VASP input tags with comments
KPOINTS         k-point mesh
```

QE directories additionally contain:
```
scf.in / ph.in / ...    pw.x or ph.x input file for that calculation type
```

The `oneshot/` directories contain a single `jobscript.sh` that runs all
calculation stages sequentially.

## POTCAR / pseudopotentials

VASP POTCAR files are licensed and cannot be distributed. Place your POTCAR
in the calculation directory before running.

QE pseudopotential files (`.UPF`) must be downloaded separately. Each QE
calculation `README.md` lists the required files and provides `wget` commands
to download them from the
[Quantum ESPRESSO pseudopotential library](https://pseudopotentials.quantum-espresso.org/legacy_tables).

## Requirements

- VASP 6.4.2 (`module load vasp/6.4.2`)
- Quantum ESPRESSO 7.3 (`module load qe/7.3`)
- Python 3.9 (`module load python3/3.9.7`) for any pre/post-processing scripts

For virtual environment setup and general LS6 notes, see `docs/lonestar6.md`
in the `structural-symmetry-tools` repository (pull that repo separately).

## Example system

All examples use SrTiO₃ in the cubic perovskite structure (space group
*Pm*3̄*m*, No. 221), lattice parameter *a* = 3.905 Å. This is a well-studied
system with known phonon instabilities and dielectric properties, making it
a useful reference for validating new setups.
