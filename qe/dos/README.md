# QE Density of States

Total and projected density of states using pw.x + dos.x + projwfc.x.
Requires a converged charge density from a prior SCF calculation.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x NSCF input with dense k-mesh |
| `dos.in` | dos.x input for total DOS |
| `projwfc.in` | projwfc.x input for projected DOS |
| `01_setup.sh` | Checks SCF outdir, prepares inputs |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
bash 01_setup.sh
sbatch jobscript.sh
```

## Workflow

```bash
# Step 1: NSCF calculation on dense k-mesh
pw.x < pw.in > pw.out

# Step 2: Total DOS
dos.x < dos.in > dos.out

# Step 3: Projected DOS (optional)
projwfc.x < projwfc.in > projwfc.out
```

## Key input parameters (pw.in)

| Parameter | Value | Purpose |
|---|---|---|
| `calculation` | `'nscf'` | Non-self-consistent on dense mesh |
| `occupations` | `'tetrahedra'` | Best for DOS of insulators |
| `nbnd` | set explicitly | Include enough empty bands |

## Output

- `prefix.dos` — total DOS: energy, DOS, integrated DOS
- `prefix.pdos_tot` — total projected DOS
- `prefix.pdos_atm#*` — projected DOS per atom and orbital

## Notes

- The NSCF k-mesh should be denser than the SCF mesh. For SrTiO3,
  a 12x12x12 mesh gives a well-converged DOS.
- `outdir` and `prefix` must match the SCF calculation.
- `occupations='tetrahedra'` gives the best DOS quality for
  insulators and semiconductors. Use `'smearing'` for metals.
- projwfc.x decomposes the DOS onto atomic orbitals and is useful
  for identifying band character.
