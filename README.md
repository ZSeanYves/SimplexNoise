# 🎨 SimplexNoise: 2D / 3D Simplex Noise & fBm Library for MoonBit

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![License](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** is a lightweight MoonBit noise library supporting 2D, 3D, and 4D Simplex noise, multi-octave fractal Brownian motion (fBm) noise, grayscale and color image output. It is suitable for terrain generation, clouds, procedural textures, volumetric noise visualization, and educational use.

---

## 🚀 Features

* ✅ 2D, 3D, and 4D Simplex Noise with seed control
* ✅ Multi-Octave fBm Noise (octaves, persistence, lacunarity, scale)
* ✅ Grayscale & Color PNG Image Output
* ✅ 3D/4D Single Slice and Batch Slice Support
* ✅ Configurable Color Mapping
* ✅ Clean, Modular & Extensible MoonBit Design

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

## 🎨 Basic Usage Examples

### 2D Grayscale Noise Image

```moonbit
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise_image("./noise.png", 256, 256, 0.05, 42, grads)
```

### 2D Color fBm Noise Image

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(123)
@ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./fbm_color.png", 256, 256, 123, grads, config)
```

### 3D Noise Slice Image

```moonbit
let (_, grads3d) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise3d_image("./slice.png", 256, 256, 0.05, 0.3, 42, grads3d)
```

### 4D Noise Slice Image

```moonbit
let (_, grads4d) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise4d_image("./slice4d.png", 256, 256, 0.05, 0.3, 0.6, 42, grads4d)
```

---

## 📘 API Overview

### 2D Noise

| Function                                | Description                                |
| --------------------------------------- | ------------------------------------------ |
| `generate_and_save_noise_image`         | Generate grayscale 2D Simplex noise image  |
| `generate_and_save_fbm_image`           | Generate grayscale 2D fBm noise image      |
| `generate_and_save_noise_image_color`   | Generate color 2D Simplex noise image      |
| `generate_and_save_fbm_image_color`     | Generate color 2D fBm noise image          |

### 3D Noise

| Function                                  | Description                                    |
| ----------------------------------------- | ---------------------------------------------- |
| `generate_and_save_noise3d_image`         | Generate grayscale 3D Simplex noise slice      |
| `generate_and_save_fbm3d_image`           | Generate grayscale 3D fBm noise slice          |
| `generate_and_save_noise3d_image_color`   | Generate color 3D Simplex noise slice          |
| `generate_and_save_fbm3d_image_color`     | Generate color 3D fBm noise slice              |
| `generate_3d_slices`                      | Batch generate grayscale 3D noise slices       |
| `generate_fbm3d_slices`                   | Batch generate grayscale 3D fBm noise slices   |
| `generate_3d_slices_color`                | Batch generate color 3D noise slices           |
| `generate_fbm3d_slices_color`             | Batch generate color 3D fBm noise slices       |

### 4D Noise

| Function                                  | Description                                     |
| ----------------------------------------- | ----------------------------------------------- |
| `generate_and_save_noise4d_image`         | Generate grayscale 4D Simplex noise slice       |
| `generate_and_save_fbm4d_image`           | Generate grayscale 4D fBm noise slice           |

---

## 🎛️ Parameter Meaning

| Parameter       | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `width`, `height` | Image dimensions in pixels                                                  |
| `scale`         | Controls noise frequency. Lower = zoomed out; Higher = more detail         |
| `z`, `w`        | For 3D/4D noise, fixed slice depth values                                  |
| `seed`          | Random seed to generate gradient table                                      |
| `grads`         | Precomputed gradient vectors from seed                                      |
| `config`        | fBm config object: `NoiseConfig(octaves, persistence, lacunarity, scale)`  |
| `octaves`       | Number of fBm layers. More = more detail                                    |
| `persistence`   | Amplitude scaling per octave (commonly ~0.5)                                |
| `lacunarity`    | Frequency scaling per octave (commonly ~2.0)                               |

---

## 📂 Project Structure

```
SimplexNoise/
├── src/
│   ├── fbm.mbt                     # 2D fBm noise logic
│   ├── fbm3d.mbt                   # 3D fBm noise logic
│   ├── image_gen.mbt               # Image output (2D, 3D, 4D)
│   ├── noise2d.mbt                 # 2D Simplex noise core
│   ├── noise3d.mbt                 # 3D Simplex noise core
│   ├── random.mbt                  # Seed-based permutation & gradient table
│   ├── simplex_noise.mbt           # Public API wrapper
│   ├── simplex_noise_tests.mbt     # Unit tests
│   ├── SimplexNoise.mbti           # Interface and type exports
│   └── moon.pkg.json               # Package metadata
├── examples/                       # Example output images
├── LICENSE
└── README.md
```

---

## 🧪 Testing

```bash
moon test -p ZSeanYves/simplexnoise
```

---

## ⚡ Future Work

* 🔄 Tileable noise & domain warping extensions
* ⛏️ Analytic derivatives (normal map generation)

---

## 📜 License

MIT License. See [LICENSE](./LICENSE) for details.
