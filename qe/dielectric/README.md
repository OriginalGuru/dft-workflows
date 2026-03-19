# QE Dielectric Tensor

Macroscopic static dielectric tensor using pw.x + ph.x.

Note: in practice this is run together with Born effective charges
and phonon frequencies in a single ph.x call with `epsil=.true.`
and `trans=.true.`. See `../born_charges/` for the combined workflow.
This directory is provided as a standalone reference.

## Files

| File | Description |
|---|---|
| `pw.in` | pw.x SCF input |
| `ph.in` | ph.x input with epsil=.true., trans=.false. |
| `01_setup.sh` | Checks inputs and prepares the run directory |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
bash 01_setup.sh
sbatch jobscript.sh
```

## Key ph.x input parameters

| Parameter | Value | Purpose |
|---|---|---|
| `epsil` | `.true.` | Compute dielectric tensor |
| `trans` | `.false.` | Skip phonon frequencies (dielectric only) |
| `ldisp` | `.false.` | Gamma point only |

## Output

- `ph.out` — electronic dielectric tensor
- The ionic contribution to the dielectric constant requires the
  Born charges and phonon frequencies and is computed in post-processing

## Notes

- The electronic (clamped-ion) dielectric tensor is written in `ph.out`
  under `Dielectric constant in cartesian axis`.
- For the full static dielectric constant (electronic + ionic),
  combine the Born charges from `../born_charges/` with the phonon
  frequencies using the Lyddane-Sachs-Teller relation or
  the Lorentz oscillator model in structural-symmetry-tools.
- Only meaningful for insulators and semiconductors.
