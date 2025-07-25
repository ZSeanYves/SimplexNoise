# 🎨 SimplexNoise: 2D / 3D / 4D Procedural Noise & fBm Library for MoonBit

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![License](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** is a lightweight, modular MoonBit library supporting high-performance 2D / 3D / 4D Simplex noise and multi-octave fractal Brownian motion (fBm). It features domain warping, tileable output, grayscale and color PNG rendering, and batch slicing. Suitable for procedural terrain, texture generation, cloud rendering, simulation, and research.

---

## 🚀 Features

* ✅ 2D / 3D / 4D Simplex Noise with seed & gradient control
* ✅ Multi-octave fractal Brownian motion (fBm)
* ✅ Domain Warping support (`strength~`)
* ✅ Tileable noise and fBm via periodic mapping (`pi~`)
* ✅ PNG image output: grayscale & RGB
* ✅ Batch slice output for 3D / 4D volumes
* ✅ Python-style gradient compatibility
* ✅ Full test suite including value ranges, comparisons, slice validation

---

## 📦 Installation

```bash
moon add ZSeanYves/SimplexNoise
```

Or manually in `moon.mod.json`:

```json
"import": ["ZSeanYves/SimplexNoise"]
```

---

## 🧑‍💻 Basic Usage

### 2D Color fBm with Domain Warping

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(6, 0.5, 2.0, 0.03)
let (_, grads) = @ZSeanYves/SimplexNoise.create2d(42)
@ZSeanYves/SimplexNoise.fbm2d_image("./fbm2d.png", 256, 256, 42, grads, config, true, false, strength~ = 2.5)
```

### Tileable 3D Grayscale fBm

```moonbit
let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = create3d(99)
@ZSeanYves/SimplexNoise.tfbm3d_image("./tile3d.png", 256, 256, 64, 99, 0.0, grads, config, pi~ = 3.14, true)
```

### 4D Slice Output (Batch)

```moonbit
let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
let (_, grads) = create4d(123)
@ZSeanYves/SimplexNoise.fbm4d_slices("./slices", 128, 128, 64, 123, grads, config, false, true, 10)
```

---

## 📘 API Overview

| Function         | Dim | Type  | Tileable | Warp | Slice | Output |
| ---------------- | --- | ----- | -------- | ---- | ----- | ------ |
| `noise2d_image`  | 2D  | basic | ❌        | ✅    | ❌     | PNG    |
| `fbm2d_image`    | 2D  | fBm   | ❌        | ✅    | ❌     | PNG    |
| `tnoise2d_image` | 2D  | basic | ✅        | ❌    | ❌     | PNG    |
| `tfbm2d_image`   | 2D  | fBm   | ✅        | ❌    | ❌     | PNG    |
| `noise3d_image`  | 3D  | basic | ❌        | ✅    | ❌     | PNG    |
| `fbm3d_image`    | 3D  | fBm   | ❌        | ✅    | ❌     | PNG    |
| `tnoise3d_image` | 3D  | basic | ✅        | ❌    | ❌     | PNG    |
| `tfbm3d_image`   | 3D  | fBm   | ✅        | ❌    | ❌     | PNG    |
| `noise3d_slices` | 3D  | basic | ❌        | ✅    | ✅     | PNG    |
| `fbm3d_slices`   | 3D  | fBm   | ❌        | ✅    | ✅     | PNG    |
| `noise4d_image`  | 4D  | basic | ❌        | ✅    | ❌     | PNG    |
| `fbm4d_image`    | 4D  | fBm   | ❌        | ✅    | ❌     | PNG    |
| `tnoise4d_image` | 4D  | basic | ✅        | ❌    | ❌     | PNG    |
| `tfbm4d_image`   | 4D  | fBm   | ✅        | ❌    | ❌     | PNG    |
| `noise4d_slices` | 4D  | basic | ❌        | ✅    | ✅     | PNG    |
| `fbm4d_slices`   | 4D  | fBm   | ❌        | ✅    | ✅     | PNG    |

---

## 🎛️ Parameters

| Parameter         | Description                         |
| ----------------- | ----------------------------------- |
| `width`, `height` | Output image size in pixels         |
| `depth`, `time`   | For 3D/4D tileable output           |
| `scale`           | Controls frequency of noise         |
| `seed`            | Determines permutation table        |
| `grads`           | Gradient vector table               |
| `z`, `w`          | Slice positions in 3D/4D            |
| `pi~`             | Controls tileability (default 3.14) |
| `strength~`       | Warp intensity (default 1.0)        |
| `useWarp`         | Enable domain warping               |
| `isGrayScale`     | Use grayscale or RGB                |

---

## 📂 Project Structure

```
SimplexNoise/
├── src/
│   ├── noise2d.mbt / noise3d.mbt / noise4d.mbt         # Core simplex noise
│   ├── fbm.mbt / fbm3d.mbt / fbm4d.mbt                 # fBm logic
│   ├── image_gen.mbt / slice.mbt                       # PNG output & slicing
│   ├── simplex_noise.mbt / SimplexNoise.mbti           # Public interface
│   └── simplex_noise_test.mbt                          # Full test suite
├── examples/                                           # Output images
├── moon.pkg.json / LICENSE / README.md
```

---

## ✅ Testing

```bash
moon test -p ZSeanYves/SimplexNoise
```

### 🔬 Test Coverage Includes

* ✔️ Noise value range checks (2D/3D/4D)
* ✔️ fBm vs basic comparison
* ✔️ Warp & Tileable effects
* ✔️ Grayscale vs RGB rendering
* ✔️ Batch slice tests
* ✔️ Custom gradient support
* ✔️ Python noise parity (snoise2/3/4, fbm)

Test images are saved under `src/examples/` and grouped into folders by type.

---

## 🧠 Roadmap

* 🎨 Normal map / analytic derivative output

---

## 📜 License

MIT License. See [LICENSE](./LICENSE) for details.
